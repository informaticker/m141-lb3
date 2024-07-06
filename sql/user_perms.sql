-- Benutzererstellung
CREATE USER IF NOT EXISTS 'benutzer'@'localhost' IDENTIFIED BY 'benutzer_password';
CREATE USER IF NOT EXISTS 'management'@'localhost' IDENTIFIED BY 'management_password';

-- Privilegien für Benutzer
GRANT SELECT, UPDATE ON tbl_person TO 'benutzer'@'localhost';

-- tbl_benutzer
GRANT SELECT, INSERT, UPDATE (Benutzer_ID, Benutzername, Vorname, Name, Benutzergruppe, erfasst, aktiv) 
ON tbl_benutzer TO 'benutzer'@'localhost';
GRANT SELECT (deaktiviert) ON tbl_benutzer TO 'benutzer'@'localhost';

-- tbl_buchung, tbl_position
GRANT SELECT, INSERT, UPDATE, DELETE ON tbl_buchung TO 'benutzer'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON tbl_position TO 'benutzer'@'localhost';

-- tbl_land, tbl_leistung
GRANT SELECT ON tbl_land TO 'benutzer'@'localhost';
GRANT SELECT ON tbl_leistung TO 'benutzer'@'localhost';

-- Privilegien für Management
GRANT SELECT ON tbl_position TO 'management'@'localhost';
GRANT SELECT ON tbl_buchung TO 'management'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON tbl_person TO 'management'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON tbl_benutzer TO 'management'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON tbl_land TO 'management'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON tbl_leistung TO 'management'@'localhost';

-- Privilegien neu laden
FLUSH PRIVILEGES;