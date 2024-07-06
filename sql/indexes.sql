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
