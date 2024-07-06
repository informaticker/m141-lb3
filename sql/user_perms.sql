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