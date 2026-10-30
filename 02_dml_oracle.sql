/* 02_dml_oracle.sql */

-- MANUFACTURER
INSERT INTO manufacturer (manufacturer_id, name, country) VALUES (1, 'Toyota', 'Japan');
INSERT INTO manufacturer (manufacturer_id, name, country) VALUES (2, 'Dodge',   'USA');
INSERT INTO manufacturer (manufacturer_id, name, country) VALUES (3, 'BMW',    'Germany');
INSERT INTO manufacturer (manufacturer_id, name, country) VALUES (4, 'Honda',  'Japan');
INSERT INTO manufacturer (manufacturer_id, name, country) VALUES (5, 'Mercedes',  'Germany');

-- CAR_MODEL
INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type) VALUES (1, 1, 'Corolla', 'Sedan');
INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type) VALUES (2, 2, 'Charger', 'Sedan');
INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type) VALUES (3, 3, '650i',    'Coupe');
INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type) VALUES (4, 4, 'S2000',   'Roadster');
INSERT INTO car_model (car_model_id, manufacturer_id, model_name, body_type) VALUES (5, 5, 'E500',    'Sedan');

-- CAR
INSERT INTO car (car_id, car_model_id, vin, year, color, mileage, list_price, status)
VALUES (1, 1, 'JTDBR32E330123456', 2021, 'Black',  35000, 18500.00, 'AVAILABLE');
INSERT INTO car (car_id, car_model_id, vin, year, color, mileage, list_price, status)
VALUES (2, 2, '1FAFP34P12W123457', 2019, 'Blue',   52000, 27900.00, 'RESERVED');
INSERT INTO car (car_id, car_model_id, vin, year, color, mileage, list_price, status)
VALUES (3, 3, 'WBA8E9G57GNU12345', 2017, 'White',  41000, 34900.00, 'SOLD');
INSERT INTO car (car_id, car_model_id, vin, year, color, mileage, list_price, status)
VALUES (4, 4, '2HGFC2F59LH123458', 2005, 'Yellow', 12000, 19900.00, 'IN_SERVICE');
INSERT INTO car (car_id, car_model_id, vin, year, color, mileage, list_price, status)
VALUES (5, 5, '5YJ3E1EA7KF123459', 2023, 'Gray',   8000, 55500.00, 'SOLD');

-- CUSTOMER
INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
VALUES (1, 'John', 'Smith', '+1-202-555-0101', 'john.smith@mail.com', 'New York');
INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
VALUES (2, 'Emma', 'Johnson', '+44-7700-900123', 'emma.johnson@mail.com', 'London');
INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
VALUES (3, 'Michael', 'Brown', '+49-151-234567', 'michael.brown@mail.com', 'Berlin');
INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
VALUES (4, 'Sophia', 'Martinez', '+34-600-123456', 'sophia.m@mail.com', 'Madrid');
INSERT INTO customer (customer_id, first_name, last_name, phone, email, address)
VALUES (5, 'David', 'Wilson', '+1-305-555-7788', 'david.wilson@mail.com', 'Miami');

-- EMPLOYEE
INSERT INTO employee (employee_id, first_name, last_name, position, phone, email, employed_from)
VALUES (1, 'James', 'Anderson', 'Sales', '+1-212-100-0001', 'j.anderson@dealer.com', DATE '2022-03-01');
INSERT INTO employee (employee_id, first_name, last_name, position, phone, email, employed_from)
VALUES (2, 'Olivia', 'Taylor', 'Sales', '+1-212-100-0002', 'o.taylor@dealer.com', DATE '2021-06-15');
INSERT INTO employee (employee_id, first_name, last_name, position, phone, email, employed_from)
VALUES (3, 'Daniel', 'White', 'Service', '+1-212-100-0003', 'd.white@dealer.com', DATE '2020-01-10');
INSERT INTO employee (employee_id, first_name, last_name, position, phone, email, employed_from)
VALUES (4, 'Emily', 'Harris', 'Service', '+1-212-100-0004', 'e.harris@dealer.com', DATE '2019-09-20');
INSERT INTO employee (employee_id, first_name, last_name, position, phone, email, employed_from)
VALUES (5, 'Robert', 'Clark', 'Manager', '+1-212-100-0005', 'r.clark@dealer.com', DATE '2018-05-05');

-- SALE_STATUS
INSERT INTO sale_status (sale_status_id, name) VALUES (1, 'PENDING');
INSERT INTO sale_status (sale_status_id, name) VALUES (2, 'COMPLETED');
INSERT INTO sale_status (sale_status_id, name) VALUES (3, 'CANCELLED');
INSERT INTO sale_status (sale_status_id, name) VALUES (4, 'REFUNDED');
INSERT INTO sale_status (sale_status_id, name) VALUES (5, 'ON_HOLD');

