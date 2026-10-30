/* =========================================================
   03_proc_mssql.sql
   ========================================================= */
------------------------------------------------------------
-- PROCEDURE 1: Finalize Sale
------------------------------------------------------------
CREATE OR ALTER PROCEDURE usp_FinalizeSale
    @SaleId   INT,
    @Message  NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SalePrice   DECIMAL(10,2),
            @CarId       INT,
            @StatusName  NVARCHAR(30),
            @CompletedId INT,
            @TotalPaid   DECIMAL(12,2);

    SELECT @CompletedId = sale_status_id
    FROM sale_status
    WHERE name = N'COMPLETED';

    IF @CompletedId IS NULL
    BEGIN
        RAISERROR('sale_status COMPLETED not found.', 16, 1);
        RETURN;
    END

    SELECT @SalePrice  = s.sale_price,
           @CarId      = s.car_id,
           @StatusName = ss.name
    FROM sale s
    JOIN sale_status ss ON ss.sale_status_id = s.sale_status_id
    WHERE s.sale_id = @SaleId;

    IF @SalePrice IS NULL
    BEGIN
        RAISERROR('Sale not found.', 16, 1);
        RETURN;
    END

    IF @StatusName = N'COMPLETED'
    BEGIN
        SET @Message = N'Sale already COMPLETED.';
        RETURN;
    END

    SELECT @TotalPaid = COALESCE(SUM(p.amount), 0)
    FROM payment p
    WHERE p.sale_id = @SaleId;

    IF @TotalPaid < @SalePrice
    BEGIN
        RAISERROR('Cannot finalize sale. Total paid is less than sale price.', 16, 1);
        RETURN;
    END

    UPDATE sale
       SET sale_status_id = @CompletedId
     WHERE sale_id = @SaleId;

    UPDATE car
       SET status = N'SOLD'
     WHERE car_id = @CarId;

    SET @Message = N'Sale finalized. Status set to COMPLETED and car set to SOLD.';
END;
GO

------------------------------------------------------------
-- PROCEDURE 2 (Cursor): Monthly KPIs
------------------------------------------------------------
CREATE OR ALTER PROCEDURE usp_MonthlyKpis
    @Year INT,
    @Month INT,
    @SalesTotal DECIMAL(12,2) OUTPUT,
    @ServiceTotal DECIMAL(12,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = DATEFROMPARTS(@Year, @Month, 1);
    DECLARE @EndDate   DATE = DATEADD(MONTH, 1, @StartDate);

    DECLARE @CompletedId INT;
    SELECT @CompletedId = sale_status_id
    FROM sale_status
    WHERE name = N'COMPLETED';

    IF @CompletedId IS NULL
    BEGIN
        RAISERROR('sale_status COMPLETED not found.', 16, 1);
        RETURN;
    END

    DECLARE @SalesSum DECIMAL(12,2) = 0;
    DECLARE @ServiceSum DECIMAL(12,2) = 0;

    DECLARE @SaleId INT, @SalePrice DECIMAL(10,2);

    DECLARE c_sales CURSOR LOCAL FAST_FORWARD FOR
        SELECT s.sale_id, s.sale_price
        FROM sale s
        WHERE s.sale_status_id = @CompletedId
          AND s.sale_date >= @StartDate
          AND s.sale_date <  @EndDate;

    OPEN c_sales;
    FETCH NEXT FROM c_sales INTO @SaleId, @SalePrice;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @SalesSum += @SalePrice;
        FETCH NEXT FROM c_sales INTO @SaleId, @SalePrice;
    END

    CLOSE c_sales;
    DEALLOCATE c_sales;

    DECLARE @ServiceRecordId INT, @LaborCost DECIMAL(10,2), @PartsSum DECIMAL(12,2);

    DECLARE c_services CURSOR LOCAL FAST_FORWARD FOR
        SELECT sr.service_record_id, sr.labor_cost
        FROM service_record sr
        WHERE sr.service_date >= @StartDate
          AND sr.service_date <  @EndDate;

    OPEN c_services;
    FETCH NEXT FROM c_services INTO @ServiceRecordId, @LaborCost;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @PartsSum = COALESCE(SUM(pu.quantity * pu.unit_price_at_service), 0)
        FROM parts_used pu
        WHERE pu.service_record_id = @ServiceRecordId;

        SET @ServiceSum += @LaborCost + @PartsSum;

        FETCH NEXT FROM c_services INTO @ServiceRecordId, @LaborCost;
    END

    CLOSE c_services;
    DEALLOCATE c_services;

    SET @SalesTotal = @SalesSum;
    SET @ServiceTotal = @ServiceSum;

    PRINT CONCAT('KPI ', CONVERT(varchar(7), @StartDate, 120), ':');
    PRINT CONCAT('  Completed sales total: ', @SalesTotal);
    PRINT CONCAT('  Service total (labor+parts): ', @ServiceTotal);
END;
GO

