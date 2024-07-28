DELIMITER //

CREATE PROCEDURE AddUser(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    INSERT INTO Users (username, password_hash, email) 
    VALUES (p_username, p_password_hash, p_email);
END //

CREATE PROCEDURE AddStock(
    IN p_ticker VARCHAR(10),
    IN p_name VARCHAR(100),
    IN p_market VARCHAR(10)
)
BEGIN
    INSERT INTO Stocks (ticker, name, market) 
    VALUES (p_ticker, p_name, p_market);
END //

CREATE PROCEDURE AddOrder(
    IN p_user_id INT,
    IN p_stock_id INT,
    IN p_order_type VARCHAR(4),
    IN p_quantity INT,
    IN p_price DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Orders (user_id, stock_id, order_type, quantity, price, status) 
    VALUES (p_user_id, p_stock_id, p_order_type, p_quantity, p_price, 'PENDING');
END //

CREATE PROCEDURE ExecuteTransaction(
    IN p_order_id INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10, 2)
)
BEGIN
    DECLARE p_user_id INT;
    DECLARE p_stock_id INT;
    DECLARE p_status VARCHAR(10);
    
    SELECT user_id, stock_id, status INTO p_user_id, p_stock_id, p_status 
    FROM Orders 
    WHERE order_id = p_order_id;
    
    IF p_status = 'PENDING' THEN
        INSERT INTO Transactions (order_id, stock_id, user_id, quantity, price, executed_at)
        VALUES (p_order_id, p_stock_id, p_user_id, p_quantity, p_price, NOW());
        
        UPDATE Orders SET status = 'COMPLETED' WHERE order_id = p_order_id;
    END IF;
END //

DELIMITER ;
