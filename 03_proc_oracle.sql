/* 03_proc_oracle.sql */

SET SERVEROUTPUT ON;

-- PROCEDURE #1: Finalize Sale
CREATE OR REPLACE PROCEDURE sp_finalize_sale(
    p_sale_id IN  NUMBER,
    p_message OUT VARCHAR2
) AS
    v_sale_price      sale.sale_price%TYPE;
    v_car_id          sale.car_id%TYPE;
    v_status_id       sale.sale_status_id%TYPE;
    v_status_name     sale_status.name%TYPE;
    v_completed_id    sale_status.sale_status_id%TYPE;
    v_total_paid      NUMBER(12,2);
BEGIN
    SELECT sale_status_id
      INTO v_completed_id
      FROM sale_status
     WHERE name = 'COMPLETED';

    SELECT s.sale_price, s.car_id, s.sale_status_id
      INTO v_sale_price, v_car_id, v_status_id
      FROM sale s
     WHERE s.sale_id = p_sale_id;

    SELECT name
      INTO v_status_name
      FROM sale_status
     WHERE sale_status_id = v_status_id;

    IF v_status_name = 'COMPLETED' THEN
        p_message := 'Sale already COMPLETED.';
        RETURN;
    END IF;

    SELECT NVL(SUM(amount), 0)
      INTO v_total_paid
      FROM payment
     WHERE sale_id = p_sale_id;

    IF v_total_paid < v_sale_price THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Cannot finalize sale. Total paid (' || v_total_paid || ') < sale price (' || v_sale_price || ').'
        );
    END IF;

    UPDATE sale
       SET sale_status_id = v_completed_id
     WHERE sale_id = p_sale_id;

    UPDATE car
       SET status = 'SOLD'
     WHERE car_id = v_car_id;

    p_message := 'Sale finalized. Status set to COMPLETED and car set to SOLD.';
END;
/
-- PROCEDURE #2 (Cursor): Monthly KPIs

CREATE OR REPLACE PROCEDURE sp_monthly_kpis (
    p_year          IN  NUMBER,
    p_month         IN  NUMBER,
    o_sales_total   OUT NUMBER,
    o_service_total OUT NUMBER
) AS
    v_start_date DATE;
    v_end_date   DATE;

    v_completed_id sale_status.sale_status_id%TYPE;

    v_sales_total   NUMBER(12,2) := 0;
    v_service_total NUMBER(12,2) := 0;

    CURSOR c_sales IS
        SELECT s.sale_id, s.sale_price
          FROM sale s
         WHERE s.sale_status_id = v_completed_id
           AND s.sale_date >= v_start_date
           AND s.sale_date <  v_end_date;

    CURSOR c_services IS
        SELECT sr.service_record_id, sr.labor_cost
          FROM service_record sr
         WHERE sr.service_date >= v_start_date
           AND sr.service_date <  v_end_date;

    v_parts_sum NUMBER(12,2);
BEGIN
    v_start_date := TO_DATE(p_year || '-' || LPAD(p_month,2,'0') || '-01', 'YYYY-MM-DD');
    v_end_date   := ADD_MONTHS(v_start_date, 1);

    SELECT sale_status_id
      INTO v_completed_id
      FROM sale_status
     WHERE name = 'COMPLETED';

    FOR r IN c_sales LOOP
        v_sales_total := v_sales_total + r.sale_price;
    END LOOP;

    FOR r IN c_services LOOP
        SELECT NVL(SUM(pu.quantity * pu.unit_price_at_service), 0)
          INTO v_parts_sum
          FROM parts_used pu
         WHERE pu.service_record_id = r.service_record_id;

        v_service_total := v_service_total + r.labor_cost + v_parts_sum;
    END LOOP;

    o_sales_total := v_sales_total;
    o_service_total := v_service_total;

    DBMS_OUTPUT.PUT_LINE('KPI ' || TO_CHAR(v_start_date,'YYYY-MM') || ':');
    DBMS_OUTPUT.PUT_LINE('  Completed sales total: ' || o_sales_total);
    DBMS_OUTPUT.PUT_LINE('  Service total (labor+parts): ' || o_service_total);
END;
/
