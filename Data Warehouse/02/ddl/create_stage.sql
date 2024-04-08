-----------AIRLINE-----------
DROP TABLE IF EXISTS stage_airline;
CREATE TABLE stage_airline (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  alternative_name VARCHAR(100),
  iata VARCHAR(3),
  icao VARCHAR(5),
  callsign VARCHAR(100),
  country_name VARCHAR(100),
  is_active VARCHAR(1)
);
-----------AIRPORT_FREQUENCIES-----------
DROP TABLE IF EXISTS stage_airport_frequency;
CREATE TABLE stage_airport_frequency (
  id SERIAL PRIMARY KEY,
  airport_ref INTEGER NOT NULL,
  airport_ident VARCHAR(20) NOT NULL,
  type VARCHAR(20) NOT NULL,
  description VARCHAR(255),
  frequency_mhz REAL NOT NULL
);
-----------AIRPORT-----------
DROP TABLE IF EXISTS stage_airport;
CREATE TABLE stage_airport (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  city VARCHAR(100),
  country VARCHAR(100) NOT NULL,
  iata VARCHAR(3),
  icao VARCHAR(4),
  latitude VARCHAR(30) NOT NULL,
  longitude VARCHAR(30) NOT NULL,
  altitude INTEGER,
  timezone varchar(10),
  dst VARCHAR(2),
  tz_timezone VARCHAR(100) NOT NULL,
  type VARCHAR(100) NOT NULL,
  source VARCHAR(100) NOT NULL
);
-----------COUNTRY-----------
DROP TABLE IF EXISTS stage_country;
CREATE TABLE stage_country (
  id SERIAL PRIMARY KEY,
  code VARCHAR(2) NOT NULL,
  name VARCHAR(100) NOT NULL,
  continent VARCHAR(2) NOT NULL,
  wikipedia_link TEXT,
  keywords TEXT
);
-----------NAVAID-----------
DROP TABLE IF EXISTS stage_navaid;
CREATE TABLE stage_navaid (
  id SERIAL PRIMARY KEY,
  filename VARCHAR(100) NOT NULL,
  ident VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(100) NOT NULL,
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
  usage_type VARCHAR(10),
  power VARCHAR(10),
  associated_airport VARCHAR(7)
);
-----------PLANE-----------
DROP TABLE IF EXISTS stage_plane;
CREATE TABLE stage_plane (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  iata VARCHAR(3),
  icao VARCHAR(4)
);
-----------REGION-----------
DROP TABLE IF EXISTS stage_region;
CREATE TABLE stage_region (
  id SERIAL PRIMARY KEY,
  code VARCHAR(10) NOT NULL,
  local_code VARCHAR(4) NOT NULL,
  name VARCHAR(100),
  continent VARCHAR(2) NOT NULL,
  iso_country VARCHAR(2) NOT NULL,
  wikipedia_link TEXT,
  keywords TEXT
);
-----------ROUTE-----------
DROP TABLE IF EXISTS stage_route;
CREATE TABLE stage_route (
  id SERIAL PRIMARY KEY,
  airline_iata VARCHAR(3) NOT NULL,
  airline_id VARCHAR(5) NOT NULL,
  origin_iata VARCHAR(4) NOT NULL,
  origin_id VARCHAR(5) NOT NULL,
  destination_iata VARCHAR(4) NOT NULL,
  destination_id VARCHAR(5) NOT NULL,
  is_codeshare VARCHAR(1),
  number_of_stops INTEGER NOT NULL,
  plane_type VARCHAR(100)
);
-----------RUNWAY-----------
DROP TABLE IF EXISTS stage_runway;
CREATE TABLE stage_runway (
    id SERIAL PRIMARY KEY,
    airport_ref INTEGER NOT NULL,
    airport_ident VARCHAR(20) NOT NULL,
    length_ft INTEGER,
    width_ft INTEGER,
    surface VARCHAR(255),
    lighted INTEGER NOT NULL,
    closed INTEGER NOT NULL,
    le_ident VARCHAR(10),
    le_latitude_deg REAL,
    le_longitude_deg REAL,
    le_elevation_ft REAL,
    le_heading_degt INTEGER,
    le_displaced_threshold_ft INTEGER,
    he_ident VARCHAR(10),
    he_latitude_deg REAL,
    he_longitude_deg REAL,
    he_elevation_ft REAL,
    he_heading_degt INTEGER,
    he_displaced_threshold_ft REAL
);

