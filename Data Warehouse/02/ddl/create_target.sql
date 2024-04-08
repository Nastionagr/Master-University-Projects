DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-----------COUNTRY-----------
CREATE TABLE target_country (
    id SERIAL PRIMARY KEY,
    code VARCHAR(2) NOT NULL,
    name VARCHAR(100) NOT NULL,
    continent VARCHAR(2) NOT NULL,
    wikipedia_link TEXT,
    keywords TEXT,
    version bigint,
    date_from timestamp without time zone,
	date_to timestamp without time zone,
	last_update timestamp without time zone,
    country_tk SERIAL NOT NULL
);

INSERT INTO target_country (id, code, name, continent, date_from, date_to, country_tk) VALUES (-1, 'X','NaN','X', TO_DATE('01.01.1000','dd.MM.yyyy'), TO_DATE('01.01.1000','dd.MM.yyyy'),0);
-----------AIRPORT-----------
CREATE TABLE target_airport (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    iata VARCHAR(3),
    icao VARCHAR(4),
    latitude NUMERIC,
    longitude NUMERIC,
    altitude INTEGER,
    timezone NUMERIC,
    dst VARCHAR(1),
    tz_timezone VARCHAR(100),
    type VARCHAR(100),
    source VARCHAR(100),
    country_id INTEGER,
    CONSTRAINT fk_country_id FOREIGN KEY (country_id) REFERENCES target_country(id),
    version bigint,
    date_from timestamp without time zone,
	date_to timestamp without time zone,
	last_update timestamp without time zone,
    airport_tk SERIAL NOT NULL
);

INSERT INTO target_airport (id, name, city, country, date_from, date_to, airport_tk) VALUES (-1, 'NaN','NaN','NaN', TO_DATE('01.01.1000','dd.MM.yyyy'), TO_DATE('01.01.1000','dd.MM.yyyy'),0);
-----------AIRPORT_FREQUENCIES-----------
CREATE TABLE target_airport_frequency (
    id SERIAL PRIMARY KEY,
    airport_id INT NOT NULL,
    airport_ident VARCHAR(20) NOT NULL,
    type VARCHAR(20) NOT NULL,
    description VARCHAR(255),
    frequency_mhz REAL NOT NULL,
    CONSTRAINT fk_airport_id FOREIGN KEY (airport_id) REFERENCES target_airport(id),
    version bigint,
    date_from timestamp without time zone,
	date_to timestamp without time zone,
	last_update timestamp without time zone,
    airport_frequency_tk SERIAL NOT NULL
);

INSERT INTO target_airport_frequency (id, airport_id, airport_ident, type, frequency_mhz, date_from, date_to, airport_frequency_tk) VALUES (-1, -1, 'NaN', 'NaN', 0, TO_DATE('01.01.1000','dd.MM.yyyy'), TO_DATE('01.01.1000','dd.MM.yyyy'),0);
-----------AIRLINE-----------
CREATE TABLE target_airline (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    alternative_name VARCHAR(100),
    iata VARCHAR(2),
    icao VARCHAR(3),
    callsign VARCHAR(100),
    country VARCHAR(100),
    is_active BOOLEAN,
    country_id INT,
    CONSTRAINT fk_country_id FOREIGN KEY (country_id) REFERENCES target_country(id),
    version bigint,
    date_from timestamp without time zone,
	date_to timestamp without time zone,
	last_update timestamp without time zone,
    airline_tk SERIAL NOT NULL
);

INSERT INTO target_airline (id, name, date_from, date_to, airline_tk) VALUES (-1, 'NaN', TO_DATE('01.01.1000','dd.MM.yyyy'), TO_DATE('01.01.1000','dd.MM.yyyy'),0);
-----------NAVAID-----------
CREATE TABLE target_navaid (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(100) NOT NULL,
    ident VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(10) NOT NULL,
    frequency_khz INTEGER NOT NULL,
    latitude_deg REAL NOT NULL,
    longitude_deg REAL NOT NULL,
    elevation_ft REAL,
    iso_country VARCHAR(2) NOT NULL,
    dme_frequency_khz REAL,
    dme_chanel VARCHAR(4),
    dme_latitude_deg REAL,
    dme_longitude_deg REAL,
    dme_elevation_ft REAL,
    slaved_variation_deg REAL,
    magnetic_variation_deg REAL,
    usage_type VARCHAR(10) NOT NULL,
    power VARCHAR(10) NOT NULL,
    associated_airport VARCHAR(4) NOT NULL,
    airport_id INTEGER NOT NULL,
    country_id INTEGER NOT NULL,
    CONSTRAINT fk_navaid_airport_id FOREIGN KEY (airport_id) REFERENCES target_airport(id),
    CONSTRAINT fk_navaid_country_id FOREIGN KEY (country_id) REFERENCES target_country(id),
    version bigint,
    date_from timestamp without time zone,
	date_to timestamp without time zone,
	last_update timestamp without time zone,
    navaid_tk SERIAL NOT NULL
);

