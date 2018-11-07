DROP DATABASE IF EXISTS SCMS;
CREATE DATABASE SCMS;
USE SCMS;

CREATE TABLE users(
  user_id int(10) AUTO_INCREMENT,
  email varchar(255) UNIQUE,
  _type enum('customer', 'admin' ) NOT NULL,
  _password varchar(255) NOT NULL,
  PRIMARY KEY (user_id)
);

CREATE TABLE customers (
  customer_id int(10),
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

