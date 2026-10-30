-- Create Location Table
CREATE TABLE Location (
    division VARCHAR(50) UNIQUE,
    cityname VARCHAR(50) PRIMARY KEY,
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6)
);

-- Create Precipitation Table
CREATE TABLE Precipitation (
    p_id INT PRIMARY KEY,
    cityname VARCHAR(50),
    waterbody VARCHAR(50),
    waterlevel DECIMAL(5, 2),
    FOREIGN KEY (cityname) REFERENCES Location(cityname)
);

-- Create Temperature Table
CREATE TABLE Temperature (
    temp_id INT PRIMARY KEY,
    value_t DECIMAL(5, 2),
    cityname VARCHAR(50),
    FOREIGN KEY (cityname) REFERENCES Location(cityname)
);

-- Create Humidity Table
CREATE TABLE Humidity (
    humidity_id INT PRIMARY KEY,
    value_h DECIMAL(5, 2),
    waterlevel DECIMAL(5, 2),
    cityname VARCHAR(50),
    FOREIGN KEY (cityname) REFERENCES Location(cityname)
);

-- Create Summer Table
CREATE TABLE Summer (
    s_id INT PRIMARY KEY,
    month_s VARCHAR(20),
    division VARCHAR(50),
    value_t DECIMAL(5, 2),
    value_h DECIMAL(5, 2),
    FOREIGN KEY (division) REFERENCES Location(division)
);

-- Create Monsoon Table
CREATE TABLE Monsoon (
    m_id INT primary key,
    month_m VARCHAR(20),
    division VARCHAR(50),
    value_t DECIMAL(5, 2),
    value_h DECIMAL(5, 2),
    FOREIGN KEY (division) REFERENCES Location(division)
);

-- Create Winter Table
CREATE TABLE Winter (
    w_id INT,
    month_w VARCHAR(20),
    division VARCHAR(50),
    value_t DECIMAL(5, 2),
    value_h DECIMAL(5, 2),
    FOREIGN KEY (division) REFERENCES Location(division)
);

-- Insert data into Location
SET LINESIZE 150
SET PAGESIZE 50
INSERT INTO Location (division, cityname, latitude, longitude) VALUES ('Khulna', 'Teligati', 20, 90);
INSERT INTO Location (division, cityname, latitude, longitude) VALUES('Rajshahi', 'T_barriage', 24.3636, 88.6241);
INSERT INTO Location (division, cityname, latitude, longitude) VALUES('Chattogram', 'CRB', 26.8103, 90.4125);
INSERT INTO Location (division, cityname, latitude, longitude) VALUES('Dhaka', 'Mirpur', 21.3636, 88.6241);


-- Insert data into Precipitation
INSERT INTO Precipitation (p_id, cityname, waterbody, waterlevel) VALUES (1,'Teligati', 'stable', 15.6);
INSERT INTO Precipitation (p_id, cityname, waterbody, waterlevel) VALUES (2,'T_barriage', 'stable', 19.6);
INSERT INTO Precipitation (p_id, cityname, waterbody, waterlevel) VALUES (3,'CRB', 'stable', 25.6);
INSERT INTO Precipitation (p_id, cityname, waterbody, waterlevel) VALUES (4,'Mirpur', 'unstable', 15.9);
INSERT INTO Precipitation (p_id, cityname, waterbody, waterlevel) VALUES (5,'Mirpur', 'stable', 20.9);


-- Insert data into Temperature
INSERT INTO Temperature (temp_id, value_t, cityname) VALUES (1, 34.5, 'Teligati');
INSERT INTO Temperature (temp_id, value_t, cityname) VALUES (2, 37.5, 'CRB');
INSERT INTO Temperature (temp_id, value_t, cityname) VALUES (3, 39.5, 'Mirpur');
INSERT INTO Temperature (temp_id, value_t, cityname) VALUES (4, 32.5, 'T_barriage');
INSERT INTO Temperature (temp_id, value_t, cityname) VALUES (5, 42.5, 'Mirpur');





-- Insert data into Humidity
INSERT INTO Humidity (humidity_id, value_h, p_id, waterlevel, cityname) VALUES (1, 60.5, 1, 15.6, 'Teligati');
INSERT INTO Humidity (humidity_id, value_h, p_id, waterlevel, cityname) VALUES (2, 66.5,2, 19.6, 'T_barriage');
INSERT INTO Humidity (humidity_id, value_h, p_id, waterlevel, cityname) VALUES (3, 68.5, 3, 25.6, 'CRB');
INSERT INTO Humidity (humidity_id, value_h, p_id, waterlevel, cityname) VALUES (4, 62.5, 4, 15.9, 'Mirpur');
INSERT INTO Humidity (humidity_id, value_h, p_id, waterlevel, cityname) VALUES (5, 61.5, 5, 20.9, 'Mirpur');



-- Insert data into Summer
INSERT INTO Summer (s_id, month_s, division, temp_id, value_t, humidity_id, value_h) VALUES (3, 'January', 'Khulna', 1, 34.5, 1, 60.5);

