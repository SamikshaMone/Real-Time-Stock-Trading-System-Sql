#!/bin/bash

# Variables
DB_NAME="stock_trading"
DB_USER="root"
DB_PASSWORD="password"

# MySQL command
MYSQL_CMD="mysql -u $DB_USER -p$DB_PASSWORD"

# Drop and recreate database
echo "Dropping and recreating database..."
$MYSQL_CMD <<EOF
DROP DATABASE IF EXISTS $DB_NAME;
CREATE DATABASE $DB_NAME;
EOF

# Run setup_database.sh to set up the database again
echo "Running setup_database.sh..."
./scripts/setup_database.sh

echo "Database reset complete."
