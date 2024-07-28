use stock_trading ;


-- Title :- stock_trading 
-- Date :- 28-07-2024
-- Tool used :- Mysql


-- stock_trading Details --
-- Business questions--


-- Q1. How many users have registered in the system?
    SELECT COUNT(*) AS total_users
    FROM Users;

-- Q2. What is the total balance of all users combined?
    SELECT SUM(account_balance) AS total_balance
    FROM UserProfiles;

-- Q3. Which user has the highest account balance?
    SELECT user_id, account_balance
    FROM UserProfiles
    ORDER BY account_balance DESC
    LIMIT 1;

-- Q4. What are the top 5 most traded stocks?
    SELECT s.ticker, s.name, COUNT(t.transaction_id) AS trade_count
    FROM Transactions t
    JOIN Stocks s ON t.stock_id = s.stock_id
    GROUP BY s.ticker, s.name
    ORDER BY trade_count DESC
    LIMIT 5;

-- Q5. What is the average price of a specific stock (e.g., "AAPL") in the last 30 days?
    SELECT AVG(price) AS average_price
    FROM StockPrices
    WHERE stock_id = (SELECT stock_id FROM Stocks WHERE ticker = 'AAPL')
    AND timestamp >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Q6. How many transactions have been completed today?
    SELECT COUNT(*) AS transactions_today
    FROM Transactions
    WHERE DATE(executed_at) = CURDATE();

-- Q7. What is the total value of buy and sell orders completed today?
    SELECT 
        SUM(CASE WHEN o.order_type = 'BUY' THEN t.quantity * t.price ELSE 0 END) AS total_buy_value,
        SUM(CASE WHEN o.order_type = 'SELL' THEN t.quantity * t.price ELSE 0 END) AS total_sell_value
    FROM Transactions t
    JOIN Orders o ON t.order_id = o.order_id
    WHERE DATE(t.executed_at) = CURDATE();

-- Q8. What is the total number of pending orders?
    SELECT COUNT(*) AS pending_orders
    FROM Orders
    WHERE status = 'PENDING';

-- Q9. What are the details of the last 10 transactions?
    SELECT t.transaction_id, t.order_id, t.stock_id, s.ticker, s.name, t.user_id, t.quantity, t.price, t.executed_at
    FROM Transactions t
    JOIN Stocks s ON t.stock_id = s.stock_id
    ORDER BY t.executed_at DESC
    LIMIT 10;

-- Q10. Which stocks have increased in price the most in the last week?
    SELECT sp1.stock_id, s.ticker, s.name, (sp2.price - sp1.price) AS price_increase
    FROM StockPrices sp1
    JOIN StockPrices sp2 ON sp1.stock_id = sp2.stock_id
    JOIN Stocks s ON sp1.stock_id = s.stock_id
    WHERE sp1.timestamp = DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    AND sp2.timestamp = CURDATE()
    ORDER BY price_increase DESC
    LIMIT 5;

-- Q11. What is the distribution of order types (BUY vs SELL) in the last month?
    SELECT order_type, COUNT(*) AS count
    FROM Orders
    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    GROUP BY order_type;

-- Q12. What is the total revenue generated from transaction fees in the last quarter?
    SELECT SUM(quantity * price * 0.001) AS total_fee_revenue
    FROM Transactions
    WHERE executed_at >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- Q13. Which users have completed the most transactions?
    SELECT t.user_id, COUNT(*) AS transaction_count
    FROM Transactions t
    GROUP BY t.user_id
    ORDER BY transaction_count DESC
    LIMIT 10;

-- Q14. What is the highest single transaction value in the system?
    SELECT MAX(quantity * price) AS highest_transaction_value
    FROM Transactions;

-- Q15. Which stocks have the most buy orders pending?
    SELECT s.ticker, s.name, COUNT(*) AS pending_buy_orders
    FROM Orders o
    JOIN Stocks s ON o.stock_id = s.stock_id
    WHERE o.order_type = 'BUY' AND o.status = 'PENDING'
    GROUP BY s.ticker, s.name
    ORDER BY pending_buy_orders DESC
    LIMIT 5;

-- Q16. What is the average account balance of users who have placed at least one order?
    SELECT AVG(up.account_balance) AS average_balance
    FROM UserProfiles up
    JOIN Orders o ON up.user_id = o.user_id
    GROUP BY up.user_id;

-- Q17. How many users have an account balance greater than a specified amount (e.g., $10,000)?
    SELECT COUNT(*) AS users_above_10000
    FROM UserProfiles
    WHERE account_balance > 10000;

-- Q18. What are the details of the largest transaction (by value) for each stock?
    SELECT t.stock_id, s.ticker, s.name, t.transaction_id, t.user_id, t.quantity, t.price, (t.quantity * t.price) AS transaction_value
    FROM Transactions t
    JOIN Stocks s ON t.stock_id = s.stock_id
    WHERE (t.quantity * t.price) = (
    SELECT MAX(quantity * price)
    FROM Transactions
    WHERE stock_id = t.stock_id
    )
    ORDER BY transaction_value DESC;

-- Q19. How many distinct stocks have been traded in the last year?
    SELECT COUNT(DISTINCT stock_id) AS distinct_stocks_traded
    FROM Transactions
    WHERE executed_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Q20. What is the average transaction value for each stock?
    SELECT s.ticker, s.name, AVG(t.quantity * t.price) AS average_transaction_value
    FROM Transactions t
    JOIN Stocks s ON t.stock_id = s.stock_id
    GROUP BY s.ticker, s.name
    ORDER BY average_transaction_value DESC;
