
CREATE TABLE IF NOT EXISTS  users(
  user_id char(12),
  email varchar(255) UNIQUE,
  _type enum('customer', 'admin' ,'employee') NOT NULL,
  _password varchar(255) NOT NULL,
  PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS customers (
  customer_id char(12),
  _type enum('wholesaler', 'retailer' , 'endcustomer') NOT NULL,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  num varchar(255) NOT NULL,
  city varchar(255) NOT NULL,
  street varchar(255) NOT NULL,
  phone varchar(10) NOT NULL,
  PRIMARY KEY (customer_id),
  FOREIGN KEY (customer_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS phone(
	user_id char(12),
	phone VARCHAR(10) NOT NULL CHECK(phone LIKE '0_________'),
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	PRIMARY KEY (user_id,phone)
);

CREATE TABLE IF NOT EXISTS employees(
	employee_id char(12),
	_type ENUM('driver','assistant') NOT NULL,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  phone varchar(10) NOT NULL,
	salary INT(10) CHECK (salary>0),
	FOREIGN KEY (employee_id) REFERENCES users(user_id),
	PRIMARY KEY (employee_id)
);

CREATE TABLE IF NOT EXISTS stores(
	city ENUM('colombo', 'negombo' ,'galle','matara','jaffna','trinco'),
	contact_no VARCHAR(10),
  PRIMARY KEY (city)
);