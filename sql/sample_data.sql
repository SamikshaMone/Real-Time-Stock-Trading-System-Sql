USE stock_trading;


-- Title :- stock_trading 
-- Date :- 28-07-2024
-- Tool used :- Mysql


--1. Insert sample data into the Users table
    INSERT INTO Users (username, password_hash, email) VALUES 
    ('alice', 'hashed_password1', 'alice@example.com'),
    ('bob', 'hashed_password2', 'bob@example.com'),
    ('carol', 'hashed_password3', 'carol@example.com');

-- 2. Insert sample data into the UserProfiles table
    INSERT INTO UserProfiles (user_id, account_balance) VALUES 
    (1, 10000.00),
    (2, 15000.00),
    (3, 20000.00);

-- 3. Insert sample data into the Stocks table
    INSERT INTO Stocks (ticker, name, market) VALUES 
    ('AAPL', 'Apple Inc.', 'NASDAQ'),
    ('GOOGL', 'Alphabet Inc.', 'NASDAQ'),
    ('AMZN', 'Amazon.com Inc.', 'NASDAQ');

-- 4. Insert sample data into the Orders table
    INSERT INTO Orders (user_id, stock_id, order_type, quantity, price, status) VALUES 
    (1, 1, 'BUY', 10, 150.00, 'PENDING'),
    (2, 2, 'SELL', 5, 1000.00, 'PENDING'),
    (3, 3, 'BUY', 20, 200.00, 'PENDING');

-- 5. Insert sample data into the Transactions table
    INSERT INTO Transactions (order_id, stock_id, user_id, quantity, price) VALUES 
    (1, 1, 1, 10, 150.00),
    (2, 2, 2, 5, 1000.00),
    (3, 3, 3, 20, 200.00);

-- 6. Insert sample data into the StockPrices table
    INSERT INTO StockPrices (stock_id, price) VALUES 
    (1, 150.00),
    (2, 1000.00),
    (3, 200.00);
