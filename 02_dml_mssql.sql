USE [2019SBD];
GO
/* =========================================================
   02_dml_mssql.sql
   ========================================================= */

/* ===== manufacturer ===== */
SET IDENTITY_INSERT manufacturer ON;

IF NOT EXISTS (SELECT 1 FROM manufacturer WHERE manufacturer_id = 1)
    INSERT INTO manufacturer (manufacturer_id, name, country)
    VALUES (1, N'Toyota', N'Japan');

IF NOT EXISTS (SELECT 1 FROM manufacturer WHERE manufacturer_id = 2)
    INSERT INTO manufacturer (manufacturer_id, name, country)
    VALUES (2, N'Dodge', N'USA');

IF NOT EXISTS (SELECT 1 FROM manufacturer WHERE manufacturer_id = 3)
    INSERT INTO manufacturer (manufacturer_id, name, country)
    VALUES (3, N'BMW', N'Germany');

IF NOT EXISTS (SELECT 1 FROM manufacturer WHERE manufacturer_id = 4)
    INSERT INTO manufacturer (manufacturer_id, name, country)
    VALUES (4, N'Honda', N'Japan');

IF NOT EXISTS (SELECT 1 FROM manufacturer WHERE manufacturer_id = 5)
    INSERT INTO manufacturer (manufacturer_id, name, country)
    VALUES (5, N'Mercedes-Benz', N'Germany');

SET IDENTITY_INSERT manufacturer OFF;
GO


/* ===== car_model ===== */
SET IDENTITY_INSERT car_model ON;

IF NOT EXISTS (SELECT 1 FROM car_model WHERE car_model_id = 1)
    INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type)
    VALUES (1, 1, N'Corolla', N'Sedan');

IF NOT EXISTS (SELECT 1 FROM car_model WHERE car_model_id = 2)
    INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type)
    VALUES (2, 2, N'Charger', N'Sedan');

IF NOT EXISTS (SELECT 1 FROM car_model WHERE car_model_id = 3)
    INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type)
    VALUES (3, 3, N'650i', N'Coupe');

IF NOT EXISTS (SELECT 1 FROM car_model WHERE car_model_id = 4)
    INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type)
    VALUES (4, 4, N'S2000', N'Roadster');

IF NOT EXISTS (SELECT 1 FROM car_model WHERE car_model_id = 5)
    INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type)
    VALUES (5, 5, N'E500', N'Sedan');

SET IDENTITY_INSERT car_model OFF;
GO


/* ===== car ===== */
SET IDENTITY_INSERT car ON;

IF NOT EXISTS (SELECT 1 FROM car WHERE car_id = 1)
    INSERT INTO car (car_id, car_model_id, vin, [year], color, mileage, list_price, status)
    VALUES (1, 1, N'JTDBR32E330123456', 2021, N'Black', 35000, 18500.00, N'AVAILABLE');

IF NOT EXISTS (SELECT 1 FROM car WHERE car_id = 2)
    INSERT INTO car (car_id, car_model_id, vin, [year], color, mileage, list_price, status)
    VALUES (2, 2, N'1FAFP34P12W123457', 2019, N'Blue', 52000, 27900.00, N'RESERVED');

IF NOT EXISTS (SELECT 1 FROM car WHERE car_id = 3)
    INSERT INTO car (car_id, car_model_id, vin, [year], color, mileage, list_price, status)
    VALUES (3, 3, N'WBA8E9G57GNU12345', 2017, N'White', 41000, 34900.00, N'SOLD');

IF NOT EXISTS (SELECT 1 FROM car WHERE car_id = 4)
    INSERT INTO car (car_id, car_model_id, vin, [year], color, mileage, list_price, status)
    VALUES (4, 4, N'2HGFC2F59LH123458', 2005, N'Yellow', 12000, 19900.00, N'IN_SERVICE');

IF NOT EXISTS (SELECT 1 FROM car WHERE car_id = 5)
    INSERT INTO car (car_id, car_model_id, vin, [year], color, mileage, list_price, status)
    VALUES (5, 5, N'5YJ3E1EA7KF123459', 2023, N'Gray', 8000, 55500.00, N'SOLD');

SET IDENTITY_INSERT car OFF;
GO


/* ===== customer ===== */
SET IDENTITY_INSERT customer ON;

IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = 1)
    INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
    VALUES (1, N'John', N'Smith', N'+1-202-555-0101', N'john.smith@mail.com', N'New York');

IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = 2)
    INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
    VALUES (2, N'Emma', N'Johnson', N'+44-7700-900123', N'emma.johnson@mail.com', N'London');

IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = 3)
    INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
    VALUES (3, N'Michael', N'Brown', N'+49-151-234567', N'michael.brown@mail.com', N'Berlin');

IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = 4)
    INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
    VALUES (4, N'Sophia', N'Martinez', N'+34-600-123456', N'sophia.m@mail.com', N'Madrid');

IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = 5)
    INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
    VALUES (5, N'David', N'Wilson', N'+1-305-555-7788', N'david.wilson@mail.com', N'Miami');

SET IDENTITY_INSERT customer OFF;
GO


/* ===== employee ===== */
SET IDENTITY_INSERT employee ON;

IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = 1)
    INSERT INTO employee (employee_id, first_name, last_name, [position], phone, email, employed_from, employed_to)
    VALUES (1, N'James', N'Anderson', N'Sales', N'+1-212-100-0001', N'j.anderson@dealer.com', '2022-03-01', NULL);

IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = 2)
    INSERT INTO employee (employee_id, first_name, last_name, [position], phone, email, employed_from, employed_to)
    VALUES (2, N'Olivia', N'Taylor', N'Sales', N'+1-212-100-0002', N'o.taylor@dealer.com', '2021-06-15', NULL);

IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = 3)
    INSERT INTO employee (employee_id, first_name, last_name, [position], phone, email, employed_from, employed_to)
    VALUES (3, N'Daniel', N'White', N'Service', N'+1-212-100-0003', N'd.white@dealer.com', '2020-01-10', NULL);

IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = 4)
    INSERT INTO employee (employee_id, first_name, last_name, [position], phone, email, employed_from, employed_to)
    VALUES (4, N'Emily', N'Harris', N'Service', N'+1-212-100-0004', N'e.harris@dealer.com', '2019-09-20', NULL);

IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = 5)
    INSERT INTO employee (employee_id, first_name, last_name, [position], phone, email, employed_from, employed_to)
    VALUES (5, N'Robert', N'Clark', N'Manager', N'+1-212-100-0005', N'r.clark@dealer.com', '2018-05-05', NULL);

SET IDENTITY_INSERT employee OFF;
GO


/* ===== sale_status ===== */
SET IDENTITY_INSERT sale_status ON;

IF NOT EXISTS (SELECT 1 FROM sale_status WHERE sale_status_id = 1)
    INSERT INTO sale_status (sale_status_id, name) VALUES (1, N'PENDING');

IF NOT EXISTS (SELECT 1 FROM sale_status WHERE sale_status_id = 2)
    INSERT INTO sale_status (sale_status_id, name) VALUES (2, N'COMPLETED');

IF NOT EXISTS (SELECT 1 FROM sale_status WHERE sale_status_id = 3)
    INSERT INTO sale_status (sale_status_id, name) VALUES (3, N'CANCELLED');

IF NOT EXISTS (SELECT 1 FROM sale_status WHERE sale_status_id = 4)
    INSERT INTO sale_status (sale_status_id, name) VALUES (4, N'REFUNDED');

IF NOT EXISTS (SELECT 1 FROM sale_status WHERE sale_status_id = 5)
    INSERT INTO sale_status (sale_status_id, name) VALUES (5, N'ON_HOLD');

SET IDENTITY_INSERT sale_status OFF;
GO


/* ===== payment_method ===== */
SET IDENTITY_INSERT payment_method ON;

IF NOT EXISTS (SELECT 1 FROM payment_method WHERE payment_method_id = 1)
    INSERT INTO payment_method (payment_method_id, name) VALUES (1, N'CASH');

IF NOT EXISTS (SELECT 1 FROM payment_method WHERE payment_method_id = 2)
    INSERT INTO payment_method (payment_method_id, name) VALUES (2, N'CREDIT_CARD');

IF NOT EXISTS (SELECT 1 FROM payment_method WHERE payment_method_id = 3)
    INSERT INTO payment_method (payment_method_id, name) VALUES (3, N'BANK_TRANSFER');

IF NOT EXISTS (SELECT 1 FROM payment_method WHERE payment_method_id = 4)
    INSERT INTO payment_method (payment_method_id, name) VALUES (4, N'FINANCING');

