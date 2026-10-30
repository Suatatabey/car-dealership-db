/* 04_trg_oracle.sql */

-- TRIGGER #1 (Row-level): Sale rules + car status sync
CREATE OR REPLACE TRIGGER trg_sale_biud
BEFORE INSERT OR UPDATE OF sale_status_id, car_id ON sale
FOR EACH ROW
DECLARE
    v_new_status_name   sale_status.name%TYPE;
    v_old_status_name   sale_status.name%TYPE;
    v_car_status        car.status%TYPE;
    v_total_paid        NUMBER(12,2);
    v_other_open        NUMBER;
BEGIN
    SELECT name INTO v_new_status_name
      FROM sale_status
     WHERE sale_status_id = :NEW.sale_status_id;

    IF UPDATING THEN
        SELECT name INTO v_old_status_name
          FROM sale_status
         WHERE sale_status_id = :OLD.sale_status_id;
    END IF;

    IF INSERTING THEN
        IF v_new_status_name NOT IN ('PENDING','ON_HOLD') THEN
            RAISE_APPLICATION_ERROR(-20010, 'New sale must start as PENDING or ON_HOLD.');
        END IF;

        SELECT status INTO v_car_status
          FROM car
         WHERE car_id = :NEW.car_id
         FOR UPDATE;

        IF v_car_status = 'SOLD' THEN
            RAISE_APPLICATION_ERROR(-20011, 'Cannot create sale for a SOLD car.');
        END IF;

        IF v_car_status = 'IN_SERVICE' THEN
            RAISE_APPLICATION_ERROR(-20012, 'Cannot create sale for a car that is IN_SERVICE.');
        END IF;

        UPDATE car
           SET status = 'RESERVED'
         WHERE car_id = :NEW.car_id
           AND status = 'AVAILABLE';
    END IF;

    IF UPDATING THEN
        IF :OLD.car_id <> :NEW.car_id THEN
            IF v_old_status_name = 'COMPLETED' THEN
                RAISE_APPLICATION_ERROR(-20013, 'Cannot change car_id of a COMPLETED sale.');
            END IF;
        END IF;

        IF v_new_status_name IN ('PENDING','ON_HOLD') THEN
            UPDATE car
               SET status = 'RESERVED'
             WHERE car_id = :NEW.car_id
               AND status = 'AVAILABLE';

        ELSIF v_new_status_name = 'COMPLETED' THEN
            SELECT NVL(SUM(amount),0) INTO v_total_paid
              FROM payment
             WHERE sale_id = :NEW.sale_id;

            IF v_total_paid < :NEW.sale_price THEN
                RAISE_APPLICATION_ERROR(-20014, 'Cannot set COMPLETED: total paid < sale price.');
            END IF;

            UPDATE car
               SET status = 'SOLD'
             WHERE car_id = :NEW.car_id;

        ELSIF v_new_status_name IN ('CANCELLED','REFUNDED') THEN
            SELECT COUNT(*)
              INTO v_other_open
              FROM sale s
              JOIN sale_status ss ON ss.sale_status_id = s.sale_status_id
             WHERE s.car_id = :NEW.car_id
               AND s.sale_id <> :NEW.sale_id
               AND ss.name IN ('PENDING','ON_HOLD');

            IF v_other_open = 0 THEN
                UPDATE car
                   SET status = 'AVAILABLE'
                 WHERE car_id = :NEW.car_id
                   AND status = 'RESERVED';
            END IF;
        END IF;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20015, 'Invalid sale_status_id (not found).');
END;
/

-- TRIGGER #2 (Compound): Payment overpay prevention + auto-complete

CREATE OR REPLACE TRIGGER trg_payment_compound
FOR INSERT OR UPDATE ON payment
COMPOUND TRIGGER
    TYPE t_sale_ids IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    g_sale_ids t_sale_ids;
    g_count    PLS_INTEGER := 0;

    AFTER EACH ROW IS
    BEGIN
        g_count := g_count + 1;
        g_sale_ids(g_count) := :NEW.sale_id;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_sale_id       NUMBER;
        v_sale_price    sale.sale_price%TYPE;
        v_total_paid    NUMBER(12,2);
        v_status_name   sale_status.name%TYPE;
        v_completed_id  sale_status.sale_status_id%TYPE;

        FUNCTION already_seen(p_id NUMBER, p_until PLS_INTEGER) RETURN BOOLEAN IS
        BEGIN
            FOR i IN 1..p_until LOOP
                IF g_sale_ids(i) = p_id THEN
                    RETURN TRUE;
                END IF;
            END LOOP;
            RETURN FALSE;
        END;
    BEGIN
        SELECT sale_status_id INTO v_completed_id
          FROM sale_status
         WHERE name = 'COMPLETED';

        FOR i IN 1..g_count LOOP
            v_sale_id := g_sale_ids(i);

            IF already_seen(v_sale_id, i-1) THEN
                CONTINUE;
            END IF;

            SELECT s.sale_price, ss.name
              INTO v_sale_price, v_status_name
              FROM sale s
              JOIN sale_status ss ON ss.sale_status_id = s.sale_status_id
             WHERE s.sale_id = v_sale_id;

            SELECT NVL(SUM(amount),0) INTO v_total_paid
              FROM payment
             WHERE sale_id = v_sale_id;

            IF v_total_paid > v_sale_price THEN
                RAISE_APPLICATION_ERROR(
                    -20020,
                    'Total paid ('||v_total_paid||') exceeds sale price ('||v_sale_price||') for sale_id='||v_sale_id
                );
            END IF;

            IF v_total_paid = v_sale_price AND v_status_name <> 'COMPLETED' THEN
                UPDATE sale
                   SET sale_status_id = v_completed_id
                 WHERE sale_id = v_sale_id;
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END;
/
