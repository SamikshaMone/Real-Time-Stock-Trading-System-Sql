use stock_trading ;


-- Title :- stock_trading 
-- Date :- 28-07-2024
-- Tool used :- Mysql


-- Setting the delimiter to // to allow multi-line trigger definitions
DELIMITER //

-- Trigger to update user account balance after a transaction is inserted
CREATE TRIGGER UpdateUserBalanceAfterTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    -- Declare variables to hold the transaction total and order type
    DECLARE transaction_total DECIMAL(10, 2);
    DECLARE order_type VARCHAR(4);
    
    -- Calculate the total value of the transaction
    SET transaction_total = NEW.quantity * NEW.price;
    
    -- Retrieve the order type from the Orders table based on the order_id
    SELECT order_type INTO order_type FROM Orders WHERE order_id = NEW.order_id;
    
    -- Update the user account balance based on the order type
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

-- Trigger to update stock prices after a transaction is inserted
CREATE TRIGGER UpdateStockPriceAfterTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    -- Insert the new stock price into the StockPrices table
    INSERT INTO StockPrices (stock_id, price, timestamp) 
    VALUES (NEW.stock_id, NEW.price, NOW());
END //

-- Trigger to execute an order after it is inserted into the Orders table
CREATE TRIGGER ExecuteOrderAfterInsert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    -- Declare variables to hold the transaction total and user balance
    DECLARE transaction_total DECIMAL(10, 2);
    DECLARE user_balance DECIMAL(10, 2);

    -- Calculate the total value of the transaction
    SET transaction_total = NEW.quantity * NEW.price;

    -- Retrieve the user's account balance from the UserProfiles table
    SELECT account_balance INTO user_balance FROM UserProfiles WHERE user_id = NEW.user_id;

    -- If the order type is 'BUY'
    IF NEW.order_type = 'BUY' THEN
        -- Check if the user has sufficient balance to execute the order
        IF user_balance >= transaction_total THEN
            -- Deduct the transaction total from the user's account balance
            UPDATE UserProfiles 
            SET account_balance = account_balance - transaction_total 
            WHERE user_id = NEW.user_id;
            
            -- Insert the transaction into the Transactions table
            INSERT INTO Transactions (order_id, stock_id, user_id, quantity, price, executed_at)
            VALUES (NEW.order_id, NEW.stock_id, NEW.user_id, NEW.quantity, NEW.price, NOW());
            
            -- Update the order status to 'COMPLETED'
            UPDATE Orders 
            SET status = 'COMPLETED' 
            WHERE order_id = NEW.order_id;
            
            -- Insert the new stock price into the StockPrices table
            INSERT INTO StockPrices (stock_id, price, timestamp) 
            VALUES (NEW.stock_id, NEW.price, NOW());
        ELSE
            -- Update the order status to 'FAILED' if the user has insufficient balance
            UPDATE Orders 
            SET status = 'FAILED' 
            WHERE order_id = NEW.order_id;
        END IF;
    -- If the order type is 'SELL'
    ELSEIF NEW.order_type = 'SELL' THEN
        -- Add the transaction total to the user's account balance
        UPDATE UserProfiles 
        SET account_balance = account_balance + transaction_total 
        WHERE user_id = NEW.user_id;
        
        -- Insert the transaction into the Transactions table
        INSERT INTO Transactions (order_id, stock_id, user_id, quantity, price, executed_at)
        VALUES (NEW.order_id, NEW.stock_id, NEW.user_id, NEW.quantity, NEW.price, NOW());
        
        -- Update the order status to 'COMPLETED'
        UPDATE Orders 
        SET status = 'COMPLETED' 
        WHERE order_id = NEW.order_id;
        
        -- Insert the new stock price into the StockPrices table
        INSERT INTO StockPrices (stock_id, price, timestamp) 
        VALUES (NEW.stock_id, NEW.price, NOW());
    END IF;
END //

-- Reset the delimiter to the default ;
DELIMITER ;