IF NOT EXISTS (SELECT 1 FROM payment_method WHERE payment_method_id = 5)
    INSERT INTO payment_method (payment_method_id, name) VALUES (5, N'DEBIT_CARD');

SET IDENTITY_INSERT payment_method OFF;
GO


/* ===== service_type ===== */
SET IDENTITY_INSERT service_type ON;

IF NOT EXISTS (SELECT 1 FROM service_type WHERE service_type_id = 1)
    INSERT INTO service_type (service_type_id, name) VALUES (1, N'OIL_CHANGE');

IF NOT EXISTS (SELECT 1 FROM service_type WHERE service_type_id = 2)
    INSERT INTO service_type (service_type_id, name) VALUES (2, N'TIRE_ROTATION');

IF NOT EXISTS (SELECT 1 FROM service_type WHERE service_type_id = 3)
    INSERT INTO service_type (service_type_id, name) VALUES (3, N'BRAKE_SERVICE');

IF NOT EXISTS (SELECT 1 FROM service_type WHERE service_type_id = 4)
    INSERT INTO service_type (service_type_id, name) VALUES (4, N'ENGINE_DIAGNOSTIC');

IF NOT EXISTS (SELECT 1 FROM service_type WHERE service_type_id = 5)
    INSERT INTO service_type (service_type_id, name) VALUES (5, N'GENERAL_INSPECTION');

SET IDENTITY_INSERT service_type OFF;
GO


/* ===== part ===== */
SET IDENTITY_INSERT part ON;

IF NOT EXISTS (SELECT 1 FROM part WHERE part_id = 1)
    INSERT INTO part (part_id, part_no, description, current_price)
    VALUES (1, N'OIL-5W30-4L', N'Engine Oil 5W-30 (4L)', 550.00);

IF NOT EXISTS (SELECT 1 FROM part WHERE part_id = 2)
    INSERT INTO part (part_id, part_no, description, current_price)
    VALUES (2, N'FILTER-OIL-A1', N'Oil Filter', 180.00);

IF NOT EXISTS (SELECT 1 FROM part WHERE part_id = 3)
    INSERT INTO part (part_id, part_no, description, current_price)
    VALUES (3, N'BRAKE-PAD-FR', N'Front Brake Pads Set', 950.00);

IF NOT EXISTS (SELECT 1 FROM part WHERE part_id = 4)
    INSERT INTO part (part_id, part_no, description, current_price)
    VALUES (4, N'SPARK-PLUG-4', N'Spark Plug (Pack of 4)', 420.00);

IF NOT EXISTS (SELECT 1 FROM part WHERE part_id = 5)
    INSERT INTO part (part_id, part_no, description, current_price)
    VALUES (5, N'AIR-FILTER-B2', N'Air Filter', 260.00);

SET IDENTITY_INSERT part OFF;
GO


/* ===== sale =====
   NOTE: sale inserts require referenced rows to exist (car/customer/employee/status).
*/
SET IDENTITY_INSERT sale ON;

IF NOT EXISTS (SELECT 1 FROM sale WHERE sale_id = 1)
    INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
    VALUES (1, 2, 1, 1, 1, '2025-01-10', 26900.00);

IF NOT EXISTS (SELECT 1 FROM sale WHERE sale_id = 2)
    INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
    VALUES (2, 3, 2, 2, 2, '2025-01-12', 34000.00);

IF NOT EXISTS (SELECT 1 FROM sale WHERE sale_id = 3)
    INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
    VALUES (3, 5, 3, 1, 2, '2025-01-15', 54500.00);

IF NOT EXISTS (SELECT 1 FROM sale WHERE sale_id = 4)
    INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
    VALUES (4, 1, 4, 2, 3, '2025-01-18', 18000.00);

IF NOT EXISTS (SELECT 1 FROM sale WHERE sale_id = 5)
    INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
    VALUES (5, 4, 5, 1, 5, '2025-01-20', 29900.00);

SET IDENTITY_INSERT sale OFF;
GO


/* ===== payment ===== */
SET IDENTITY_INSERT payment ON;

IF NOT EXISTS (SELECT 1 FROM payment WHERE payment_id = 1)
    INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
    VALUES (1, 2, 2, '2025-01-12', 34000.00);

