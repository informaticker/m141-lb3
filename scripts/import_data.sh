#!/bin/bash
mkdir import_tmp && cd import_tmp
wget https://gitlab.com/ch-tbz-it/Stud/m141/m141/-/raw/main/LB3-Praxisarbeit/backpacker_lb3.csv.zip
unzip backpacker_lb3.csv.zip
# clean up mac os metadata from zip
rm -r __MACOSX 
cd backpacker_lb3.csv/
import_csv() {
    local file=$1
    local table_name=$(basename "$file" .csv | sed 's/backpacker_lb3_table_//')
    
    # remove CSV header from file, store in temp file
    tail -n +2 "$file" > "${file}.tmp"
    
    # import csv
    # this could be done cleaner; it will require entering the password n times. but we don't store passwords in cleartext around here
    mysql -p "lb3eliamilena" <<EOF
    LOAD DATA LOCAL INFILE '${file}.tmp'
    INTO TABLE $table_name
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    ($(head -n 1 "$file" | sed 's/"//g'));
EOF
    
    # remove temp file 
    rm "${file}.tmp"
}

for file in backpacker_lb3_table_*.csv; do
    import_csv "$file"
done
cd .. && rm -r import_tmp