-- Insert data into Monsoon
INSERT INTO Monsoon (m_id, month_m, division,temp_id, value_t, humidity_id, value_h) VALUES (1,'January', 'Khulna',2, 37.5, 1, 60.5);
INSERT INTO Monsoon (m_id, month_m, division,temp_id, value_t,humidity_id, value_h) VALUES (2, 'January', 'Khulna', 1,34.5,2, 66.5);
INSERT INTO Monsoon (m_id, month_m, division, temp_id,value_t,humidity_id, value_h) VALUES (3, 'January', 'Khulna', 3,39.5,3, 68.5);
INSERT INTO Monsoon (m_id, month_m, division, temp_id, value_t,humidity_id, value_h) VALUES (4, 'January', 'Khulna', 4,32.5,4, 62.5);

-- Insert data into Winter
INSERT INTO Winter (w_id, month_w, division,temp_id, value_t, humidity_id, value_h) VALUES (1, 'January', 'Khulna',1, 34.5,4, 62.5);

-- Select all data from Location
SELECT * FROM Location;

-- Select specific columns from Precipitation
SELECT cityname, waterlevel FROM Precipitation WHERE waterlevel > 12;

-- Select average temperature from Summer
SELECT AVG(value_t) AS avg_summer_temp FROM Summer;

-- UNION: Combine data from Summer and Winter for a division
SELECT month_s AS month, division, value_t, value_h 
FROM Summer
WHERE division = 'Central'
UNION
SELECT month_w AS month, division, value_t, value_h 
FROM Winter
WHERE division = 'Central';

-- Join Location and Precipitation on cityname
SELECT l.cityname, l.latitude, l.longitude, p.waterlevel
FROM Location l
INNER JOIN Precipitation p ON l.cityname = p.cityname;

-- Left join Temperature with Location
SELECT l.cityname, t.value_t
FROM Location l
LEFT JOIN Temperature t ON l.cityname = t.cityname;

-- Cross join Summer and Winter
SELECT s.month_s, w.month_w, s.division, w.value_h
FROM Summer s
CROSS JOIN Winter w;

--cursor


DECLARE
    CURSOR c_temp IS
        SELECT value_t
        FROM Temperature
        WHERE cityname = 'Mirpur';
    temp_value Temperature.value_t%TYPE;
BEGIN
    OPEN c_temp;
    LOOP
        FETCH c_temp INTO temp_value;
        EXIT WHEN c_temp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('When city was Mirpur, temp was: ' || temp_value);
    END LOOP;
    CLOSE c_temp;
END;
/

--update

SET SERVEROUTPUT ON;

DECLARE
    -- Variable to hold the new month name
    new_month VARCHAR(20) := 'July';  -- Example: update the month to 'July'
BEGIN
    -- Update the month_s for s_id = 10
    UPDATE Summer
    SET month_s = new_month 
    WHERE s_id = 10;

    -- Output the result
    DBMS_OUTPUT.PUT_LINE('Month name updated to ' || new_month || ' for s_id = 10.');

    -- Commit the changes
    COMMIT;
END;
/


--Avg of summer , winter, and monsoon



DBMS_OUTPUT.PUT_LINE('Starting Seasonal Averages Calculation');
DBMS_OUTPUT.PUT_LINE('------------------------------------');

DECLARE
   -- Variables for storing averages (use %TYPE for dynamic data type)
   avg_temp Summer.value_t%TYPE;
   avg_humidity Summer.value_h%TYPE;

BEGIN

   DBMS_OUTPUT.PUT_LINE('Starting Seasonal Averages Calculation');
   DBMS_OUTPUT.PUT_LINE('------------------------------------');

   -- Calculate averages for Summer
   SELECT AVG(value_t), AVG(value_h)
   INTO avg_temp, avg_humidity
   FROM Summer;

   DBMS_OUTPUT.PUT_LINE('Season: Summer');
   DBMS_OUTPUT.PUT_LINE('Average Temperature: ' || avg_temp);
   DBMS_OUTPUT.PUT_LINE('Average Humidity: ' || avg_humidity);

   -- Calculate averages for Monsoon
   SELECT AVG(value_t), AVG(value_h)
   INTO avg_temp, avg_humidity
   FROM Monsoon;

   DBMS_OUTPUT.PUT_LINE('Season: Monsoon');
   DBMS_OUTPUT.PUT_LINE('Average Temperature: ' || avg_temp);
   DBMS_OUTPUT.PUT_LINE('Average Humidity: ' || avg_humidity);

   -- Calculate averages for Winter
   SELECT AVG(value_t), AVG(value_h)
   INTO avg_temp, avg_humidity
   FROM Winter;

   DBMS_OUTPUT.PUT_LINE('Season: Winter');
   DBMS_OUTPUT.PUT_LINE('Average Temperature: ' || avg_temp);
   DBMS_OUTPUT.PUT_LINE('Average Humidity: ' || avg_humidity);
END;
/
