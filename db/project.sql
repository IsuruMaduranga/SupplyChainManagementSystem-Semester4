DROP DATABASE IF EXISTS project;
CREATE DATABASE project;
USE project;


CREATE TABLE users(
	user_id INT(10) AUTO_INCREMENT PRIMARY KEY,
	_type ENUM("admin","customer","employee"),
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	email VARCHAR(50) NOT NULL,
  add_no VARCHAR(15) NOT NULL,
	street VARCHAR(20) NOT NULL,
	city1 VARCHAR(20) NOT NULL,
  city2 VARCHAR(20),
  zip INT(5) NOT NULL,
	password_hash VARCHAR(50) NOT NULL
);


CREATE TABLE phone(
	user_id INT(10),
	phone VARCHAR(10) NOT NULL CHECK(phone LIKE '0_________'),
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	PRIMARY KEY (user_id,phone)
);

CREATE TABLE employees(
	employee_id INT(10) AUTO_INCREMENT,
	_type ENUM('driver','assistant'),
	salary INT(10) CHECK (salary>0),
	status VARCHAR(20),
	FOREIGN KEY (employee_id) REFERENCES users(user_id),
	PRIMARY KEY (employee_id)
);

CREATE TABLE employee_work_data(
	employee_id INT(10),
	week_no INT(2),
	workhours TIME,
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
	PRIMARY KEY (employee_id, week_no)
);

CREATE TABLE stores(
	store_id INT(10) PRIMARY KEY AUTO_INCREMENT,
	city VARCHAR(20) NOT NULL,
	street VARCHAR(20) NOT NULL,
	contact_no VARCHAR(10) CHECK(contact_no LIKE '0_________')
);

CREATE TABLE routes(
	route_id INT(10) PRIMARY KEY AUTO_INCREMENT,
	store_id INT(10) NOT NULL,
	max_time TIME NOT NULL,
	FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE route_details(
	route_id INT(10),
	city VARCHAR(20),
	_index INT(10) NOT NULL,
	PRIMARY KEY (route_id,city),
	FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

CREATE TABLE customers(
	customer_id INT(10) AUTO_INCREMENT,
	_type ENUM("retail","wholesale","customer"),
	PRIMARY KEY (customer_id),
	FOREIGN KEY (customer_id) REFERENCES users(user_id)
);

CREATE TABLE products(
	product_id INT(10) PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL,
	_type VARCHAR(20) NOT NULL,
	capacity VARCHAR(10) NOT NULL,
	wholesale_price FLOAT(12,2) NOT NULL,
	retail_price FLOAT(12,2) NOT NULL,
	end_price FLOAT(12,2) NOT NULL,
	available_qty INT(10) NOT NULL
);

CREATE TABLE sales_data(
	product_id INT(10) NOT NULL,
	_date DATE  NOT NULL,
	city VARCHAR(20) NOT NULL,
	route_id INT(10) NOT NULL,
	item_sold INT(5) NOT NULL,
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	FOREIGN KEY (route_id) REFERENCES routes(route_id),
	PRIMARY KEY (product_id,_date,route_id)
);

CREATE TABLE orders(
	order_id INT(10) PRIMARY KEY,
	customer INT(10) NOT NULL,
	street VARCHAR(20) NOT NULL,
	route_id INT(10) NOT NULL,
	delivery_date DATE NOT NULL,
	_value FLOAT(12,2) NOT NULL,
	status VARCHAR(5) NOT NULL,
	FOREIGN KEY (customer) REFERENCES customers(customer_id),
	FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

CREATE TABLE products_ordered(
	order_id INT(10) NOT NULL,
	product_id INT(10) NOT NULL,
	qty INT(10) NOT NULL,
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	PRIMARY KEY (order_id,product_id)
);

CREATE TABLE train_schedule(
	train_schedule_id INT(10) PRIMARY KEY AUTO_INCREMENT,
	_day DATE NOT NULL,
	_time TIME NOT NULL,
	city VARCHAR(20) NOT NULL,
	capacity FLOAT(12,2) NOT NULL
);

CREATE TABLE train_trip(
	train_trip_id INT(10) PRIMARY KEY AUTO_INCREMENT,
	train_schedule_id INT(10) NOT NULL,
	_date DATE NOT NULL,
	status VARCHAR(10) NOT NULL,
	FOREIGN KEY (train_schedule_id) REFERENCES train_schedule(train_schedule_id)
);

CREATE TABLE shipments(
	shipment_id INT(10) PRIMARY KEY AUTO_INCREMENT,
	train_trip_id INT(10) NOT NULL,
	store_id INT(10) NOT NULL,
	delivery_date DATE NOT NULL,
	status VARCHAR(10) NOT NULL,
	capacity_left FLOAT(12,2) NOT NULL,
	FOREIGN KEY (train_trip_id) REFERENCES train_trip(train_trip_id),
	FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE shipment_orders(
	shipment_id INT(10),
	order_id INT(10),
	FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	PRIMARY KEY (shipment_id,order_id)
);

CREATE TABLE trucks(
	truck_id INT(10) AUTO_INCREMENT,
	store_id INT(10) NOT NULL,
	status VARCHAR(10) NOT NULL,
	PRIMARY KEY (truck_id),
	FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE truck_work_data(
	truck_id INT(10) NOT NULL,
	_date DATE NOT NULL,
	work_hours TIME NOT NULL,
	FOREIGN KEY (truck_id) REFERENCES trucks(truck_id),
	PRIMARY KEY (truck_id,_date)
);

CREATE TABLE truck_trip(
	truck_trip_id INT(10) PRIMARY KEY AUTO_INCREMENT,
	truck_id INT(10) NOT NULL,
	_date DATE NOT NULL,
	_time TIME NOT NULL,
	status VARCHAR(10) NOT NULL,
	driver_id INT(10) NOT NULL,
	assistant_id INT(10) NOT NULL,
	route_id INT(10) NOT NULL,
	FOREIGN KEY (driver_id) REFERENCES employees(employee_id),
	FOREIGN KEY (assistant_id) REFERENCES employees(employee_id),
	FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

CREATE TABLE truck_trip_orders(
	truck_schedule_id INT(10),
	order_id INT(10),
	FOREIGN KEY (truck_schedule_id) REFERENCES truck_trip(truck_trip_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	PRIMARY KEY (truck_schedule_id,order_id)
);

delimiter //
CREATE TRIGGER trig_u_email_check BEFORE INSERT ON users
	FOR EACH ROW
		BEGIN
			IF NEW.email NOT LIKE "%@%.%" THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Email';
			END IF;
		END
//
delimiter ;

delimiter //
CREATE TRIGGER trig_wk_hrs_check BEFORE INSERT ON employee_work_data
	FOR EACH ROW
		BEGIN
			IF (TIME_TO_SEC(NEW.workhours)<0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Workhours';
			ELSEIF NEW.employee_id IN (SELECT employee_id FROM employees WHERE _type = "driver") AND ((TIME_TO_SEC(NEW.workhours) / 60)>2400)
				THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Driver Maximum Workhours Exceeded';
			ELSEIF NEW.employee_id IN (SELECT employee_id FROM employees WHERE _type = "assistant") AND ((TIME_TO_SEC(NEW.workhours) / 60)>3600)
				THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Assistant Maximum Workhours Exceeded';
			END IF;
		END
//
delimiter ;
