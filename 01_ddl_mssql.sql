/* =========================================================
   01_ddl_mssql.sql
   ========================================================= */

CREATE TABLE manufacturer (
    manufacturer_id INT IDENTITY(1,1) NOT NULL,
    name            NVARCHAR(255) NOT NULL,
    country         NVARCHAR(100) NOT NULL,
    CONSTRAINT manufacturer_pk PRIMARY KEY (manufacturer_id)
);

CREATE TABLE car_model (
    car_model_id     INT IDENTITY(1,1) NOT NULL,
    manufacturer_id  INT NOT NULL,
    model_name       NVARCHAR(255) NOT NULL,
    body_type        NVARCHAR(50) NULL,
    CONSTRAINT car_model_pk PRIMARY KEY (car_model_id),
    CONSTRAINT uq_car_model_manu_name UNIQUE (manufacturer_id, model_name),
    CONSTRAINT fk_car_model_manufacturer
        FOREIGN KEY (manufacturer_id) REFERENCES manufacturer (manufacturer_id)
);

CREATE TABLE car (
    car_id       INT IDENTITY(1,1) NOT NULL,
    car_model_id INT NOT NULL,
    vin          NVARCHAR(17) NOT NULL,
    [year]       INT NOT NULL,
    color        NVARCHAR(50) NOT NULL,
    mileage      INT NULL,
    list_price   DECIMAL(10,2) NOT NULL,
    status       NVARCHAR(20) NOT NULL,
    CONSTRAINT car_pk PRIMARY KEY (car_id),
    CONSTRAINT uq_car_vin UNIQUE (vin),
    CONSTRAINT ck_car_year CHECK ([year] BETWEEN 1886 AND 2100),
    CONSTRAINT ck_car_mileage CHECK (mileage IS NULL OR mileage >= 0),
    CONSTRAINT ck_car_price CHECK (list_price > 0),
    CONSTRAINT ck_car_status CHECK (status IN ('AVAILABLE','RESERVED','SOLD','IN_SERVICE')),
    CONSTRAINT fk_car_model FOREIGN KEY (car_model_id) REFERENCES car_model (car_model_id)
);

CREATE TABLE customer (
    customer_id INT IDENTITY(1,1) NOT NULL,
    first_name  NVARCHAR(100) NOT NULL,
    last_name   NVARCHAR(100) NOT NULL,
    phone       NVARCHAR(20) NULL,
    email       NVARCHAR(255) NOT NULL,
    address     NVARCHAR(255) NULL,
    CONSTRAINT customer_pk PRIMARY KEY (customer_id),
    CONSTRAINT uq_customer_email UNIQUE (email)
);

CREATE TABLE employee (
    employee_id   INT IDENTITY(1,1) NOT NULL,
    first_name    NVARCHAR(100) NOT NULL,
    last_name     NVARCHAR(100) NOT NULL,
    [position]    NVARCHAR(100) NOT NULL,
    phone         NVARCHAR(20) NULL,
    email         NVARCHAR(255) NOT NULL,
    employed_from DATE NOT NULL,
    employed_to   DATE NULL,
    CONSTRAINT employee_pk PRIMARY KEY (employee_id),
    CONSTRAINT uq_employee_email UNIQUE (email),
    CONSTRAINT ck_employee_dates CHECK (employed_to IS NULL OR employed_to >= employed_from)
);

CREATE TABLE sale_status (
    sale_status_id INT IDENTITY(1,1) NOT NULL,
    name           NVARCHAR(30) NOT NULL,
    CONSTRAINT sale_status_pk PRIMARY KEY (sale_status_id),
    CONSTRAINT uq_sale_status_name UNIQUE (name)
);

CREATE TABLE payment_method (
    payment_method_id INT IDENTITY(1,1) NOT NULL,
    name              NVARCHAR(50) NOT NULL,
    CONSTRAINT payment_method_pk PRIMARY KEY (payment_method_id),
    CONSTRAINT uq_payment_method_name UNIQUE (name)
);

