#!/bin/bash

echo "LB3 Build script"

read -p "DB user: " user
read -s -p "DB password: " password
echo
read -p "DB name: " dbname

echo "Thank you, divine user."
echo "Importing dump..."

mkdir -p import_tmp && cd import_tmp
wget -q https://gitlab.com/ch-tbz-it/Stud/m141/m141/-/raw/main/LB3-Praxisarbeit/backpacker_ddl_lb3.sql -O backpacker_ddl_lb3.sql
mysql -u"$user" -p"$password" -e "CREATE DATABASE IF NOT EXISTS $dbname;"
mysql -u"$user" -p"$password" "$dbname" < backpacker_ddl_lb3.sql
cd .. && rm -rf import_tmp

echo "Importing data..."
mkdir -p import_tmp && cd import_tmp
wget -q https://gitlab.com/ch-tbz-it/Stud/m141/m141/-/raw/main/LB3-Praxisarbeit/backpacker_lb3.csv.zip
unzip -q backpacker_lb3.csv.zip
rm -rf __MACOSX 

cd backpacker_lb3.csv/

import_csv() {
    local file=$1
    local table_name=$(basename "$file" .csv | sed 's/backpacker_lb3_table_//')
    echo "Importing $table_name..."
    
    mysql -u"$user" -p"$password" "$dbname" <<EOF
    LOAD DATA LOCAL INFILE '$file'
    INTO TABLE $table_name
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
EOF
}

for file in backpacker_lb3_table_*.csv; do
    import_csv "$file"
done

cd ../.. && rm -rf import_tmp
echo "Done... Enjoy."