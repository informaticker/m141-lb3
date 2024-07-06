-- rename tables
RENAME TABLE tbl_personen TO tbl_person;
RENAME TABLE tbl_positionen TO tbl_position;

-- rename attributes
ALTER TABLE tbl_buchung CHANGE COLUMN Buchungs_ID Buchung_ID INT;
ALTER TABLE tbl_buchung CHANGE COLUMN Personen_FS Person_FS INT;
ALTER TABLE tbl_person CHANGE COLUMN Personen_ID Person_ID INT;
ALTER TABLE tbl_position CHANGE COLUMN Positions_ID Position_ID INT;
ALTER TABLE tbl_position CHANGE COLUMN Buchungs_FS Buchung_FS INT;