CREATE TABLE sale (
    sale_id        INT IDENTITY(1,1) NOT NULL,
    car_id         INT NOT NULL,
    customer_id    INT NOT NULL,
    employee_id    INT NOT NULL,
    sale_status_id INT NOT NULL,
    sale_date      DATE NOT NULL,
    sale_price     DECIMAL(10,2) NOT NULL,
    CONSTRAINT sale_pk PRIMARY KEY (sale_id),
    CONSTRAINT ck_sale_price CHECK (sale_price > 0),
    CONSTRAINT fk_sale_car FOREIGN KEY (car_id) REFERENCES car (car_id),
    CONSTRAINT fk_sale_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    CONSTRAINT fk_sale_employee FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    CONSTRAINT fk_sale_status FOREIGN KEY (sale_status_id) REFERENCES sale_status (sale_status_id)
);

CREATE TABLE payment (
    payment_id        INT IDENTITY(1,1) NOT NULL,
    sale_id           INT NOT NULL,
    payment_method_id INT NOT NULL,
    payment_date      DATE NOT NULL,
    amount            DECIMAL(10,2) NOT NULL,
    CONSTRAINT payment_pk PRIMARY KEY (payment_id),
    CONSTRAINT ck_payment_amount CHECK (amount > 0),
    CONSTRAINT fk_payment_sale FOREIGN KEY (sale_id) REFERENCES sale (sale_id),
    CONSTRAINT fk_payment_method FOREIGN KEY (payment_method_id) REFERENCES payment_method (payment_method_id)
);

CREATE TABLE service_type (
    service_type_id INT IDENTITY(1,1) NOT NULL,
    name            NVARCHAR(50) NOT NULL,
    CONSTRAINT service_type_pk PRIMARY KEY (service_type_id),
    CONSTRAINT uq_service_type_name UNIQUE (name)
);

CREATE TABLE service_record (
    service_record_id INT IDENTITY(1,1) NOT NULL,
    car_id            INT NOT NULL,
    customer_id       INT NOT NULL,
    service_type_id   INT NOT NULL,
    service_date      DATE NOT NULL,
    labor_cost        DECIMAL(10,2) NOT NULL CONSTRAINT df_sr_labor_cost DEFAULT (0),
    notes             NVARCHAR(1000) NULL,
    CONSTRAINT service_record_pk PRIMARY KEY (service_record_id),
    CONSTRAINT ck_sr_labor_cost CHECK (labor_cost >= 0),
    CONSTRAINT fk_sr_car FOREIGN KEY (car_id) REFERENCES car (car_id),
    CONSTRAINT fk_sr_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    CONSTRAINT fk_sr_service_type FOREIGN KEY (service_type_id) REFERENCES service_type (service_type_id)
);

CREATE TABLE service_employee (
    service_record_id INT NOT NULL,
    employee_id       INT NOT NULL,
    role_in_service   NVARCHAR(100) NULL,
    CONSTRAINT service_employee_pk PRIMARY KEY (service_record_id, employee_id),
    CONSTRAINT fk_se_service_record FOREIGN KEY (service_record_id) REFERENCES service_record (service_record_id),
    CONSTRAINT fk_se_employee FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
);

CREATE TABLE part (
    part_id       INT IDENTITY(1,1) NOT NULL,
    part_no       NVARCHAR(50) NOT NULL,
    description   NVARCHAR(255) NOT NULL,
    current_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT part_pk PRIMARY KEY (part_id),
    CONSTRAINT uq_part_no UNIQUE (part_no),
    CONSTRAINT ck_part_price CHECK (current_price >= 0)
);

CREATE TABLE parts_used (
    parts_used_id INT IDENTITY(1,1) NOT NULL,
    service_record_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price_at_service DECIMAL(10,2) NOT NULL,
    CONSTRAINT parts_used_pk PRIMARY KEY (parts_used_id),
    CONSTRAINT uq_pu_one_part_per_service UNIQUE (service_record_id, part_id),
    CONSTRAINT ck_pu_quantity CHECK (quantity > 0),
    CONSTRAINT ck_pu_unit_price CHECK (unit_price_at_service >= 0),
    CONSTRAINT fk_pu_service_record FOREIGN KEY (service_record_id) REFERENCES service_record (service_record_id),
    CONSTRAINT fk_pu_part FOREIGN KEY (part_id) REFERENCES part (part_id)
);
