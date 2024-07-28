#!/bin/bash

# Variables
DB_NAME="stock_trading"
DB_USER="root"
DB_PASSWORD="password"

# MySQL command
MYSQL_CMD="mysql -u $DB_USER -p$DB_PASSWORD"

# Create database
echo "Creating database..."
$MYSQL_CMD <<EOF
DROP DATABASE IF EXISTS $DB_NAME;
CREATE DATABASE $DB_NAME;
USE $DB_NAME;

-- Create Users table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create UserProfiles table
CREATE TABLE UserProfiles (
    user_id INT PRIMARY KEY,
    account_balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Stocks table
CREATE TABLE Stocks (
    stock_id INT AUTO_INCREMENT PRIMARY KEY,
    ticker VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    market VARCHAR(50) NOT NULL
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    stock_id INT,
    order_type ENUM('BUY', 'SELL') NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    status ENUM('PENDING', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id)
);

-- Create Transactions table
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    stock_id INT,
    user_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create StockPrices table
CREATE TABLE StockPrices (
    price_id INT AUTO_INCREMENT PRIMARY KEY,
    stock_id INT,
    price DECIMAL(10, 2) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id)
);

EOF

echo "Inserting sample data..."
$MYSQL_CMD $DB_NAME <<EOF

-- Insert sample users
INSERT INTO Users (username, password_hash, email) VALUES 
('john_doe', 'hashed_password1', 'john@example.com'),
('jane_doe', 'hashed_password2', 'jane@example.com');

-- Insert sample user profiles
INSERT INTO UserProfiles (user_id, account_balance) VALUES 
(1, 10000.00),
(2, 15000.00);

-- Insert sample stocks
INSERT INTO Stocks (ticker, name, market) VALUES 
('AAPL', 'Apple Inc.', 'NASDAQ'),
('GOOGL', 'Alphabet Inc.', 'NASDAQ'),
('MSFT', 'Microsoft Corporation', 'NASDAQ');

-- Insert sample orders
INSERT INTO Orders (user_id, stock_id, order_type, quantity, price) VALUES 
(1, 1, 'BUY', 10, 150.00),
(2, 2, 'SELL', 5, 1000.00);

-- Insert sample transactions
INSERT INTO Transactions (order_id, stock_id, user_id, quantity, price) VALUES 
(1, 1, 1, 10, 150.00),
(2, 2, 2, 5, 1000.00);

-- Insert sample stock prices
INSERT INTO StockPrices (stock_id, price) VALUES 
(1, 150.00),
(2, 1000.00),
(3, 200.00);

EOF

echo "Creating stored procedures..."
$MYSQL_CMD $DB_NAME <<EOF

-- AddUser procedure
DELIMITER //
CREATE PROCEDURE AddUser(IN p_username VARCHAR(50), IN p_password_hash VARCHAR(255), IN p_email VARCHAR(100))
BEGIN
    INSERT INTO Users (username, password_hash, email) VALUES (p_username, p_password_hash, p_email);
END //
DELIMITER ;

-- AddStock procedure
DELIMITER //
CREATE PROCEDURE AddStock(IN p_ticker VARCHAR(10), IN p_name VARCHAR(100), IN p_market VARCHAR(50))
BEGIN
    INSERT INTO Stocks (ticker, name, market) VALUES (p_ticker, p_name, p_market);
END //
DELIMITER ;

-- AddOrder procedure
DELIMITER //
CREATE PROCEDURE AddOrder(IN p_user_id INT, IN p_stock_id INT, IN p_order_type ENUM('BUY', 'SELL'), IN p_quantity INT, IN p_price DECIMAL(10, 2))
BEGIN
    INSERT INTO Orders (user_id, stock_id, order_type, quantity, price) VALUES (p_user_id, p_stock_id, p_order_type, p_quantity, p_price);
END //
DELIMITER ;

-- ExecuteTransaction procedure
DELIMITER //
CREATE PROCEDURE ExecuteTransaction(IN p_order_id INT, IN p_quantity INT, IN p_price DECIMAL(10, 2))
BEGIN
    UPDATE Orders SET status = 'COMPLETED' WHERE order_id = p_order_id;
    INSERT INTO Transactions (order_id, stock_id, user_id, quantity, price) 
    SELECT order_id, stock_id, user_id, p_quantity, p_price FROM Orders WHERE order_id = p_order_id;
END //
DELIMITER ;

EOF

echo "Creating triggers..."
$MYSQL_CMD $DB_NAME <<EOF

-- Trigger to update stock prices
DELIMITER //
CREATE TRIGGER after_transaction_insert
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO StockPrices (stock_id, price) VALUES (NEW.stock_id, NEW.price);
END //
DELIMITER ;

EOF

echo "Database setup complete."
