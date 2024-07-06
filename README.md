# M141 LB3

[toc]

## DB Dump importieren
```bash
wget https://gitlab.com/ch-tbz-it/Stud/m141/m141/-/raw/main/LB3-Praxisarbeit/backpacker_ddl_lb3.sql?ref_type=heads -O backpacker_ddl_lb3.sql
mysql -p -e "CREATE DATABASE lb3eliamilena;"
mysql -p lb3eliamilena < backpacker_ddl_lb3.sql
```
## Daten befüllen
Um die Daten erfolgreich importieren können, müssen wir zuerst den CSV-header entfernen, danach können wir LOAD DATA LOCAL INFILE verwenden um die Tabellen zu befüllen.
```bash
#!/bin/bash
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
```
## Benutzerrechte

```sql
-- Benutzererstellung
CREATE USER IF NOT EXISTS 'benutzer'@'localhost' IDENTIFIED BY 'benutzer_password';
CREATE USER IF NOT EXISTS 'management'@'localhost' IDENTIFIED BY 'management_password';

-- Privilegien für Benutzer
GRANT SELECT, UPDATE ON lb3eliamilena.tbl_person TO 'benutzer'@'localhost';

GRANT SELECT (`deaktiviert`, `Benutzer_ID`, `Benutzergruppe`, `Benutzername`, `Name`, `Vorname`, `aktiv`, `erfasst`), INSERT (`Benutzer_ID`, `Benutzergruppe`, `Benutzername`, `Name`, `Vorname`, `aktiv`, `erfasst`>

GRANT SELECT, INSERT, UPDATE, DELETE ON lb3eliamilena.tbl_buchung TO 'benutzer'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON lb3eliamilena.tbl_position TO 'benutzer'@'localhost';

GRANT SELECT ON lb3eliamilena.tbl_land TO 'benutzer'@'localhost';
GRANT SELECT ON lb3eliamilena.tbl_leistung TO 'benutzer'@'localhost';

-- Privilegien für Management
GRANT SELECT ON lb3eliamilena.tbl_position TO 'management'@'localhost';
GRANT SELECT ON lb3eliamilena.tbl_buchung TO 'management'@'localhost';

GRANT ALL PRIVILEGES ON lb3eliamilena.tbl_person TO 'management'@'localhost';
GRANT ALL PRIVILEGES ON lb3eliamilena.tbl_benutzer TO 'management'@'localhost';
GRANT ALL PRIVILEGES ON lb3eliamilena.tbl_land TO 'management'@'localhost';
GRANT ALL PRIVILEGES ON lb3eliamilena.tbl_leistung TO 'management'@'localhost';

FLUSH PRIVILEGES;
```

## Foreign Keys

```sql
-- Foreign Keys tbl_buchung
ALTER TABLE tbl_buchung
ADD CONSTRAINT fk_person_buchung
FOREIGN KEY (Person_FS)
REFERENCES tbl_person (Person_ID);

ALTER TABLE tbl_buchung
ADD CONSTRAINT fk_land_buchung
FOREIGN KEY (Land_FS)
REFERENCES tbl_land (Land_ID);

-- Foreign Keys tbl_position
ALTER TABLE tbl_position
ADD CONSTRAINT fk_buchung_position
FOREIGN KEY (Buchung_FS)
REFERENCES tbl_buchung (Buchung_ID);

ALTER TABLE tbl_position
ADD CONSTRAINT fk_benutzer_position
FOREIGN KEY (Benutzer_FS)
REFERENCES tbl_benutzer (Benutzer_ID);

ALTER TABLE tbl_position
ADD CONSTRAINT fk_leistung_position
FOREIGN KEY (Leistung_FS)
REFERENCES tbl_leistung (LeistungID);
```

## Indexes bereinigen
```sql
-- Add indexes
ALTER TABLE tbl_buchung ADD INDEX idx_Person_FS (Person_FS);
ALTER TABLE tbl_buchung ADD INDEX idx_Land_FS (Land_FS);
ALTER TABLE tbl_position ADD INDEX idx_Buchung_FS (Buchung_FS);
ALTER TABLE tbl_position ADD INDEX idx_Benutzer_FS (Benutzer_FS);
ALTER TABLE tbl_position ADD INDEX idx_Leistung_FS (Leistung_FS);

-- Frequently used colnums indexes
ALTER TABLE tbl_benutzer ADD INDEX idx_Benutzername (Benutzername);
ALTER TABLE tbl_benutzer ADD INDEX idx_aktiv (aktiv);
ALTER TABLE tbl_buchung ADD INDEX idx_Ankunft (Ankunft);
ALTER TABLE tbl_buchung ADD INDEX idx_Abreise (Abreise);
ALTER TABLE tbl_person ADD INDEX idx_Name (Name(20));
ALTER TABLE tbl_position ADD INDEX idx_erfasst (erfasst);
```
## Tabelle optimizen
```sql
ANALYZE TABLE tbl_benutzer, tbl_buchung, tbl_land, tbl_leistung, tbl_person, tbl_position;
OPTIMIZE TABLE tbl_benutzer, tbl_buchung, tbl_land, tbl_leistung, tbl_person, tbl_position;
```

## Namenskonventionen anpassen

- Alle Tabellennamen in Singular
- Primary keys alle nach Tabellenname_ID benennt
- Foreign Keys alle nach Tabellenname_FS benennt

```sql
ALTER TABLE tbl_personen CHANGE TABLE tbl_person;
ALTER TABLE tbl_positionen CHANGE TABLE tbl_position;
```

## Passwörter
- Alle Passwörter hashen
- In einer Produktionsumgebung würde hier Salt und Pepper empfehlenswert sein; jedoch das wäre hier zu kompliziert
```sql
UPDATE tbl_benutzer
SET Password = MD5(Password);
```