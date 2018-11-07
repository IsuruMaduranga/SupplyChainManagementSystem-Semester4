DROP DATABASE IF EXISTS project;
CREATE DATABASE project;
USE project;

CREATE TABLE users(
	user_id INT(10) AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(20) NOT NULL CHECK(email LIKE '%@%.%'),
	_type ENUM("admin","customer","employee"),
	first_name VARCHAR(20),
	last_name VARCHAR(20),
  add_no VARCHAR(5),
	street VARCHAR(20),
	city1 VARCHAR(20),
  city2 VARCHAR(20),
  zip INT(5),
	password_hash VARCHAR(50) NOT NULL
);

CREATE TABLE phone(
	user_id INT(10),
	phone VARCHAR(10) NOT NULL CHECK(phone LIKE '0%'),
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	PRIMARY KEY (user_id,phone)
);

CREATE TABLE employees(
	employee_id INT(10),
	_type ENUM('driver','assistant'),
	salary INT(10),
	status VARCHAR(20),
	FOREIGN KEY (employee_id) REFERENCES users(user_id),
	PRIMARY KEY (employee_id)
);

CREATE TABLE employee_work_data(
	employee_id INT(10),
	_date DATE,
	workhours INT(2),
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
	PRIMARY KEY (employee_id, _date)
);

CREATE TABLE stores(
	store_id INT(10) PRIMARY KEY,
	city VARCHAR(20) NOT NULL,
	street VARCHAR(20) NOT NULL,
	contact_no VARCHAR(10) CHECK(contact_no LIKE '0%')
);

CREATE TABLE routes(
	route_id INT(10) PRIMARY KEY,
	store_id INT(10) NOT NULL,
	max_time TIME,
	FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE route_details(
	route_id INT(10),
	city VARCHAR(20),
	_index INT(10),
	PRIMARY KEY (route_id,city),
	FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

CREATE TABLE customers(
	customer_id INT(10),
	_type ENUM("retail","wholesale","customer"),
	PRIMARY KEY (customer_id),
	FOREIGN KEY (customer_id) REFERENCES users(user_id)
);

CREATE TABLE products(
	product_id INT(10) PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	_type VARCHAR(20) NOT NULL,
	capacity VARCHAR(10) NOT NULL,
	wholesale_price FLOAT(12,2) NOT NULL,
	retail_price FLOAT(12,2) NOT NULL,
	end_price FLOAT(12,2) NOT NULL,
	available_qty INT(10) NOT NULL
);

CREATE TABLE sales_data(
	product_id INT(10),
	_date DATE,
	city VARCHAR(20),
	route_id INT(10),
	item_sold INT(5),
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
	train_schedule_id INT(10) PRIMARY KEY,
	_day DATE,
	_time TIME,
	city VARCHAR(20),
	capacity FLOAT(12,2)
);

CREATE TABLE train_trip(
	train_trip_id INT(10) PRIMARY KEY,
	train_schedule_id INT(10),
	_date DATE,
	status VARCHAR(10),
	FOREIGN KEY (train_schedule_id) REFERENCES train_schedule(train_schedule_id)
);

CREATE TABLE shipments(
	shipment_id INT(10) PRIMARY KEY,
	train_trip_id INT(10),
	store_id INT(10),
	delivery_date DATE,
	status VARCHAR(10),
	capacity_left FLOAT(12,2),
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
	truck_id INT(10),
	store_id INT(10),
	status VARCHAR(10),
	PRIMARY KEY (truck_id),
	FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE truck_work_data(
	truck_id INT(10),
	_date DATE,
	work_hours INT(2),
	FOREIGN KEY (truck_id) REFERENCES trucks(truck_id),
	PRIMARY KEY (truck_id,_date)
);

CREATE TABLE truck_trip(
	truck_trip_id INT(10) PRIMARY KEY,
	truck_id INT(10),
	_date DATE,
	_time TIME,
	status VARCHAR(10),
	driver_id INT(10),
	assistant_id INT(10),
	route_id INT(10),
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