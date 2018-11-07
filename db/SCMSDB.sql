

CREATE TABLE users(
	user_id INT(10) AUTO_INCREMENT PRIMARY KEY,
	_type ENUM("admin","customer","employee"),
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	email VARCHAR(20) NOT NULL CHECK(email LIKE '%@%.%'),
  add_no VARCHAR(5) NOT NULL,
	street VARCHAR(20) NOT NULL,
	city1 VARCHAR(20) NOT NULL,
  city2 VARCHAR(20),
  zip INT(5) NOT NULL,
	password_hash VARCHAR(50) NOT NULL
);

/* CREATE TABLE customers (
  customerId int(10),
  customerType enum('wholesaler', 'retailer' , 'endcustomer') NOT NULL,
  firstName varchar(255) NOT NULL,
  lastName varchar(255) NOT NULL,
  city varchar(255) NOT NULL,
  street varchar(255) NOT NULL,
  num varchar(255) NOT NULL,
  phone varchar(10) NOT NULL,
  PRIMARY KEY (customerId),
  FOREIGN KEY (customerId) REFERENCES users(userId)
);
 */
