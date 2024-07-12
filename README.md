# M141 LB3

Dieses Repo enthält unsere Abgabe zur LB3.

Die SQL-Scripts führen folgendes aus:
- Renaming der Tabellen zu einheitlichem Schema
- Setzt Privilegien nach Tabelle
- Hashen der Passwörter
- Korrekte Anwendung von Foreign-Keys
- Erstellt Indexes
- Optimiert die Tabellen

TODO:
- [x] Komplettes Build Script
- [ ] Hinzufügen von DB-Dump
- [ ] Salt und Pepper hinzufügen

## Änderungen anwenden
Die komplette Datenbank, mit den Modifikationen kann mithilfe von ``build_full_db.sh`` gebaut werden.
```bash
cd scripts && bash build_full_db.sh
```
Dieses Script wird:
1. Eine neue Datenbank mit dem gegebenen Schema erstellen
2. Die gegebenen Daten importieren
3. Die SQL scripts im [SQL](./sql/) folder anwenden


Das ganze kann auch manuell gemacht werden:
#### Datenbank bauen
```bash
# Temp. Ordner für Daten erstellen.
mkdir -p import_tmp && cd import_tmp
wget -q https://gitlab.com/ch-tbz-it/Stud/m141/m141/-/raw/main/LB3-Praxisarbeit/backpacker_ddl_lb3.sql -O backpacker_ddl_lb3.sql
# Datenbank kreieren
mysql -u"[USERNAME]" -p -e "CREATE DATABASE IF NOT EXISTS [DATENBANKNAME];"
# Dump importieren
mysql -u[USERNAME] -p [DATENBANKNAME] < backpacker_ddl_lb3.sql
# Temp. Ordner löschen
cd .. && rm -rf import_tmp

# Temp. Ordner für Daten erstellen.
mkdir -p import_tmp && cd import_tmp
wget -q https://gitlab.com/ch-tbz-it/Stud/m141/m141/-/raw/main/LB3-Praxisarbeit/backpacker_lb3.csv.zip
unzip -q backpacker_lb3.csv.zip
# MacOS metadata Ordener löschen
rm -rf __MACOSX 

cd backpacker_lb3.csv/

import_csv() {
    local file=$1
    # Tablename aus Dateiname extrahieren
    local table_name=$(basename "$file" .csv | sed 's/backpacker_lb3_table_//')
    mysql -u[USERNAME]-p [DATENBANKNAME] <<EOF
    LOAD DATA LOCAL INFILE '$file'
    INTO TABLE $table_name
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
EOF
}
# Alle Dateien importieren
for file in backpacker_lb3_table_*.csv; do
    import_csv "$file"
done

cd ../.. && rm -rf import_tmp
```
#### SQL anwenden
```bash
cd sql
mysql -p [DATENBANKNAME] < rename_tables.sql
mysql -p [DATENBANKNAME] < user_perms.sql
mysql -p [DATENBANKNAME] < hash_passwords.sql
mysql -p [DATENBANKNAME] < foreign_keys.sql
mysql -p [DATENBANKNAME] < indexes.sql
mysql -p [DATENBANKNAME] < optimize_tables.sql
```
**WICHTIG**: Die Scripts müssen in dieser Reihenfolge ausgeführt werden, ansonsten wird es Konflikte geben/nicht funktionieren.