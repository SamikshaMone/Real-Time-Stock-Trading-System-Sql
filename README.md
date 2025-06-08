# Real-Time Stock Trading System

This project is a real-time stock trading system built using MySQL. It includes the database schema, sample data, stored procedures, and triggers required for a functional stock trading platform.

## Features

- User and stock management
- Order processing (buy/sell)
- Transaction execution
- Automated balance and stock price updates

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Database Schema](#database-schema)
- [Stored Procedures](#stored-procedures)
- [Triggers](#triggers)
- [License](#license)

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/stock-trading-system.git
    ```
2. Navigate to the project directory:
    ```bash
    cd stock-trading-system
    ```
3. Run the setup script to create the database and import data:
    ```bash
    ./scripts/setup_database.sh
    ```

## Usage

1. To reset the database, use:
    ```bash
    ./scripts/reset_database.sh
    ```

For detailed usage instructions, refer to the [Usage Guide](docs/usage.md).

## Database Schema

The database schema includes the following tables:
- Users
- UserProfiles
- Stocks
- Orders
- Transactions
- StockPrices

Refer to the [architecture.md](docs/architecture.md) for the detailed schema and ER diagram.

## Stored Procedures

Stored procedures included:
- AddUser
- AddStock
- AddOrder
- ExecuteTransaction

Refer to [stored_procedures.sql](sql/stored_procedures.sql) for the code.

## Triggers

Triggers included:
- UpdateUserBalanceAfterTransaction
- UpdateStockPriceAfterTransaction
- ExecuteOrderAfterInsert

Refer to [triggers.sql](sql/triggers.sql) for the code.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
analyse this format use to add infomation in github
