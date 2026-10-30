/* =========================================================
   04_trg_mssql.sql
   ========================================================= */
------------------------------------------------------------
-- TRIGGER 1: Sale rules + car status sync
------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_sale_aiu
ON sale
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CompletedId INT, @PendingId INT, @OnHoldId INT, @CancelledId INT, @RefundedId INT;

    SELECT @CompletedId = sale_status_id FROM sale_status WHERE name = N'COMPLETED';
    SELECT @PendingId   = sale_status_id FROM sale_status WHERE name = N'PENDING';
    SELECT @OnHoldId    = sale_status_id FROM sale_status WHERE name = N'ON_HOLD';
    SELECT @CancelledId = sale_status_id FROM sale_status WHERE name = N'CANCELLED';
    SELECT @RefundedId  = sale_status_id FROM sale_status WHERE name = N'REFUNDED';

    IF @CompletedId IS NULL OR @PendingId IS NULL OR @OnHoldId IS NULL OR @CancelledId IS NULL OR @RefundedId IS NULL
    BEGIN
        RAISERROR('Required sale_status rows are missing.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- New sale must start as PENDING or ON_HOLD
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN deleted d ON d.sale_id = i.sale_id
        WHERE d.sale_id IS NULL
          AND i.sale_status_id NOT IN (@PendingId, @OnHoldId)
    )
    BEGIN
        RAISERROR('New sale must start as PENDING or ON_HOLD.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    -- Car cannot be SOLD or IN_SERVICE
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN car c ON c.car_id = i.car_id
        WHERE c.status IN (N'SOLD', N'IN_SERVICE')
    )
    BEGIN
        RAISERROR('Cannot create/update sale for a SOLD or IN_SERVICE car.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    -- Completed sale cannot change car_id
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON d.sale_id = i.sale_id
        WHERE i.car_id <> d.car_id
          AND d.sale_status_id = @CompletedId
    )
    BEGIN
        RAISERROR('Cannot change car_id of a COMPLETED sale.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    -- Reserve car when sale is PENDING / ON_HOLD
    UPDATE c
       SET c.status = N'RESERVED'
    FROM car c
    JOIN inserted i ON i.car_id = c.car_id
    WHERE i.sale_status_id IN (@PendingId, @OnHoldId)
      AND c.status = N'AVAILABLE';

    -- If status set to COMPLETED, ensure payment >= price
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.sale_status_id = @CompletedId
          AND (
                SELECT COALESCE(SUM(p.amount),0)
                FROM payment p
                WHERE p.sale_id = i.sale_id
              ) < i.sale_price
    )
    BEGIN
        RAISERROR('Cannot set COMPLETED: total paid < sale price.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    -- Completed => car SOLD
    UPDATE c
       SET c.status = N'SOLD'
    FROM car c
    JOIN inserted i ON i.car_id = c.car_id
    WHERE i.sale_status_id = @CompletedId;

    -- Cancelled/Refunded => car AVAILABLE (if no other open sale)
    UPDATE c
       SET c.status = N'AVAILABLE'
    FROM car c
    JOIN inserted i ON i.car_id = c.car_id
    WHERE i.sale_status_id IN (@CancelledId, @RefundedId)
      AND c.status = N'RESERVED'
      AND NOT EXISTS (
            SELECT 1
            FROM sale s2
            WHERE s2.car_id = i.car_id
              AND s2.sale_id <> i.sale_id
              AND s2.sale_status_id IN (@PendingId, @OnHoldId)
      );
END;
GO

------------------------------------------------------------
-- TRIGGER 2: Payment rules (no overpay; auto-complete)
------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_payment_aiu
ON payment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CompletedId INT;
    SELECT @CompletedId = sale_status_id
    FROM sale_status
    WHERE name = N'COMPLETED';

    IF @CompletedId IS NULL
    BEGIN
        RAISERROR('sale_status COMPLETED not found.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    DECLARE @affected_sales TABLE (sale_id INT PRIMARY KEY);
    INSERT INTO @affected_sales(sale_id)
    SELECT DISTINCT sale_id
    FROM inserted;

    -- Overpay check
    IF EXISTS (
        SELECT 1
        FROM @affected_sales a
        JOIN sale s ON s.sale_id = a.sale_id
        CROSS APPLY (
            SELECT COALESCE(SUM(p.amount),0) AS total_paid
            FROM payment p
            WHERE p.sale_id = a.sale_id
        ) t
        WHERE t.total_paid > s.sale_price
    )
    BEGIN
        RAISERROR('Total paid exceeds sale price (overpayment not allowed).', 16, 1);
        ROLLBACK;
        RETURN;
    END

    -- Auto-complete when fully paid
    UPDATE s
       SET s.sale_status_id = @CompletedId
    FROM sale s
    JOIN @affected_sales a ON a.sale_id = s.sale_id
    WHERE s.sale_status_id <> @CompletedId
      AND (
            SELECT COALESCE(SUM(p.amount),0)
            FROM payment p
            WHERE p.sale_id = s.sale_id
          ) = s.sale_price;
END;
GO
