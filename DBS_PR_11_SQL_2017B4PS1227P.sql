ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
FLUSH PRIVILEGES;

DROP DATABASE IF EXISTS air_traffic_db;
CREATE DATABASE air_traffic_db;
USE air_traffic_db;

CREATE TABLE pilot (
  pilot_id INT NOT NULL,
  pilot_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (pilot_id)
);

CREATE TABLE flight (
  flight_no VARCHAR(8) NOT NULL,
  airline VARCHAR(25) NOT NULL,
  PRIMARY KEY (flight_no)
);

CREATE TABLE arrival (
  date_time DATETIME NOT NULL,
  from_city VARCHAR(25) NOT NULL,
  pilot_id INT NOT NULL,
  flight_no VARCHAR(8) NOT NULL,
  PRIMARY KEY (date_time),
  CONSTRAINT flight_no FOREIGN KEY (flight_no) REFERENCES flight (flight_no) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT pilot_id FOREIGN KEY (pilot_id) REFERENCES pilot (pilot_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE VIEW invalid_timing AS 
SELECT (date_time - INTERVAL 5 MINUTE) AS previous, (date_time + INTERVAL 5 MINUTE) AS later FROM arrival;

DELIMITER $$
CREATE TRIGGER flight_clash BEFORE INSERT ON arrival FOR EACH ROW BEGIN
  DECLARE flight_time_previous DATETIME;
  DECLARE flight_time_later DATETIME;
  DECLARE done INT DEFAULT FALSE;
  DECLARE cursor_i CURSOR FOR SELECT previous, later FROM invalid_timing;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cursor_i;
  read_loop: LOOP
    FETCH cursor_i INTO flight_time_previous, flight_time_later;
    IF done THEN
      LEAVE read_loop;
	ELSEIF NEW.date_time BETWEEN flight_time_previous AND flight_time_later THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Flight within 5 minutes of another';
    END IF;
  END LOOP; 
  CLOSE cursor_i;
END$$
DELIMITER ;

INSERT INTO pilot VALUES 
(23112015, 'James Holden'),
(07112014, 'Joseph Cooper'),
(02102015, 'Mark Watney'),
(01071978, 'Luke Skywalker'),
(22102021, 'Paul Atreides'),
(06121979, 'Ellen Ripley'),
(31031999, 'Thomas Anderson'),
(08091966, 'James Kirk');

INSERT INTO flight VALUES
('LH 582', 'Lufthansa'),
('EK 345', 'Emirates'),
('DL 275', 'Delta Airlines'),
('QR 1366', 'Qatar Airways'),
('BA 0182', 'British Airways'),
('AF 1727', 'Air France'),
('SQ 118', 'Singapore Airlines'),
('UA 951', 'United Airlines');

INSERT INTO arrival VALUES
('2022-04-20 17:08:00', 'New York City', 23112015, 'LH 582'),
('2022-04-26 03:56:00', 'Dubai', 07112014, 'EK 345'),
('2022-05-03 10:45:00', 'Los Angeles', 02102015, 'DL 275'),
('2022-05-17 14:33:00', 'Hong Kong', 01071978, 'QR 1366'),
('2022-07-14 23:16:00', 'London', 22102021, 'BA 0182'),
('2022-10-09 08:12:00', 'Paris', 06121979, 'AF 1727'),
('2022-11-30 20:57:00', 'Tokyo', 31031999, 'SQ 118'),
('2023-01-02 12:22:00', 'Sydney', 08091966, 'UA 951');