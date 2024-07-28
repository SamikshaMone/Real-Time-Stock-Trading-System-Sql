use stock_trading ;


-- Title :- stock_trading 
-- Date :- 28-07-2024
-- Tool used :- Mysql


-- 1. Setting the delimiter to // to allow multi-line procedure definitions
DELIMITER //

-- 2. Stored procedure to add a new user to the Users table
CREATE PROCEDURE AddUser(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    -- Insert the provided user details into the Users table
    INSERT INTO Users (username, password_hash, email) 
    VALUES (p_username, p_password_hash, p_email);
END //

-- 3. Stored procedure to add a new stock to the Stocks table
CREATE PROCEDURE AddStock(
    IN p_ticker VARCHAR(10),
    IN p_name VARCHAR(100),
    IN p_market VARCHAR(10)
)
BEGIN
    -- Insert the provided stock details into the Stocks table
    INSERT INTO Stocks (ticker, name, market) 
    VALUES (p_ticker, p_name, p_market);
END //

-- 4. Stored procedure to add a new order to the Orders table
CREATE PROCEDURE AddOrder(
    IN p_user_id INT,
    IN p_stock_id INT,
    IN p_order_type VARCHAR(4),
    IN p_quantity INT,
    IN p_price DECIMAL(10, 2)
)
BEGIN
    -- Insert the provided order details into the Orders table with status set to 'PENDING'
    INSERT INTO Orders (user_id, stock_id, order_type, quantity, price, status) 
    VALUES (p_user_id, p_stock_id, p_order_type, p_quantity, p_price, 'PENDING');
END //

-- 5. Stored procedure to execute a transaction based on an order
CREATE PROCEDURE ExecuteTransaction(
    IN p_order_id INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10, 2)
)
BEGIN
    -- Declare variables to hold user ID, stock ID, and order status
    DECLARE p_user_id INT;
    DECLARE p_stock_id INT;
    DECLARE p_status VARCHAR(10);
    
    -- Select user ID, stock ID, and status of the order into variables
    SELECT user_id, stock_id, status INTO p_user_id, p_stock_id, p_status 
    FROM Orders 
    WHERE order_id = p_order_id;
    
    -- Check if the order status is 'PENDING'
    IF p_status = 'PENDING' THEN
        -- Insert a new transaction record into the Transactions table
        INSERT INTO Transactions (order_id, stock_id, user_id, quantity, price, executed_at)
        VALUES (p_order_id, p_stock_id, p_user_id, p_quantity, p_price, NOW());
        
        -- Update the order status to 'COMPLETED'
        UPDATE Orders SET status = 'COMPLETED' WHERE order_id = p_order_id;
    END IF;
END //

-- 6. Reset the delimiter to the default ;
DELIMITER ;
