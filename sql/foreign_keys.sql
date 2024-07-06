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
