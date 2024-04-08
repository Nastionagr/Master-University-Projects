CREATE SCHEMA datamart;

-----------AIRLINE-----------
DROP VIEW IF EXISTS datamart.airline_view;
CREATE VIEW datamart.airline_view AS
SELECT id, name, alternative_name, country_name, is_active
FROM public.target_airline;

-----------AIRPORT-----------
DROP VIEW IF EXISTS datamart.airport_view;
CREATE VIEW datamart.airport_view AS
SELECT id, name, city, country, latitude, longitude, tz_timezone
FROM public.target_airport;

-----------COUNTRY-----------
DROP VIEW IF EXISTS datamart.country_view;
CREATE VIEW datamart.country_view AS
SELECT id, code, name, continent
FROM public.target_country;

----------ROUTE COORDINATES----------
DROP FUNCTION IF EXISTS calculate_distance;
CREATE FUNCTION calculate_distance(o_lat DECIMAL, o_long DECIMAL, d_lat DECIMAL, d_long DECIMAL)
   RETURNS REAL
AS
$$
BEGIN
  RETURN ACOS(
	  SIN(RADIANS (o_lat)) 
	  * SIN(RADIANS (d_lat)) 
	  + COS(RADIANS (o_lat)) 
	  * COS(RADIANS (d_lat)) 
	  * COS(RADIANS (o_long - d_long)))
	  * 3959 * 1.60934;
END;
$$
LANGUAGE plpgsql;

DROP VIEW IF EXISTS datamart.route_coordinates_view;
CREATE VIEW datamart.route_coordinates_view AS
SELECT route.id AS route_id, 
	airport_o.latitude AS origin_latitude,      airport_o.longitude AS origin_longitude, 
 	airport_d.latitude AS destination_latitude, airport_d.longitude AS destination_longitude,
	calculate_distance(airport_o.latitude, airport_o.longitude, airport_d.latitude, airport_d.longitude) AS distance
FROM public.target_route AS route
LEFT JOIN public.target_airport AS airport_o ON route.origin_id = airport_o.id
LEFT JOIN public.target_airport AS airport_d ON route.destination_id = airport_d.id;

------------ROUTE INFORMATION------------
DROP VIEW IF EXISTS datamart.route_info_view;
CREATE VIEW datamart.route_info_view AS
SELECT route.id, 
airline.name airline_name, airline.alternative_name airline_alternative_name, airline.country_name airline_country_name, airline.is_active airline_is_active,
origin_airport.name origin_airport_name, origin_airport.city origin_airport_city, origin_airport.country origin_airport_country,
destination_airport.name destination_airport_name, destination_airport.city destination_airport_city, destination_airport.country destination_airport_country,
is_codeshare, number_of_stops, plane_type, distance
FROM public.target_route AS route
LEFT JOIN datamart.route_coordinates_view AS coordinates ON route.id = coordinates.route_id
LEFT JOIN datamart.airline_view AS airline ON route.airline_id = airline.id
LEFT JOIN datamart.airport_view AS origin_airport ON route.origin_id = origin_airport.id
LEFT JOIN datamart.airport_view AS destination_airport ON route.destination_id = destination_airport.id;