-- PAYMENT_METHOD
INSERT INTO payment_method (payment_method_id, name) VALUES (1, 'CASH');
INSERT INTO payment_method (payment_method_id, name) VALUES (2, 'CREDIT_CARD');
INSERT INTO payment_method (payment_method_id, name) VALUES (3, 'BANK_TRANSFER');
INSERT INTO payment_method (payment_method_id, name) VALUES (4, 'FINANCING');
INSERT INTO payment_method (payment_method_id, name) VALUES (5, 'DEBIT_CARD');

-- SALE
INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
VALUES (1, 2, 1, 1, 1, DATE '2025-01-10', 26900.00);
INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
VALUES (2, 3, 2, 2, 2, DATE '2025-01-12', 34000.00);
INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
VALUES (3, 5, 3, 1, 2, DATE '2025-01-15', 54500.00);
INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
VALUES (4, 1, 4, 2, 3, DATE '2025-01-18', 18000.00);
INSERT INTO sale (sale_id, car_id, customer_id, employee_id, sale_status_id, sale_date, sale_price)
VALUES (5, 4, 5, 1, 5, DATE '2025-01-20', 29900.00);

-- PAYMENT
INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
VALUES (1, 2, 2, DATE '2025-01-12', 34000.00);
INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
VALUES (2, 3, 4, DATE '2025-01-15', 54500.00);
INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
VALUES (3, 1, 1, DATE '2025-01-10',  2000.00);
INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
VALUES (4, 5, 3, DATE '2025-01-20',  5000.00);
INSERT INTO payment (payment_id, sale_id, payment_method_id, payment_date, amount)
VALUES (5, 4, 5, DATE '2025-01-18',  1000.00);

-- SERVICE_TYPE
INSERT INTO service_type (service_type_id, name) VALUES (1, 'OIL_CHANGE');
INSERT INTO service_type (service_type_id, name) VALUES (2, 'TIRE_ROTATION');
INSERT INTO service_type (service_type_id, name) VALUES (3, 'BRAKE_SERVICE');
INSERT INTO service_type (service_type_id, name) VALUES (4, 'ENGINE_DIAGNOSTIC');
INSERT INTO service_type (service_type_id, name) VALUES (5, 'GENERAL_INSPECTION');

-- SERVICE_RECORD
INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
VALUES (1, 4, 5, 1, DATE '2025-01-05',  800.00, 'Routine oil change');
INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
VALUES (2, 1, 1, 5, DATE '2025-01-07',  300.00, 'Inspection before sale');
INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
VALUES (3, 2, 2, 2, DATE '2025-01-08',  250.00, 'Tire rotation');
INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
VALUES (4, 3, 3, 3, DATE '2025-01-09', 1200.00, 'Brake pads replacement');
INSERT INTO service_record (service_record_id, car_id, customer_id, service_type_id, service_date, labor_cost, notes)
VALUES (5, 5, 4, 4, DATE '2025-01-11', 1500.00, 'Engine diagnostic');

-- SERVICE_EMPLOYEE
INSERT INTO service_employee (service_record_id, employee_id, role_in_service) VALUES (1, 3, 'Technician');
INSERT INTO service_employee (service_record_id, employee_id, role_in_service) VALUES (2, 4, 'Technician');
INSERT INTO service_employee (service_record_id, employee_id, role_in_service) VALUES (3, 3, 'Technician');
INSERT INTO service_employee (service_record_id, employee_id, role_in_service) VALUES (4, 4, 'Lead Technician');
INSERT INTO service_employee (service_record_id, employee_id, role_in_service) VALUES (5, 3, 'Diagnostics');

-- PART
INSERT INTO part (part_id, part_no, description, current_price)
VALUES (1, 'OIL-5W30-4L', 'Engine Oil 5W-30 (4L)', 550.00);
INSERT INTO part (part_id, part_no, description, current_price)
VALUES (2, 'FILTER-OIL-A1', 'Oil Filter', 180.00);
INSERT INTO part (part_id, part_no, description, current_price)
VALUES (3, 'BRAKE-PAD-FR', 'Front Brake Pads Set', 950.00);
INSERT INTO part (part_id, part_no, description, current_price)
VALUES (4, 'SPARK-PLUG-4', 'Spark Plug (Pack of 4)', 420.00);
INSERT INTO part (part_id, part_no, description, current_price)
VALUES (5, 'AIR-FILTER-B2', 'Air Filter', 260.00);

-- PARTS_USED
INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
VALUES (1, 1, 1, 1, 520.00);
INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
VALUES (2, 1, 2, 1, 170.00);
INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
VALUES (3, 4, 3, 1, 900.00);
INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
VALUES (4, 5, 4, 1, 400.00);
INSERT INTO parts_used (parts_used_id, service_record_id, part_id, quantity, unit_price_at_service)
VALUES (5, 2, 5, 1, 240.00);


COMMIT ;
