CREATE DATABASE IF NOT EXISTS stock_trading;
USE stock_trading;


-- Title :- stock_trading 
-- Date :- 28-07-2024
-- Tool used :- Mysql


-- 1. Creating table (Users)
    CREATE TABLE Users (
        user_id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        email VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- 2. Creating table (UserProfiles)
    CREATE TABLE UserProfiles (
        user_id INT PRIMARY KEY,
        account_balance DECIMAL(10, 2) DEFAULT 0.00,
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
    );

-- 3. Creating table (Stocks)
    CREATE TABLE Stocks (
        stock_id INT AUTO_INCREMENT PRIMARY KEY,
        ticker VARCHAR(10) NOT NULL,
        name VARCHAR(100) NOT NULL,
        market VARCHAR(10) NOT NULL
    );

-- 4. Creating table (Orders)
    CREATE TABLE Orders (
        order_id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT,
        stock_id INT,
        order_type VARCHAR(4),
        quantity INT,
        price DECIMAL(10, 2),
        status VARCHAR(10),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES Users(user_id),
        FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id)
    );

-- 5. Creating table (Transactions)
    CREATE TABLE Transactions (
        transaction_id INT AUTO_INCREMENT PRIMARY KEY,
        order_id INT,
        stock_id INT,
        user_id INT,
        quantity INT,
        price DECIMAL(10, 2),
        executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (order_id) REFERENCES Orders(order_id),
        FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id),
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
    );

-- 6. Creating table (StockPrices)
    CREATE TABLE StockPrices (
        price_id INT AUTO_INCREMENT PRIMARY KEY,
        stock_id INT,
        price DECIMAL(10, 2),
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id)
    );