IF NOT EXISTS (SELECT 1 FROM payment WHERE payment_id = 2)
    INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
    VALUES (2, 3, 4, '2025-01-15', 54500.00);

IF NOT EXISTS (SELECT 1 FROM payment WHERE payment_id = 3)
    INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
    VALUES (3, 1, 1, '2025-01-10', 2000.00);

IF NOT EXISTS (SELECT 1 FROM payment WHERE payment_id = 4)
    INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
    VALUES (4, 5, 3, '2025-01-20', 5000.00);

IF NOT EXISTS (SELECT 1 FROM payment WHERE payment_id = 5)
    INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
    VALUES (5, 4, 5, '2025-01-18', 1000.00);

SET IDENTITY_INSERT payment OFF;
GO


/* ===== service_record ===== */
SET IDENTITY_INSERT service_record ON;

IF NOT EXISTS (SELECT 1 FROM service_record WHERE service_record_id = 1)
    INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
    VALUES (1, 4, 5, 1, '2025-01-05', 800.00, N'Routine oil change');

IF NOT EXISTS (SELECT 1 FROM service_record WHERE service_record_id = 2)
    INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
    VALUES (2, 1, 1, 5, '2025-01-07', 300.00, N'Pre-sale inspection');

IF NOT EXISTS (SELECT 1 FROM service_record WHERE service_record_id = 3)
    INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
    VALUES (3, 2, 2, 2, '2025-01-08', 250.00, N'Tire rotation');

IF NOT EXISTS (SELECT 1 FROM service_record WHERE service_record_id = 4)
    INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
    VALUES (4, 3, 3, 3, '2025-01-09', 1200.00, N'Brake pads replacement');

IF NOT EXISTS (SELECT 1 FROM service_record WHERE service_record_id = 5)
    INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
    VALUES (5, 5, 4, 4, '2025-01-11', 1500.00, N'Engine diagnostics');

SET IDENTITY_INSERT service_record OFF;
GO


/* ===== service_employee =====
   PK = (service_record_id, employee_id)
*/
IF NOT EXISTS (SELECT 1 FROM service_employee WHERE service_record_id = 1 AND employee_id = 3)
    INSERT INTO service_employee (service_record_id, employee_id, role_in_service)
    VALUES (1, 3, N'Technician');

IF NOT EXISTS (SELECT 1 FROM service_employee WHERE service_record_id = 2 AND employee_id = 4)
    INSERT INTO service_employee (service_record_id, employee_id, role_in_service)
    VALUES (2, 4, N'Technician');

IF NOT EXISTS (SELECT 1 FROM service_employee WHERE service_record_id = 3 AND employee_id = 3)
    INSERT INTO service_employee (service_record_id, employee_id, role_in_service)
    VALUES (3, 3, N'Technician');

IF NOT EXISTS (SELECT 1 FROM service_employee WHERE service_record_id = 4 AND employee_id = 4)
    INSERT INTO service_employee (service_record_id, employee_id, role_in_service)
    VALUES (4, 4, N'Lead Technician');

IF NOT EXISTS (SELECT 1 FROM service_employee WHERE service_record_id = 5 AND employee_id = 3)
    INSERT INTO service_employee (service_record_id, employee_id, role_in_service)
    VALUES (5, 3, N'Diagnostics Specialist');

GO


/* ===== parts_used =====
   Unique(service_record_id, part_id) exists in DDL
*/
SET IDENTITY_INSERT parts_used ON;

IF NOT EXISTS (SELECT 1 FROM parts_used WHERE parts_used_id = 1)
    INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
    VALUES (1, 1, 1, 1, 520.00);

IF NOT EXISTS (SELECT 1 FROM parts_used WHERE parts_used_id = 2)
    INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
    VALUES (2, 1, 2, 1, 170.00);

IF NOT EXISTS (SELECT 1 FROM parts_used WHERE parts_used_id = 3)
    INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
    VALUES (3, 4, 3, 1, 900.00);

IF NOT EXISTS (SELECT 1 FROM parts_used WHERE parts_used_id = 4)
    INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
    VALUES (4, 5, 4, 1, 400.00);

IF NOT EXISTS (SELECT 1 FROM parts_used WHERE parts_used_id = 5)
    INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
    VALUES (5, 2, 5, 1, 240.00);

SET IDENTITY_INSERT parts_used OFF;
GO
