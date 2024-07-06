#!/bin/bash

echo "LB3 SQL application script"

# Database connection details
read -p "DB user: " DB_USER
read -s -p "DB password: " DB_PASS
echo
read -p "DB name: " DB_NAME

# Directory containing SQL scripts
SQL_DIR="../sql"

# Function to execute SQL script
execute_sql_script() {
    local script=$1
    echo "Executing $script..."
    mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_DIR/$script"
    if [ $? -eq 0 ]; then
        echo "Successfully executed $script"
    else
        echo "Error executing $script"
        exit 1
    fi
}

# Execute scripts in specified order
execute_sql_script "rename_tables.sql"
execute_sql_script "user_perms.sql"
execute_sql_script "hash_passwords.sql"
execute_sql_script "foreign_keys.sql"
execute_sql_script "indexes.sql"
execute_sql_script "optimize_tables.sql"

echo "All SQL scripts executed successfully."