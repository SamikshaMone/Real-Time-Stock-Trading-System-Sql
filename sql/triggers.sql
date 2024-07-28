DELIMITER //

CREATE TRIGGER UpdateUserBalanceAfterTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    DECLARE transaction_total DECIMAL(10, 2);
    DECLARE order_type VARCHAR(4);
    
    SET transaction_total = NEW.quantity * NEW.price;
    
    SELECT order_type INTO order_type FROM Orders WHERE order_id = NEW.order_id;
    
    IF order_type = 'BUY' THEN
        UPDATE UserProfiles 
        SET account_balance = account_balance - transaction_total 
        WHERE user_id = NEW.user_id;
    ELSEIF order_type = 'SELL' THEN
        UPDATE UserProfiles 
        SET account_balance = account_balance + transaction_total 
        WHERE user_id = NEW.user_id;
    END IF;
END //

CREATE TRIGGER UpdateStockPriceAfterTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO StockPrices (stock_id, price, timestamp) 
    VALUES (NEW.stock_id, NEW.price, NOW());
END //

CREATE TRIGGER ExecuteOrderAfterInsert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE transaction_total DECIMAL(10, 2);
    DECLARE user_balance DECIMAL(10, 2);

    SET transaction_total = NEW.quantity * NEW.price;

    SELECT account_balance INTO user_balance FROM UserProfiles WHERE user_id = NEW.user_id;

    IF NEW.order_type = 'BUY' THEN
        IF user_balance >= transaction_total THEN
            UPDATE UserProfiles 
            SET account_balance = account_balance - transaction_total 
            WHERE user_id = NEW.user_id;
            
            INSERT INTO Transactions (order_id, stock_id, user_id, quantity, price, executed_at)
            VALUES (NEW.order_id, NEW.stock_id, NEW.user_id, NEW.quantity, NEW.price, NOW());
            
            UPDATE Orders 
            SET status = 'COMPLETED' 
            WHERE order_id = NEW.order_id;
            
            INSERT INTO StockPrices (stock_id, price, timestamp) 
            VALUES (NEW.stock_id, NEW.price, NOW());
        ELSE
            UPDATE Orders 
            SET status = 'FAILED' 
            WHERE order_id = NEW.order_id;
        END IF;
    ELSEIF NEW.order_type = 'SELL' THEN
        UPDATE UserProfiles 
        SET account_balance = account_balance + transaction_total 
        WHERE user_id = NEW.user_id;
        
        INSERT INTO Transactions (order_id, stock_id, user_id, quantity, price, executed_at)
        VALUES (NEW.order_id, NEW.stock_id, NEW.user_id, NEW.quantity, NEW.price, NOW());
        
        UPDATE Orders 
        SET status = 'COMPLETED' 
        WHERE order_id = NEW.order_id;
        
        INSERT INTO StockPrices (stock_id, price, timestamp) 
        VALUES (NEW.stock_id, NEW.price, NOW());
    END IF;
END //

DELIMITER ;