INSERT INTO target_navaid (id, filename, ident, name, type, frequency_khz, latitude_deg, longitude_deg, iso_country, usage_type, power, associated_airport, airport_id, country_id, date_from, date_to, navaid_tk)
VALUES (-1, 'NaN', 'NaN', 'NaN', 'NaN', 0, 0, 0, '', 'NaN', 'NaN', 'NaN', -1, -1, TO_DATE('01.01.1000','dd.MM.yyyy'), TO_DATE('01.01.1000','dd.MM.yyyy'),0);
-----------PLANE-----------
CREATE TABLE target_plane (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    iata VARCHAR(3),
    icao VARCHAR(4),
    version bigint,
	date_from timestamp without time zone,
	date_to timestamp without time zone,
	last_update timestamp without time zone,
    plane_tk SERIAL NOT NULL
);

INSERT INTO target_plane (id, name, date_from, date_to, plane_tk) VALUES (-1, 'NaN', TO_DATE('01.01.1000','dd.MM.yyyy'), TO_DATE('01.01.1000','dd.MM.yyyy'), 0);
-----------REGION-----------
CREATE TABLE target_region (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10) NOT NULL,
    local_code VARCHAR(4) NOT NULL,
    name VARCHAR(100),
    continent VARCHAR(2) NOT NULL,
    iso_country VARCHAR(2) NOT NULL,
    wikipedia_link TEXT,
    keywords TEXT,
    country_id INT,
    CONSTRAINT fk_country_id FOREIGN KEY (country_id) REFERENCES target_country(id),
    version bigint,
    date_from timestamp without time zone,
	date_to timestamp without time zone,
	last_update timestamp without time zone,
    region_tk SERIAL NOT NULL
);

INSERT INTO target_region (id, code, local_code, continent, iso_country, date_from, date_to, region_tk)
VALUES (-1, 'NaN', 'NaN', 'X', 'X', TO_DATE('01.01.1000','dd.MM.yyyy'), TO_DATE('01.01.1000','dd.MM.yyyy'), 0);
-----------ROUTE-----------
CREATE TABLE target_route (
    id SERIAL PRIMARY KEY,
    airline_iata VARCHAR(3) NOT NULL,
    airline_id INTEGER NOT NULL,
    origin_iata VARCHAR(4) NOT NULL,
    origin_id INTEGER NOT NULL,
    destination_iata VARCHAR(4) NOT NULL,
    destination_id INTEGER NOT NULL,
    is_codeshare BOOLEAN NOT NULL,
    number_of_stops INTEGER NOT NULL,
    plane_type VARCHAR(100) NOT NULL,
    CONSTRAINT fk_airline_id FOREIGN KEY (airline_id) REFERENCES target_airline(id),
    CONSTRAINT fk_origin_id FOREIGN KEY (origin_id) REFERENCES target_airport(id),
    CONSTRAINT fk_destination_id FOREIGN KEY (destination_id) REFERENCES target_airport(id),
    version bigint,
	date_from timestamp without time zone,
	date_to timestamp without time zone,
	last_update timestamp without time zone,
	route_tk SERIAL NOT NULL
);

INSERT INTO target_route (id, airline_iata, airline_id, origin_iata, origin_id, destination_iata, destination_id, is_codeshare, number_of_stops, plane_type, date_from, date_to, route_tk)
VALUES (-1, 'NaN', -1, 'NaN', -1, 'NaN', -1, true, 0, 'NaN', TO_DATE('01.01.1000','dd.MM.yyyy'), TO_DATE('01.01.1000','dd.MM.yyyy'), 0);
-----------RUNWAY-----------
CREATE TABLE target_runway (
    id SERIAL PRIMARY KEY,
    airport_ident VARCHAR(20) NOT NULL,
    airport_id INTEGER NOT NULL,
    length_ft INTEGER NOT NULL,
    width_ft INTEGER NOT NULL,
    surface VARCHAR(100) NOT NULL,
    lighted BOOLEAN NOT NULL,
    closed BOOLEAN NOT NULL,
    le_ident VARCHAR(100) NOT NULL,
    le_latitude_deg REAL,
    le_longitude_deg REAL,
    le_elevation_ft REAL,
    le_heading_deg INTEGER,
    le_displaced_threshold_ft INTEGER,
    he_ident VARCHAR(10),
    he_latitude_deg REAL,
    he_longitude_deg REAL,
    he_elevation_ft REAL,
    he_heading_deg INTEGER,
    he_displaced_threshold_ft INTEGER,
    CONSTRAINT fk_airport_id FOREIGN KEY (airport_id) REFERENCES target_airport(id),
    version bigint,
    date_from timestamp without time zone,
	date_to timestamp without time zone,
	last_update timestamp without time zone,
	runway_tk SERIAL NOT NULL
);

INSERT INTO target_runway (id, airport_id, airport_ident, length_ft, width_ft, surface, lighted, closed, le_ident, date_from, date_to, runway_tk)
VALUES (-1, -1, 'NaN', 0, 0, 'NaN', true, true, 'NaN', TO_DATE('01.01.1000','dd.MM.yyyy'), TO_DATE('01.01.1000','dd.MM.yyyy'), 0);