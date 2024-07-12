#!/bin/bash

echo "LB3 Combined Build and SQL Application Script"

read -p "O divine being, please provide the DB user: " DB_USER
read -s -p "Your sacred DB password, if you would be so kind: " DB_PASS
echo
read -p "And finally, the blessed DB name: " DB_NAME

echo "Thank you."

# Build script part
echo "Importing database structure..."
mkdir -p import_tmp && cd import_tmp
echo "Downloading..."
wget -q https://gitlab.com/ch-tbz-it/Stud/m141/m141/-/raw/main/LB3-Praxisarbeit/backpacker_ddl_lb3.sql -O backpacker_ddl_lb3.sql
echo "Creating database"
mysql -u"$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
echo "Importing dump..."
mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < backpacker_ddl_lb3.sql
cd .. && rm -rf import_tmp

echo "Importing data..."
mkdir -p import_tmp && cd import_tmp
echo "Downloading..."
wget -q https://gitlab.com/ch-tbz-it/Stud/m141/m141/-/raw/main/LB3-Praxisarbeit/backpacker_lb3.csv.zip
unzip -q backpacker_lb3.csv.zip
rm -rf __MACOSX 

cd backpacker_lb3.csv/

import_csv() {
    local file=$1
    local table_name=$(basename "$file" .csv | sed 's/backpacker_lb3_table_//')
    mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
    LOAD DATA LOCAL INFILE '$file'
    INTO TABLE $table_name
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
EOF
}
# meoowww please pet me >.< pweeease pleasseeee
for file in backpacker_lb3_table_*.csv; do
    import_csv "$file"
done

cd ../.. && rm -rf import_tmp

# SQL application script part
SQL_DIR="../sql"

execute_sql_script() {
    local script=$1
    mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_DIR/$script"
}

echo "Applying SQL modifications..."
echo "Renaming tables..."
execute_sql_script "rename_tables.sql"
echo "Applying new permissions"
execute_sql_script "user_perms.sql"
echo "Hashing passwords..."
execute_sql_script "hash_passwords.sql"
echo "Applying foreign keys..."
execute_sql_script "foreign_keys.sql"
echo "Creating indexes..."
execute_sql_script "indexes.sql"
echo "Optimizing tables..."
execute_sql_script "optimize_tables.sql"

echo "All operations completed successfully, O divine one. We hope this meets your exalted standards."