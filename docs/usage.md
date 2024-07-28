# Usage Guide

This guide provides detailed instructions on how to set up the database, run the stored procedures, and test the triggers in the Real-Time Stock Trading System.

## Setting Up the Database

### Prerequisites

- MySQL installed
- Git installed

### Steps

1. **Clone the Repository**

    Clone the repository to your local machine using the following command:

    ```bash
    git clone https://github.com/yourusername/stock-trading-system.git
    ```

2. **Navigate to the Project Directory**

    Change to the project directory:

    ```bash
    cd stock-trading-system
    ```

3. **Run the Setup Script**

    Run the setup script to create the database and import the data:

    ```bash
    ./scripts/setup_database.sh
    ```

    This script will:
    - Create the database and tables.
    - Insert sample data into the tables.
    - Create stored procedures.
    - Create triggers.

## Using Stored Procedures

The following sections describe how to use the stored procedures included in this project.

### Add a User

To add a new user, use the `AddUser` stored procedure:

```sql
CALL AddUser('john_doe', 'hashed_password', 'john@example.com');
```

### Add a Stock

To add a new stock, use the `AddStock` stored procedure:

```sql
CALL AddStock('MSFT', 'Microsoft Corporation', 'NASDAQ');
```

### Add an Order
To place a new order, use the `AddOrder` stored procedure:

```sql
CALL AddUser('john_doe', 'hashed_password', 'john@example.com');
```
### Execute a Transaction
To execute a transaction, use the `ExecuteTransaction` stored procedure:

```sql
CALL AddUser('john_doe', 'hashed_password', 'john@example.com');
```
