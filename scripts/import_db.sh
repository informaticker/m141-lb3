#!/bin/bash
mkdir import_tmp && cd import_tmp
wget https://gitlab.com/ch-tbz-it/Stud/m141/m141/-/raw/main/LB3-Praxisarbeit/backpacker_ddl_lb3.sql?ref_type=heads -O backpacker_ddl_lb3.sql
mysql -p -e "CREATE DATABASE lb3eliamilena;"
mysql -p lb3eliamilena < backpacker_ddl_lb3.sql
cd .. && rm -r import_tmp