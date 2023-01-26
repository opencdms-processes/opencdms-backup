--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE clide;
ALTER ROLE clide WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE clideadmin;
ALTER ROLE clideadmin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE clidegui;
ALTER ROLE clidegui WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE datacomp;
ALTER ROLE datacomp WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md532e12f215ba27cb750c9e093ce4b5127';






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.9 (Debian 13.9-1.pgdg110+1)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "clidedb" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.9 (Debian 13.9-1.pgdg110+1)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: clidedb; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE clidedb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE clidedb OWNER TO postgres;

\connect clidedb

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.9 (Debian 13.9-1.pgdg110+1)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cube; Type: SHELL TYPE; Schema: public; Owner: clideadmin
--

CREATE TYPE public.cube;


--
-- Name: cube_in(cstring); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_in(cstring) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_in';


ALTER FUNCTION public.cube_in(cstring) OWNER TO clideadmin;

--
-- Name: cube_out(public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_out(public.cube) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_out';


ALTER FUNCTION public.cube_out(public.cube) OWNER TO clideadmin;

--
-- Name: cube; Type: TYPE; Schema: public; Owner: clideadmin
--

CREATE TYPE public.cube (
    INTERNALLENGTH = variable,
    INPUT = public.cube_in,
    OUTPUT = public.cube_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.cube OWNER TO clideadmin;

--
-- Name: TYPE cube; Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON TYPE public.cube IS 'multi-dimensional cube ''(FLOAT-1, FLOAT-2, ..., FLOAT-N), (FLOAT-1, FLOAT-2, ..., FLOAT-N)''';


--
-- Name: cube_dim(public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_dim(public.cube) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_dim';


ALTER FUNCTION public.cube_dim(public.cube) OWNER TO clideadmin;

--
-- Name: cube_distance(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_distance(public.cube, public.cube) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_distance';


ALTER FUNCTION public.cube_distance(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: cube_is_point(public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_is_point(public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_is_point';


ALTER FUNCTION public.cube_is_point(public.cube) OWNER TO clideadmin;

--
-- Name: earth(); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.earth() RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$SELECT '6378168'::float8$$;


ALTER FUNCTION public.earth() OWNER TO clideadmin;

--
-- Name: earth; Type: DOMAIN; Schema: public; Owner: clideadmin
--

CREATE DOMAIN public.earth AS public.cube
	CONSTRAINT not_3d CHECK ((public.cube_dim(VALUE) <= 3))
	CONSTRAINT not_point CHECK (public.cube_is_point(VALUE))
	CONSTRAINT on_surface CHECK ((abs(((public.cube_distance(VALUE, '(0)'::public.cube) / public.earth()) - (1)::double precision)) < (0.000000999999999999999955)::double precision));


ALTER DOMAIN public.earth OWNER TO clideadmin;

--
-- Name: tablefunc_crosstab_2; Type: TYPE; Schema: public; Owner: clideadmin
--

CREATE TYPE public.tablefunc_crosstab_2 AS (
	row_name text,
	category_1 text,
	category_2 text
);


ALTER TYPE public.tablefunc_crosstab_2 OWNER TO clideadmin;

--
-- Name: tablefunc_crosstab_3; Type: TYPE; Schema: public; Owner: clideadmin
--

CREATE TYPE public.tablefunc_crosstab_3 AS (
	row_name text,
	category_1 text,
	category_2 text,
	category_3 text
);


ALTER TYPE public.tablefunc_crosstab_3 OWNER TO clideadmin;

--
-- Name: tablefunc_crosstab_4; Type: TYPE; Schema: public; Owner: clideadmin
--

CREATE TYPE public.tablefunc_crosstab_4 AS (
	row_name text,
	category_1 text,
	category_2 text,
	category_3 text,
	category_4 text
);


ALTER TYPE public.tablefunc_crosstab_4 OWNER TO clideadmin;

--
-- Name: climat_data(character varying, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.climat_data(station_no character varying, yyyy_mm date) RETURNS TABLE(station_no character varying, lsd timestamp without time zone, station_pres numeric, msl_pres numeric, dew_point numeric, vapour_pres numeric, max_temp numeric, min_temp numeric, avg_temp numeric, temp_stddev numeric, rain numeric, rain_days bigint, sunshine numeric, max_rowcount bigint, min_rowcount bigint, rain_rowcount bigint, sunshine_rowcount bigint, pres_daycount bigint, vapour_daycount bigint, days_in_month double precision, max_gt_25_count bigint, max_gt_30_count bigint, max_gt_35_count bigint, max_gt_40_count bigint, min_lt_0_count bigint, max_lt_0_count bigint, rain_gt_1_count bigint, rain_gt_5_count bigint, rain_gt_10_count bigint, rain_gt_50_count bigint, rain_gt_100_count bigint, rain_gt_150_count bigint, wind_gt_10_count bigint, wind_gt_20_count bigint, wind_gt_30_count bigint, wind_daycount bigint, vis_lt_50m_count bigint, vis_lt_100m_count bigint, vis_lt_1km_count bigint, vis_daycount bigint, max_avg_temp text, max_avg_temp_dt text, min_avg_temp text, min_avg_temp_dt text, max_max_temp numeric, max_max_temp_dt text, min_min_temp numeric, min_min_temp_dt text, max_rain numeric, max_rain_dt text, max_gust numeric, max_gust_dt text, hail_count bigint, thunder_count bigint, utc_temp_time text, aws_flag character, day_count bigint)
    LANGUAGE sql ROWS 1
    AS $_$SELECT subday.station_no, subday.yyyy_mm AS lsd,
  subday.station_pres, subday.msl_pres, subday.dew_point, subday.vapour_pres,
  day.max_temp, day.min_temp, day.avg_temp, day.temp_stddev,
  day.rain, day.rain_days, day.sunshine,
  day.max_rowcount, day.min_rowcount,
  day.rain_rowcount, day.sunshine_rowcount, subday.pres_daycount, subday.vapour_daycount, 
  date_part('day'::text, date_trunc('month', subday.yyyy_mm) + '1 month'::interval - '1 day'::interval) AS days_in_month, 
  day.max_gt_25_count, day.max_gt_30_count, day.max_gt_35_count, day.max_gt_40_count,
  day.min_lt_0_count, day.max_lt_0_count,
  day.rain_gt_1_count, day.rain_gt_5_count, day.rain_gt_10_count, day.rain_gt_50_count, day.rain_gt_100_count,
  day.rain_gt_150_count,
  subday.wind_gt_10_count, subday.wind_gt_20_count, subday.wind_gt_30_count, subday.wind_daycount,
  subday.vis_lt_50m_count, subday.vis_lt_100m_count, subday.vis_lt_1km_count,
  subday.vis_daycount,
  to_char(day.max_avg_temp, '999.9'::text) AS max_avg_temp,
  to_char(max_avg_temp_dt.lsd, 'dd'::text) AS max_avg_temp_dt,
  to_char(day.min_avg_temp, '999.9'::text) AS min_avg_temp,
  to_char(min_avg_temp_dt.lsd, 'dd'::text) AS min_avg_temp_dt,
  day.max_max_temp, to_char(max_max_temp_dt.lsd, 'dd'::text) AS max_max_temp_dt,
  day.min_min_temp, to_char(min_min_temp_dt.lsd, 'dd'::text) AS min_min_temp_dt,
  day.max_rain, to_char(max_rain_dt.lsd, 'dd'::text) AS max_rain_dt, day.max_gust,
  to_char(max_gust_dt.lsd, 'dd'::text) AS max_gust_dt,
  day.hail_count,
  day.thunder_count, 
  substr(lct_to_utc(subday.station_no, (subday.yyyy_mm::date + '9 hours'::interval)::character varying)::text, 12, 2) AS utc_temp_time, 
  day.aws_flag, day.day_count 
   FROM ( SELECT sdd.station_no, 
            date_trunc('month', sdd.yyyy_mm_dd) AS yyyy_mm, 
            round(avg(iif_sql(sdd.pres_count >= 2, sdd.station_pres, NULL::numeric)), 1) AS station_pres, round(avg(iif_sql(sdd.pres_count >= 2, sdd.msl_pres, NULL::numeric)), 1) AS msl_pres, round(avg(sdd.dew_point), 1) AS dew_point, round(avg(sdd.vapour_pres), 1) AS vapour_pres, sum(iif_sql(sdd.pres_count >= 2, 1, 0)) AS pres_daycount, sum(iif_sql(sdd.vapour_count >= 2, 1, 0)) AS vapour_daycount, sum( 
                CASE 
                    WHEN sdd.avg_daily_wind > 10::numeric THEN 1 
                    ELSE 0 
                END) AS wind_gt_10_count, sum( 
                CASE 
                    WHEN sdd.avg_daily_wind > 20::numeric THEN 1 
                    ELSE 0 
                END) AS wind_gt_20_count, sum( 
                CASE 
                    WHEN sdd.avg_daily_wind > 30::numeric THEN 1 
                    ELSE 0 
                END) AS wind_gt_30_count, sum( 
                CASE 
                    WHEN sdd.daily_wind_count >= 8 THEN 1 
                    ELSE 0 
                END) AS wind_daycount, sum( 
                CASE 
                    WHEN sdd.min_daily_visibility < 0.05 THEN 1 
                    ELSE 0 
                END) AS vis_lt_50m_count, sum( 
                CASE 
                    WHEN sdd.min_daily_visibility < 0.1 THEN 1 
                    ELSE 0 
                END) AS vis_lt_100m_count, sum( 
                CASE 
                    WHEN sdd.min_daily_visibility < 1::numeric THEN 1 
                    ELSE 0 
                END) AS vis_lt_1km_count, sum( 
                CASE 
                    WHEN sdd.daily_vis_count > 0 THEN 1 
                    ELSE 0 
                END) AS vis_daycount 
           FROM ( SELECT sd.station_no, 
                    date_trunc('day', sd.lsd) AS yyyy_mm_dd, 
                    avg(sd.station_pres) AS station_pres, avg(sd.msl_pres) AS msl_pres, avg(sd.dew_point) AS dew_point, avg(exp(1.8096 + 17.269425 * sd.dew_point / (237.3 + sd.dew_point))) AS vapour_pres, count(sd.station_pres) AS pres_count, count(sd.dew_point) AS vapour_count, avg(sd.wind_speed) AS avg_daily_wind, count(sd.wind_speed) AS daily_wind_count, min(sd.visibility) AS min_daily_visibility, count(sd.visibility) AS daily_vis_count 
                   FROM obs_subdaily sd 
                   WHERE station_no = $1
                     AND date_trunc('month', sd.lsd) = $2
                  GROUP BY sd.station_no, date_trunc('day', sd.lsd)) sdd 
          GROUP BY sdd.station_no, date_trunc('month', sdd.yyyy_mm_dd)) subday 
   JOIN ( SELECT d.station_no AS stationno, 
            date_trunc('month', d.lsd) AS yyyymm, 
            round(avg(d.max_air_temp), 1) AS max_temp, round(avg(d.min_air_temp), 1) AS min_temp, round(avg((d.max_air_temp + d.min_air_temp) / 2::numeric), 1) AS avg_temp, round(stddev((d.max_air_temp + d.min_air_temp) / 2::numeric), 1) AS temp_stddev, round(sum(d.rain_24h), 0) AS rain, sum( 
                CASE 
                    WHEN d.rain_24h >= 1::numeric THEN 1 
                    ELSE 0 
                END) AS rain_days, round(sum(d.sunshine_duration), 0) AS sunshine, count(d.max_air_temp) AS max_rowcount, count(d.min_air_temp) AS min_rowcount, count(d.rain_24h) AS rain_rowcount, count(d.sunshine_duration) AS sunshine_rowcount, sum( 
                CASE 
                    WHEN d.max_air_temp >= 25::numeric THEN 1 
                    ELSE 0 
                END) AS max_gt_25_count, sum( 
                CASE 
                    WHEN d.max_air_temp >= 30::numeric THEN 1 
                    ELSE 0 
                END) AS max_gt_30_count, sum( 
                CASE 
                    WHEN d.max_air_temp >= 35::numeric THEN 1 
                    ELSE 0 
                END) AS max_gt_35_count, sum( 
                CASE 
                    WHEN d.max_air_temp >= 40::numeric THEN 1 
                    ELSE 0 
                END) AS max_gt_40_count, sum( 
                CASE 
                    WHEN d.min_air_temp < 0::numeric THEN 1 
                    ELSE 0 
                END) AS min_lt_0_count, sum( 
                CASE 
                    WHEN d.max_air_temp < 0::numeric THEN 1 
                    ELSE 0 
                END) AS max_lt_0_count, sum( 
                CASE 
                    WHEN d.rain_24h >= 1::numeric THEN 1 
                    ELSE 0 
                END) AS rain_gt_1_count, sum( 
                CASE 
                    WHEN d.rain_24h >= 5::numeric THEN 1 
                    ELSE 0 
                END) AS rain_gt_5_count, sum( 
                CASE 
                    WHEN d.rain_24h >= 10::numeric THEN 1 
                    ELSE 0 
                END) AS rain_gt_10_count, sum( 
                CASE 
                    WHEN d.rain_24h >= 50::numeric THEN 1 
                    ELSE 0 
                END) AS rain_gt_50_count, sum( 
                CASE 
                    WHEN d.rain_24h >= 100::numeric THEN 1 
                    ELSE 0 
                END) AS rain_gt_100_count, sum( 
                CASE 
                    WHEN d.rain_24h >= 150::numeric THEN 1 
                    ELSE 0 
                END) AS rain_gt_150_count, max((d.max_air_temp + d.min_air_temp) / 2::numeric) AS max_avg_temp, min((d.max_air_temp + d.min_air_temp) / 2::numeric) AS min_avg_temp, max(d.max_air_temp) AS max_max_temp, min(d.min_air_temp) AS min_min_temp, max(d.rain_24h) AS max_rain, max(d.max_gust_speed) AS max_gust, sum( 
                CASE 
                    WHEN d.hail_flag = 'Y'::bpchar THEN 1 
                    ELSE 0 
                END) AS hail_count, sum( 
                CASE 
                    WHEN d.thunder_flag = 'Y'::bpchar THEN 1 
                    ELSE 0 
                END) AS thunder_count, 'N'::character(1) AS aws_flag, count(*) AS day_count 
           FROM obs_daily d 
           WHERE station_no = $1
             AND date_trunc('month', d.lsd) = $2
          GROUP BY d.station_no, date_trunc('month', d.lsd)) day 
     ON subday.station_no::text = day.stationno::text AND subday.yyyy_mm = day.yyyymm 
   LEFT JOIN obs_daily max_avg_temp_dt ON day.stationno::text = max_avg_temp_dt.station_no::text AND date_trunc('month', max_avg_temp_dt.lsd) = day.yyyymm AND ((max_avg_temp_dt.max_air_temp + max_avg_temp_dt.min_air_temp) / 2::numeric) = day.max_avg_temp 
   LEFT JOIN obs_daily min_avg_temp_dt ON day.stationno::text = min_avg_temp_dt.station_no::text AND date_trunc('month', min_avg_temp_dt.lsd) = day.yyyymm AND ((min_avg_temp_dt.max_air_temp + min_avg_temp_dt.min_air_temp) / 2::numeric) = day.min_avg_temp 
   LEFT JOIN obs_daily max_max_temp_dt ON day.stationno::text = max_max_temp_dt.station_no::text AND date_trunc('month', max_max_temp_dt.lsd) = day.yyyymm AND max_max_temp_dt.max_air_temp = day.max_max_temp 
   LEFT JOIN obs_daily min_min_temp_dt ON day.stationno::text = min_min_temp_dt.station_no::text AND date_trunc('month', min_min_temp_dt.lsd) = day.yyyymm AND min_min_temp_dt.min_air_temp = day.min_min_temp 
   LEFT JOIN obs_daily max_rain_dt ON day.stationno::text = max_rain_dt.station_no::text AND date_trunc('month', max_rain_dt.lsd) = day.yyyymm AND max_rain_dt.rain_24h = day.max_rain 
   LEFT JOIN obs_daily max_gust_dt ON day.stationno::text = max_gust_dt.station_no::text AND date_trunc('month', max_gust_dt.lsd) = day.yyyymm AND max_gust_dt.max_gust_speed = day.max_gust 
WHERE subday.station_no = $1
  AND subday.yyyy_mm = $2;$_$;


ALTER FUNCTION public.climat_data(station_no character varying, yyyy_mm date) OWNER TO postgres;

--
-- Name: connectby(text, text, text, text, integer); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.connectby(text, text, text, text, integer) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'connectby_text';


ALTER FUNCTION public.connectby(text, text, text, text, integer) OWNER TO clideadmin;

--
-- Name: connectby(text, text, text, text, integer, text); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.connectby(text, text, text, text, integer, text) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'connectby_text';


ALTER FUNCTION public.connectby(text, text, text, text, integer, text) OWNER TO clideadmin;

--
-- Name: connectby(text, text, text, text, text, integer); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.connectby(text, text, text, text, text, integer) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'connectby_text_serial';


ALTER FUNCTION public.connectby(text, text, text, text, text, integer) OWNER TO clideadmin;

--
-- Name: connectby(text, text, text, text, text, integer, text); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.connectby(text, text, text, text, text, integer, text) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'connectby_text_serial';


ALTER FUNCTION public.connectby(text, text, text, text, text, integer, text) OWNER TO clideadmin;

--
-- Name: crosstab(text); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.crosstab(text) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab(text) OWNER TO clideadmin;

--
-- Name: crosstab(text, integer); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.crosstab(text, integer) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab(text, integer) OWNER TO clideadmin;

--
-- Name: crosstab(text, text); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.crosstab(text, text) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab_hash';


ALTER FUNCTION public.crosstab(text, text) OWNER TO clideadmin;

--
-- Name: crosstab2(text); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.crosstab2(text) RETURNS SETOF public.tablefunc_crosstab_2
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab2(text) OWNER TO clideadmin;

--
-- Name: crosstab3(text); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.crosstab3(text) RETURNS SETOF public.tablefunc_crosstab_3
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab3(text) OWNER TO clideadmin;

--
-- Name: crosstab4(text); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.crosstab4(text) RETURNS SETOF public.tablefunc_crosstab_4
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


ALTER FUNCTION public.crosstab4(text) OWNER TO clideadmin;

--
-- Name: cube(double precision[]); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube(double precision[]) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_a_f8';


ALTER FUNCTION public.cube(double precision[]) OWNER TO clideadmin;

--
-- Name: cube(double precision); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube(double precision) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_f8';


ALTER FUNCTION public.cube(double precision) OWNER TO clideadmin;

--
-- Name: cube(double precision[], double precision[]); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube(double precision[], double precision[]) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_a_f8_f8';


ALTER FUNCTION public.cube(double precision[], double precision[]) OWNER TO clideadmin;

--
-- Name: cube(double precision, double precision); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube(double precision, double precision) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_f8_f8';


ALTER FUNCTION public.cube(double precision, double precision) OWNER TO clideadmin;

--
-- Name: cube(public.cube, double precision); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube(public.cube, double precision) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_c_f8';


ALTER FUNCTION public.cube(public.cube, double precision) OWNER TO clideadmin;

--
-- Name: cube(public.cube, double precision, double precision); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube(public.cube, double precision, double precision) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_c_f8_f8';


ALTER FUNCTION public.cube(public.cube, double precision, double precision) OWNER TO clideadmin;

--
-- Name: cube_cmp(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_cmp(public.cube, public.cube) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_cmp';


ALTER FUNCTION public.cube_cmp(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_cmp(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_cmp(public.cube, public.cube) IS 'btree comparison function';


--
-- Name: cube_contained(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_contained(public.cube, public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_contained';


ALTER FUNCTION public.cube_contained(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_contained(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_contained(public.cube, public.cube) IS 'contained in';


--
-- Name: cube_contains(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_contains(public.cube, public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_contains';


ALTER FUNCTION public.cube_contains(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_contains(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_contains(public.cube, public.cube) IS 'contains';


--
-- Name: cube_enlarge(public.cube, double precision, integer); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_enlarge(public.cube, double precision, integer) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_enlarge';


ALTER FUNCTION public.cube_enlarge(public.cube, double precision, integer) OWNER TO clideadmin;

--
-- Name: cube_eq(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_eq(public.cube, public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_eq';


ALTER FUNCTION public.cube_eq(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_eq(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_eq(public.cube, public.cube) IS 'same as';


--
-- Name: cube_ge(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_ge(public.cube, public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_ge';


ALTER FUNCTION public.cube_ge(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_ge(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_ge(public.cube, public.cube) IS 'greater than or equal to';


--
-- Name: cube_gt(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_gt(public.cube, public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_gt';


ALTER FUNCTION public.cube_gt(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_gt(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_gt(public.cube, public.cube) IS 'greater than';


--
-- Name: cube_inter(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_inter(public.cube, public.cube) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_inter';


ALTER FUNCTION public.cube_inter(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: cube_le(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_le(public.cube, public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_le';


ALTER FUNCTION public.cube_le(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_le(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_le(public.cube, public.cube) IS 'lower than or equal to';


--
-- Name: cube_ll_coord(public.cube, integer); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_ll_coord(public.cube, integer) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_ll_coord';


ALTER FUNCTION public.cube_ll_coord(public.cube, integer) OWNER TO clideadmin;

--
-- Name: cube_lt(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_lt(public.cube, public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_lt';


ALTER FUNCTION public.cube_lt(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_lt(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_lt(public.cube, public.cube) IS 'lower than';


--
-- Name: cube_ne(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_ne(public.cube, public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_ne';


ALTER FUNCTION public.cube_ne(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_ne(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_ne(public.cube, public.cube) IS 'different';


--
-- Name: cube_overlap(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_overlap(public.cube, public.cube) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_overlap';


ALTER FUNCTION public.cube_overlap(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: FUNCTION cube_overlap(public.cube, public.cube); Type: COMMENT; Schema: public; Owner: clideadmin
--

COMMENT ON FUNCTION public.cube_overlap(public.cube, public.cube) IS 'overlaps';


--
-- Name: cube_size(public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_size(public.cube) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_size';


ALTER FUNCTION public.cube_size(public.cube) OWNER TO clideadmin;

--
-- Name: cube_subset(public.cube, integer[]); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_subset(public.cube, integer[]) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_subset';


ALTER FUNCTION public.cube_subset(public.cube, integer[]) OWNER TO clideadmin;

--
-- Name: cube_union(public.cube, public.cube); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_union(public.cube, public.cube) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_union';


ALTER FUNCTION public.cube_union(public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: cube_ur_coord(public.cube, integer); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.cube_ur_coord(public.cube, integer) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'cube_ur_coord';


ALTER FUNCTION public.cube_ur_coord(public.cube, integer) OWNER TO clideadmin;

--
-- Name: earth_box(public.earth, double precision); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.earth_box(public.earth, double precision) RETURNS public.cube
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT cube_enlarge($1, gc_to_sec($2), 3)$_$;


ALTER FUNCTION public.earth_box(public.earth, double precision) OWNER TO clideadmin;

--
-- Name: earth_distance(public.earth, public.earth); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.earth_distance(public.earth, public.earth) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT sec_to_gc(cube_distance($1, $2))$_$;


ALTER FUNCTION public.earth_distance(public.earth, public.earth) OWNER TO clideadmin;

--
-- Name: g_cube_compress(internal); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.g_cube_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'g_cube_compress';


ALTER FUNCTION public.g_cube_compress(internal) OWNER TO clideadmin;

--
-- Name: g_cube_consistent(internal, public.cube, integer, oid, internal); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.g_cube_consistent(internal, public.cube, integer, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'g_cube_consistent';


ALTER FUNCTION public.g_cube_consistent(internal, public.cube, integer, oid, internal) OWNER TO clideadmin;

--
-- Name: g_cube_decompress(internal); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.g_cube_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'g_cube_decompress';


ALTER FUNCTION public.g_cube_decompress(internal) OWNER TO clideadmin;

--
-- Name: g_cube_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.g_cube_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'g_cube_penalty';


ALTER FUNCTION public.g_cube_penalty(internal, internal, internal) OWNER TO clideadmin;

--
-- Name: g_cube_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.g_cube_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'g_cube_picksplit';


ALTER FUNCTION public.g_cube_picksplit(internal, internal) OWNER TO clideadmin;

--
-- Name: g_cube_same(public.cube, public.cube, internal); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.g_cube_same(public.cube, public.cube, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'g_cube_same';


ALTER FUNCTION public.g_cube_same(public.cube, public.cube, internal) OWNER TO clideadmin;

--
-- Name: g_cube_union(internal, internal); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.g_cube_union(internal, internal) RETURNS public.cube
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/cube', 'g_cube_union';


ALTER FUNCTION public.g_cube_union(internal, internal) OWNER TO clideadmin;

--
-- Name: gc_to_sec(double precision); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.gc_to_sec(double precision) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT CASE WHEN $1 < 0 THEN 0::float8 WHEN $1/earth() > pi() THEN 2*earth() ELSE 2*earth()*sin($1/(2*earth())) END$_$;


ALTER FUNCTION public.gc_to_sec(double precision) OWNER TO clideadmin;

--
-- Name: geo_distance(point, point); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.geo_distance(point, point) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/earthdistance', 'geo_distance';


ALTER FUNCTION public.geo_distance(point, point) OWNER TO clideadmin;

--
-- Name: iif_sql(boolean, anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.iif_sql(boolean, anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT case $1 when true then $2 else $3 end $_$;


ALTER FUNCTION public.iif_sql(boolean, anyelement, anyelement) OWNER TO postgres;

--
-- Name: key_summary(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.key_summary(from_date date, to_date date) RETURNS TABLE(change_user character varying, tab character varying, first_date date, last_date date, rows_keyed bigint, days double precision, number_of_stations bigint, pct character varying)
    LANGUAGE sql ROWS 1
    AS $_$
select
  o.change_user,
  'daily' as tab,
  min(o.lsd)::date as first_date,
  max(o.lsd)::date as last_date,
  count(o.*) as rows_keyed,
  (max(o.lsd)::date - min(o.lsd)::date) + 1 as days,
  (SELECT COUNT (agg.*)
    FROM (SELECT distinct o2.station_no
          FROM obs_daily o2
          WHERE date_trunc('day', o2.insert_datetime) >= $1
            AND date_trunc('day', o2.insert_datetime) <= $2
            AND o2.change_user = o.change_user) agg) as number_of_stations,
  TO_CHAR(( count(*)::double precision / (((max(o.lsd)::date - min(o.lsd)::date) + 1) * (SELECT COUNT (agg.*)
      FROM (SELECT distinct o2.station_no
            FROM obs_daily o2
            WHERE date_trunc('day', o2.insert_datetime) >= $1
              AND date_trunc('day', o2.insert_datetime) <= $2
              AND o2.change_user = o.change_user) agg)) ) * 100, '990.0%') as pct
from obs_daily o
where date_trunc('day', o.insert_datetime) >= $1
  and date_trunc('day', o.insert_datetime) <= $2
group by change_user, tab

UNION

select
  o.change_user,
  'subdaily' as tab,
  min(o.lsd::date) as first_date,
  max(o.lsd::date) as last_date,
  count(o.*) as rows_keyed,
  (date_trunc('day', max(o.lsd))::date - date_trunc('day', min(o.lsd))::date) + 1 as days,
  (SELECT COUNT (agg.*)
    FROM (SELECT distinct o2.station_no
          FROM obs_subdaily o2
          WHERE date_trunc('day', o2.insert_datetime) >= $1
            AND date_trunc('day', o2.insert_datetime) <= $2
            AND o2.change_user = o.change_user) agg) as number_of_stations,
  '-' as pct
from obs_subdaily o
where date_trunc('day', o.insert_datetime) >= $1
  and date_trunc('day', o.insert_datetime) <= $2
group by change_user, tab

UNION

select
  o.change_user,
  'monthly' as tab,
  min(o.lsd::date) as first_date,
  max(o.lsd::date) as last_date,
  count(o.*) as rows_keyed,
  (EXTRACT(year FROM age(date_trunc('month', max(o.lsd)::date), date_trunc('month', min(o.lsd)::date)))*12 +
    EXTRACT(month FROM age(date_trunc('month', max(o.lsd)::date), date_trunc('month', min(o.lsd)::date))) + 1) as days,
  (SELECT COUNT (agg.*)
    FROM (SELECT distinct o2.station_no
          FROM obs_monthly o2
          WHERE date_trunc('day', o2.insert_datetime) >= $1
            AND date_trunc('day', o2.insert_datetime) <= $2
            AND o2.change_user = o.change_user) agg) as number_of_stations,
  TO_CHAR(count(*)::double precision /
    ((EXTRACT(year FROM age(date_trunc('month', max(o.lsd)::date), date_trunc('month', min(o.lsd)::date)))*12 +
    EXTRACT(month FROM age(date_trunc('month', max(o.lsd)::date), date_trunc('month', min(o.lsd)::date))) + 1) * (SELECT COUNT (agg.*)
      FROM (SELECT distinct o2.station_no
            FROM obs_monthly o2
            WHERE date_trunc('day', o2.insert_datetime) >= $1
              AND date_trunc('day', o2.insert_datetime) <= $2
              AND o2.change_user = o.change_user) agg))
    * 100, '990.0%') as pct
from obs_monthly o
where date_trunc('day', o.insert_datetime) >= $1
  and date_trunc('day', o.insert_datetime) <= $2
group by change_user, tab

UNION

select
  o.change_user,
  'aero' as tab,
  min(o.lsd::date) as first_date,
  max(o.lsd::date) as last_date,
  count(o.*) as rows_keyed,
  (date_trunc('day', max(o.lsd))::date - date_trunc('day', min(o.lsd))::date) + 1 as days,
  (SELECT COUNT (agg.*)
    FROM (SELECT distinct o2.station_no
          FROM obs_aero o2
          WHERE date_trunc('day', o2.insert_datetime) >= $1
            AND date_trunc('day', o2.insert_datetime) <= $2
            AND o2.change_user = o.change_user) agg) as number_of_stations,
  '-' as pct
from obs_aero o
where date_trunc('day', o.insert_datetime) >= $1
  and date_trunc('day', o.insert_datetime) <= $2
group by change_user, tab

order by change_user, tab;
$_$;


ALTER FUNCTION public.key_summary(from_date date, to_date date) OWNER TO postgres;

--
-- Name: key_summary_with_stations(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.key_summary_with_stations(from_date date, to_date date) RETURNS TABLE(change_user character varying, tab character varying, station_no character varying, first_date date, last_date date, rows_keyed bigint, days double precision, pct character varying)
    LANGUAGE sql ROWS 1
    AS $_$

select
  change_user,
  'daily' as tab,
  station_no,
  min(lsd)::date as first_date,
  max(lsd)::date as last_date,
  count(*) as rows_keyed,
  (max(lsd)::date - min(lsd)::date) + 1 as days,
  TO_CHAR(( count(*)::double precision / ((max(lsd)::date - min(lsd)::date) + 1) ) * 100.0, '990.0%') as pct
from obs_daily
where insert_datetime::date >= $1
  and insert_datetime::date <= $2
group by change_user, tab, station_no

UNION

select
  change_user,
  'subdaily' as tab,
  station_no,
  min(lsd::date) as first_date,
  max(lsd::date) as last_date,
  count(*) as rows_keyed,
  (date_trunc('day', max(lsd))::date - date_trunc('day', min(lsd))::date) + 1 as days,
  '-' as pct
from obs_subdaily
where date_trunc('day', insert_datetime) >= $1
  and date_trunc('day', insert_datetime) <= $2
group by change_user, tab, station_no

UNION

select
  change_user,
  'monthly' as tab,
  station_no,
  min(lsd::date) as first_date,
  max(lsd::date) as last_date,
  count(*) as rows_keyed,
  (EXTRACT(year FROM age(date_trunc('month', max(lsd)::date), date_trunc('month', min(lsd)::date)))*12 +
    EXTRACT(month FROM age(date_trunc('month', max(lsd)::date), date_trunc('month', min(lsd)::date))) + 1) as days,
  TO_CHAR(count(*)::double precision /
    (EXTRACT(year FROM age(date_trunc('month', max(lsd)::date), date_trunc('month', min(lsd)::date)))*12 +
    EXTRACT(month FROM age(date_trunc('month', max(lsd)::date), date_trunc('month', min(lsd)::date))) + 1)
    * 100.0, '990.0%') as pct
from obs_monthly
where date_trunc('day', insert_datetime) >= $1
  and date_trunc('day', insert_datetime) <= $2
group by change_user, tab, station_no

UNION

select
  change_user,
  'aero' as tab,
  station_no,
  min(lsd::date) as first_date,
  max(lsd::date) as last_date,
  count(*) as rows_keyed,
  (date_trunc('day', max(lsd))::date - date_trunc('day', min(lsd))::date) + 1 as days,
  '-' as pct
from obs_aero
where date_trunc('day', insert_datetime) >= $1
  and date_trunc('day', insert_datetime) <= $2
group by change_user, tab, station_no

order by change_user, tab, station_no;
$_$;


ALTER FUNCTION public.key_summary_with_stations(from_date date, to_date date) OWNER TO postgres;

--
-- Name: latitude(public.earth); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.latitude(public.earth) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT CASE WHEN cube_ll_coord($1, 3)/earth() < -1 THEN -90::float8 WHEN cube_ll_coord($1, 3)/earth() > 1 THEN 90::float8 ELSE degrees(asin(cube_ll_coord($1, 3)/earth())) END$_$;


ALTER FUNCTION public.latitude(public.earth) OWNER TO clideadmin;

--
-- Name: lct_to_lsd(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lct_to_lsd(station character varying, lct character varying) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT
  CASE WHEN tm_diff IS NULL THEN $2
       ELSE TO_CHAR($2::timestamp without time zone - CAST((tm_diff - utc_diff)||' hours' AS INTERVAL), 'yyyy-mm-dd HH24:mi')
  END as return_lsd
FROM stations AS s
     INNER JOIN station_timezones AS st ON st.tm_zone = s.time_zone
     LEFT JOIN timezone_diffs AS td ON td.tm_zone = s.time_zone
                                   AND start_timestamp <= $2::date
                                   AND end_timestamp >= $2::date
WHERE station_no = $1;
$_$;


ALTER FUNCTION public.lct_to_lsd(station character varying, lct character varying) OWNER TO postgres;

--
-- Name: lct_to_utc(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lct_to_utc(station character varying, lct character varying) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT
  TO_CHAR($2::timestamp without time zone - CAST(CASE WHEN tm_diff IS NULL THEN utc_diff ELSE tm_diff END||' hours' AS INTERVAL), 'yyyy-mm-dd HH24:mi') as return_utc
FROM stations AS s
     INNER JOIN station_timezones AS st ON st.tm_zone = s.time_zone
     LEFT JOIN timezone_diffs AS td ON td.tm_zone = s.time_zone
                                   AND start_timestamp <= $2::date
                                   AND end_timestamp >= $2::date
WHERE station_no = $1;
$_$;


ALTER FUNCTION public.lct_to_utc(station character varying, lct character varying) OWNER TO postgres;

--
-- Name: ll_to_earth(double precision, double precision); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.ll_to_earth(double precision, double precision) RETURNS public.earth
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT cube(cube(cube(earth()*cos(radians($1))*cos(radians($2))),earth()*cos(radians($1))*sin(radians($2))),earth()*sin(radians($1)))::earth$_$;


ALTER FUNCTION public.ll_to_earth(double precision, double precision) OWNER TO clideadmin;

--
-- Name: longitude(public.earth); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.longitude(public.earth) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT degrees(atan2(cube_ll_coord($1, 2), cube_ll_coord($1, 1)))$_$;


ALTER FUNCTION public.longitude(public.earth) OWNER TO clideadmin;

--
-- Name: lsd_to_lct(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lsd_to_lct(station character varying, lsd character varying) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT
  CASE WHEN tm_diff IS NULL THEN $2
       ELSE TO_CHAR($2::timestamp without time zone - CAST((utc_diff - tm_diff)||' hours' AS INTERVAL), 'yyyy-mm-dd HH24:mi')
  END as return_lct
FROM stations AS s
     INNER JOIN station_timezones AS st ON st.tm_zone = s.time_zone
     LEFT JOIN timezone_diffs AS td ON td.tm_zone = s.time_zone
                                   AND start_timestamp <= $2::date
                                   AND end_timestamp >= $2::date
WHERE station_no = $1;
$_$;


ALTER FUNCTION public.lsd_to_lct(station character varying, lsd character varying) OWNER TO postgres;

--
-- Name: lsd_to_utc(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lsd_to_utc(station character varying, lsd character varying) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT
  TO_CHAR($2::timestamp without time zone - CAST(utc_diff||' hours' AS INTERVAL), 'yyyy-mm-dd HH24:mi') as return_utc
FROM stations AS s
     INNER JOIN station_timezones AS st ON st.tm_zone = s.time_zone
WHERE station_no = $1;
$_$;


ALTER FUNCTION public.lsd_to_utc(station character varying, lsd character varying) OWNER TO postgres;

--
-- Name: monthly_obs(character varying[], character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.monthly_obs(station_array character varying[], nfrom character varying, nto character varying) RETURNS TABLE(station_no character varying, yyyy_mm character varying, max_max_air_temp numeric, min_min_air_temp numeric, min_min_ground_temp numeric, mn_min_ground_temp numeric, mn_max_air_temp numeric, mn_min_air_temp numeric, mn_air_temp numeric, dly_max_rain numeric, tot_rain numeric, tot_rain_days numeric, tot_rain_percent double precision, mn_evaporation numeric, tot_evaporation numeric, mn_sun_hours numeric, mn_asread_pres numeric, mn_msl_pres numeric, mn_station_pres numeric, mn_vapour_pres numeric, mn_rel_humidity numeric, mn_tot_cloud_oktas numeric, mn_wet_bulb_temp numeric)
    LANGUAGE sql
    AS $_$
SELECT daily.station_no,
	daily.yyyy_mm,
	max_max_air_temp,
	min_min_air_temp,
	min_min_ground_temp,
	mn_min_ground_temp,
	mn_max_air_temp,
	mn_min_air_temp,
	mn_air_temp,
	dly_max_rain,
	tot_rain,
	tot_rain_days,
	(missing_count/days_in_month)*100 as tot_rain_percent,
	mn_evaporation,
	tot_evaporation,
	mn_sun_hours,
	mn_asread_pres,
	mn_msl_pres,
	mn_station_pres,
	mn_vapour_pres,
	mn_rel_humidity,
	mn_tot_cloud_oktas,
	mn_wet_bulb_temp
FROM (
--Daily columns
SELECT  station_no,
	to_char(lsd, 'yyyy-mm') as yyyy_mm,
	max(max_air_temp) as max_max_air_temp,
	min(min_air_temp) as min_min_air_temp,
	min(ground_temp) as min_min_ground_temp,
	avg(ground_temp) as mn_min_ground_temp,
	avg(max_air_temp) as mn_max_air_temp,
	avg(min_air_temp) as mn_min_air_temp,
	avg((max_air_temp + min_air_temp)/2) as mn_air_temp,
	max(rain_24h) as dly_max_rain,
	sum(rain_24h) as tot_rain,
	sum(rain_24h_count) as tot_rain_days,
	date_part('day'::text, (((("substring"(to_char(lsd, 'yyyy-mm'), 1, 4) || '-'::text) || "substring"(to_char(lsd, 'yyyy-mm'), 6, 2)) || '-01'::text)::date) + '1 mon'::interval - '1 day'::interval) as days_in_month,
	sum(CASE WHEN rain_24h_qa = '00' THEN 1 ELSE 0 END) as missing_count,
	avg(evaporation) as mn_evaporation,
	sum(evaporation) as tot_evaporation,
	avg(sunshine_duration) as mn_sun_hours
FROM obs_daily
WHERE station_no = ANY($1)
AND lsd >= to_timestamp($2, 'yyyy-mm')
AND lsd < to_timestamp($3, 'yyyy-mm') + '1 month'::interval
GROUP BY station_no, to_char(lsd, 'yyyy-mm')
) daily

FULL JOIN (
--Sub Daily columns
SELECT  station_no,
	to_char(lsd, 'yyyy-mm') as yyyy_mm,
	avg(pres_as_read) as mn_asread_pres,
	avg(msl_pres) as mn_msl_pres,
	avg(station_pres) as mn_station_pres,
	avg(vapour_pres) as mn_vapour_pres,
	avg(rel_humidity) as mn_rel_humidity,
	avg(tot_cloud_oktas) as mn_tot_cloud_oktas,
	avg(wet_bulb) as mn_wet_bulb_temp
FROM obs_subdaily
WHERE station_no = ANY($1)
AND lsd >= to_timestamp($2, 'yyyy-mm')
AND lsd < to_timestamp($3, 'yyyy-mm') + '1 month'::interval
GROUP BY station_no, to_char(lsd, 'yyyy-mm')
) subdaily
ON daily.station_no = subdaily.station_no
AND daily.yyyy_mm = subdaily.yyyy_mm;
$_$;


ALTER FUNCTION public.monthly_obs(station_array character varying[], nfrom character varying, nto character varying) OWNER TO postgres;

--
-- Name: monthly_rain_quintile(character varying, character varying, numeric, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.monthly_rain_quintile(station character varying, month character varying, inrain numeric, nfrom character varying, nto character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE res RECORD;
DECLARE prev_max NUMERIC(7,1);
DECLARE prev_quintile integer;

BEGIN
	FOR res IN
	
		select mm, quintile, min(rain) as min, max(rain) as max
		from (
		select mm, rain, ntile(5) over (partition by mm order by rain) as quintile
			from (
				select rain, substr(year_mm, 6,2) as mm
				from (
					select sum(rain_24h) as rain, to_char(lsd, 'yyyy-mm') as year_mm
					from obs_daily
					where lsd > to_timestamp($4, 'yyyy-mm') AND lsd <= to_timestamp($5, 'yyyy-mm')
					and station_no = $1		
					group by to_char(lsd, 'yyyy-mm')
				) z
			) x WHERE mm = $2
		) y
		group by mm, quintile
		order by mm, quintile

	LOOP	--Logic to extract appropriate quintile 

	--Lower than the minimum value in lowest quintile...return 0
	IF res.quintile = 1 AND $3 < res.min THEN
		RETURN 0;
	END IF;

	--res.min is rank minimum amt, res.max is rank maximum amt, res.quintile is rank
	IF $3 >= res.min AND $3 <= res.max THEN
		--Amount is definitely in this quintile
		RETURN res.quintile;
	ELSIF $3 < res.min THEN	
		--need to determine if part of this or previous quintile.
		--calculate half-way between maximum of prev and minimum of current
		IF $3 > (prev_max + (res.min-prev_max)/2) THEN
			RETURN res.quintile;
		ELSE
			RETURN prev_quintile;
		END IF;
	ELSE
		prev_max = res.max;
		prev_quintile = res.quintile;
	END IF;
	END LOOP;

	--No quintile has been selected! Value must be bigger than max in last group...return 6.
	RETURN 6;

END
$_$;


ALTER FUNCTION public.monthly_rain_quintile(station character varying, month character varying, inrain numeric, nfrom character varying, nto character varying) OWNER TO postgres;

--
-- Name: normal_rand(integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.normal_rand(integer, double precision, double precision) RETURNS SETOF double precision
    LANGUAGE c STRICT
    AS '$libdir/tablefunc', 'normal_rand';


ALTER FUNCTION public.normal_rand(integer, double precision, double precision) OWNER TO clideadmin;

--
-- Name: obs_monthly_summary(character varying, date, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.obs_monthly_summary(stat_no character varying, yyyy_mm date, subdaily_time time without time zone) RETURNS TABLE(station_no character varying, month text, tot_rain numeric, max_rain numeric, max_rain_date text, mn_max_air_temp numeric, mn_min_air_temp numeric, max_max_air_temp numeric, max_max_temp_date text, min_max_air_temp numeric, min_max_temp_date text, min_min_air_temp numeric, min_min_temp_date text, max_min_air_temp numeric, max_min_temp_date text, mean_temp text, max_ground_temp numeric, max_ground_date text, min_ground_temp numeric, min_ground_date text, mn_ground_temp numeric, x01_days_count bigint, x02_days_count bigint, x1_days_count bigint, x10_days_count bigint, x50_days_count bigint, temp_gt30_count bigint, temp_lt20_count bigint, non_rain_days_count bigint, min_msl_pressure numeric, min_mslp_date text, max_msl_pressure numeric, max_mslp_date text, avg_msl_pressure text, tot_evaporation numeric, avg_evaporation text, tot_sunshine numeric, avg_sunshine text, max_gust numeric, max_gust_date text, max_wind_run numeric, max_run_date text, mn_9am_wind_speed numeric)
    LANGUAGE sql ROWS 1
    AS $_$
SELECT a.station_no, a.mon AS month, max(a.tot_rain) AS tot_rain, max(a.max_rain) AS max_rain, min(a.max_rain_date) AS max_rain_date, max(a.mn_max_air_temp) as mn_max_air_temp, max(a.mn_min_air_temp) as mn_min_air_temp, max(a.max_max_air_temp) AS max_max_air_temp, min(a.max_max_temp_date) AS max_max_temp_date, min(a.min_max_air_temp) AS min_max_air_temp, min(a.min_max_temp_date) AS min_max_temp_date, min(a.min_min_air_temp) AS min_min_air_temp, min(a.min_min_temp_date) AS min_min_temp_date, max(a.max_min_air_temp) AS max_min_air_temp, min(a.max_min_temp_date) AS max_min_temp_date, min(a.mean_temp) AS mean_temp, max(a.max_ground_temp) AS max_ground_temp, min(a.max_ground_date) AS max_ground_date, min(a.min_ground_temp) AS min_ground_temp, min(a.min_ground_date) AS min_ground_date, max(a.mn_ground_temp) as mn_ground_temp, max(a.x01_rain_count) AS x01_days_count, max(a.x02_rain_count) AS x02_days_count, max(a.x1_rain_count) AS x1_days_count, max(a.x10_rain_count) AS x10_days_count, max(a.x50_rain_count) AS x50_days_count, max(a.temp_gt30_count) AS temp_gt30_count, max(a.temp_lt20_count) AS temp_lt20_count, max(a.non_rain_count) AS non_rain_days_count, max(a.min_msl_pres) AS min_msl_pressure, min(a.min_mslp_date) AS min_mslp_date, max(a.max_msl_pres) AS max_msl_pressure, min(a.max_mslp_date) AS max_mslp_date, max(a.avg_msl_pres) AS avg_msl_pressure, max(a.tot_evaporation) AS tot_evaporation, max(a.avg_evaporation) AS avg_evaporation, max(a.tot_sunshine) AS tot_sunshine, max(a.avg_sunshine) AS avg_sunshine, max(a.max_gust) AS max_gust, min(a.max_gust_date) AS max_gust_date, max(a.max_wind_run) AS max_wind_run, min(a.max_run_date) AS max_run_date, max(mn_9am_wind_speed) as mn_9am_wind_speed
   FROM ( SELECT dat.station_no, dat.mon, dat.tot_rain, dat.max_rain, maxraindate.max_rain_date, round(dat.mn_max_air_temp,1) as mn_max_air_temp, round(dat.mn_min_air_temp,1) as mn_min_air_temp, dat.max_max_air_temp, maxmaxtempdate.max_max_temp_date, dat.min_max_air_temp, minmaxtempdate.min_max_temp_date, dat.min_min_air_temp, minmintempdate.min_min_temp_date, dat.max_min_air_temp, maxmintempdate.max_min_temp_date, to_char(dat.mean_temp, '9999990.0'::text) AS mean_temp, dat.max_ground_temp, round(dat.mn_ground_temp,1) as mn_ground_temp, maxgrounddate.max_ground_date, dat.min_ground_temp, mingrounddate.min_ground_date, dat.x01_rain_count, dat.x02_rain_count, dat.x1_rain_count, dat.x10_rain_count, dat.x50_rain_count, dat.non_rain_count, dat.temp_gt30_count, dat.temp_lt20_count, subdaily.min_msl_pres, minmslpdate.min_mslp_date, subdaily.max_msl_pres, maxmslpdate.max_mslp_date, to_char(subdaily.avg_msl_pres, '9999990.0'::text) AS avg_msl_pres, dat.tot_evaporation, to_char(dat.avg_evaporation, '9999990.0'::text) AS avg_evaporation, dat.tot_sunshine, to_char(dat.avg_sunshine, '9999990.0'::text) AS avg_sunshine, dat.max_gust, maxgustdate.max_gust_date, dat.max_wind_run, maxrundate.max_run_date, round(subdaily_9am.mn_9am_wind_speed,1) as mn_9am_wind_speed
           FROM ( SELECT day.station_no, to_char(day.lsd, 'Mon yyyy'::text) AS mon, sum(day.rain_24h) AS tot_rain, max(day.rain_24h) AS max_rain, avg(day.max_air_temp) AS mn_max_air_temp, avg(day.min_air_temp) AS mn_min_air_temp, max(day.max_air_temp) AS max_max_air_temp, min(day.max_air_temp) AS min_max_air_temp, min(day.min_air_temp) AS min_min_air_temp, max(day.min_air_temp) AS max_min_air_temp, avg((day.max_air_temp + day.min_air_temp) / 2::numeric) AS mean_temp, min(day.ground_temp) AS min_ground_temp, max(day.ground_temp) AS max_ground_temp, avg(day.ground_temp) AS mn_ground_temp, sum(
                        CASE
                            WHEN day.rain_24h >= 0.1 THEN 1
                            ELSE 0
                        END) AS x01_rain_count, sum(
                        CASE
                            WHEN day.rain_24h >= 0.2 THEN 1
                            ELSE 0
                        END) AS x02_rain_count, sum(
                        CASE
                            WHEN day.rain_24h >= 1::numeric THEN 1
                            ELSE 0
                        END) AS x1_rain_count, sum(
                        CASE
                            WHEN day.rain_24h >= 10::numeric THEN 1
                            ELSE 0
                        END) AS x10_rain_count, sum(
                        CASE
                            WHEN day.rain_24h >= 50::numeric THEN 1
                            ELSE 0
                        END) AS x50_rain_count, sum(
                        CASE
                            WHEN day.rain_24h < 0.1 THEN 1
                            ELSE 0
                        END) AS non_rain_count, sum(
                        CASE
                            WHEN day.max_air_temp >= 30.0 THEN 1
                            ELSE 0
                        END) AS temp_gt30_count, sum(
                        CASE
                            WHEN day.min_air_temp <= 20.0 THEN 1
                            ELSE 0
                        END) AS temp_lt20_count, sum(day.evaporation) AS tot_evaporation, avg(day.evaporation) AS avg_evaporation, sum(day.sunshine_duration) AS tot_sunshine, avg(day.sunshine_duration) AS avg_sunshine, max(day.max_gust_speed) AS max_gust, max(day.wind_run_gt10) AS max_wind_run
                   FROM obs_daily day
                   WHERE upper(day.station_no) = $1
                     AND date_trunc('month', day.lsd) = $2
                  GROUP BY day.station_no, to_char(day.lsd, 'Mon yyyy'::text)) dat
      LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_max_temp_date, obs_daily.max_air_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
                   FROM obs_daily
                   WHERE upper(station_no) = $1) maxmaxtempdate ON dat.station_no::text = maxmaxtempdate.station_no::text AND dat.mon = maxmaxtempdate.mon AND dat.max_max_air_temp = maxmaxtempdate.max_air_temp
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS min_max_temp_date, obs_daily.max_air_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
              FROM obs_daily
              WHERE upper(station_no) = $1) minmaxtempdate ON dat.station_no::text = minmaxtempdate.station_no::text AND dat.mon = minmaxtempdate.mon AND dat.min_max_air_temp = minmaxtempdate.max_air_temp
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS min_min_temp_date, obs_daily.min_air_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
         FROM obs_daily
         WHERE upper(station_no) = $1) minmintempdate ON dat.min_min_air_temp = minmintempdate.min_air_temp AND dat.mon = minmintempdate.mon AND dat.station_no::text = minmintempdate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_min_temp_date, obs_daily.min_air_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
    FROM obs_daily
    WHERE upper(station_no) = $1) maxmintempdate ON dat.max_min_air_temp = maxmintempdate.min_air_temp AND dat.mon = maxmintempdate.mon AND dat.station_no::text = maxmintempdate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_rain_date, obs_daily.rain_24h, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily
   WHERE upper(station_no) = $1) maxraindate ON dat.max_rain = maxraindate.rain_24h AND dat.mon = maxraindate.mon AND dat.station_no::text = maxraindate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS min_ground_date, obs_daily.ground_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily) mingrounddate ON dat.min_ground_temp = mingrounddate.ground_temp AND dat.mon = mingrounddate.mon AND dat.station_no::text = mingrounddate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_ground_date, obs_daily.ground_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily
   WHERE upper(station_no) = $1) maxgrounddate ON dat.max_ground_temp = maxgrounddate.ground_temp AND dat.mon = maxgrounddate.mon AND dat.station_no::text = maxgrounddate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_gust_date, obs_daily.max_gust_speed, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily
   WHERE upper(station_no) = $1) maxgustdate ON dat.max_gust = maxgustdate.max_gust_speed AND dat.mon = maxgustdate.mon AND dat.station_no::text = maxgustdate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_run_date, obs_daily.wind_run_gt10, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily
   WHERE upper(station_no) = $1) maxrundate ON dat.max_wind_run = maxrundate.wind_run_gt10 AND dat.mon = maxrundate.mon AND dat.station_no::text = maxrundate.station_no::text
   LEFT JOIN ( SELECT obs_subdaily.station_no, to_char(obs_subdaily.lsd, 'Mon yyyy'::text) AS mon, avg(obs_subdaily.wind_speed) AS mn_9am_wind_speed
   FROM obs_subdaily
   WHERE upper(station_no) = $1
     AND lct::time = $3
  GROUP BY obs_subdaily.station_no, to_char(obs_subdaily.lsd, 'Mon yyyy'::text)) subdaily_9am ON dat.mon = subdaily_9am.mon AND dat.station_no::text = subdaily_9am.station_no::text
   LEFT JOIN ( SELECT obs_subdaily.station_no, to_char(obs_subdaily.lsd, 'Mon yyyy'::text) AS mon, min(obs_subdaily.msl_pres) AS min_msl_pres, max(obs_subdaily.msl_pres) AS max_msl_pres, avg(obs_subdaily.msl_pres) AS avg_msl_pres
   FROM obs_subdaily
   WHERE upper(station_no) = $1
  GROUP BY obs_subdaily.station_no, to_char(obs_subdaily.lsd, 'Mon yyyy'::text)) subdaily ON dat.mon = subdaily.mon AND dat.station_no::text = subdaily.station_no::text
   LEFT JOIN ( SELECT obs_subdaily.station_no, obs_subdaily.lsd, to_char(obs_subdaily.lsd, 'Dy ddth'::text) AS max_mslp_date, obs_subdaily.msl_pres, to_char(obs_subdaily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_subdaily
   WHERE upper(station_no) = $1) maxmslpdate ON subdaily.max_msl_pres = maxmslpdate.msl_pres AND subdaily.mon = maxmslpdate.mon AND subdaily.station_no::text = maxmslpdate.station_no::text
   LEFT JOIN ( SELECT obs_subdaily.station_no, obs_subdaily.lsd, to_char(obs_subdaily.lsd, 'Dy ddth'::text) AS min_mslp_date, obs_subdaily.msl_pres, to_char(obs_subdaily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_subdaily
   WHERE upper(station_no) = $1) minmslpdate ON subdaily.min_msl_pres = minmslpdate.msl_pres AND subdaily.mon = minmslpdate.mon AND subdaily.station_no::text = minmslpdate.station_no::text) a
  GROUP BY a.station_no, a.mon;$_$;


ALTER FUNCTION public.obs_monthly_summary(stat_no character varying, yyyy_mm date, subdaily_time time without time zone) OWNER TO postgres;

--
-- Name: obs_monthly_summary_high(character varying, date, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.obs_monthly_summary_high(stat_no character varying, yyyy_mm date, subdaily_time time without time zone) RETURNS TABLE(station_no character varying, month text, tot_rain numeric, max_rain numeric, max_rain_date text, mn_max_air_temp numeric, mn_min_air_temp numeric, max_max_air_temp numeric, max_max_temp_date text, min_max_air_temp numeric, min_max_temp_date text, min_min_air_temp numeric, min_min_temp_date text, max_min_air_temp numeric, max_min_temp_date text, mean_temp text, max_ground_temp numeric, max_ground_date text, min_ground_temp numeric, min_ground_date text, mn_ground_temp numeric, x01_days_count bigint, x02_days_count bigint, x1_days_count bigint, x10_days_count bigint, x50_days_count bigint, temp_gt30_count bigint, temp_lt20_count bigint, non_rain_days_count bigint, min_msl_pressure numeric, min_mslp_date text, max_msl_pressure numeric, max_mslp_date text, avg_msl_pressure text, tot_evaporation numeric, avg_evaporation text, tot_sunshine numeric, avg_sunshine text, max_gust numeric, max_gust_date text, max_wind_run numeric, max_run_date text, mn_9am_wind_speed numeric)
    LANGUAGE sql ROWS 1
    AS $_$
SELECT a.station_no, a.mon AS month, max(a.tot_rain) AS tot_rain, max(a.max_rain) AS max_rain, min(a.max_rain_date) AS max_rain_date, max(a.mn_max_air_temp) as mn_max_air_temp, min(a.mn_min_air_temp) as mn_min_air_temp, max(a.max_max_air_temp) AS max_max_air_temp, min(a.max_max_temp_date) AS max_max_temp_date, min(a.min_max_air_temp) AS min_max_air_temp, min(a.min_max_temp_date) AS min_max_temp_date, min(a.min_min_air_temp) AS min_min_air_temp, min(a.min_min_temp_date) AS min_min_temp_date, max(a.max_min_air_temp) AS max_min_air_temp, min(a.max_min_temp_date) AS max_min_temp_date, min(a.mean_temp) AS mean_temp, max(a.max_ground_temp) AS max_ground_temp, min(a.max_ground_date) AS max_ground_date, min(a.min_ground_temp) AS min_ground_temp, min(a.min_ground_date) AS min_ground_date, max(a.mn_ground_temp) as mn_ground_temp, max(a.x01_rain_count) AS x01_days_count, max(a.x02_rain_count) AS x02_days_count, max(a.x1_rain_count) AS x1_days_count, max(a.x10_rain_count) AS x10_days_count, max(a.x50_rain_count) AS x50_days_count, max(a.temp_gt30_count) AS temp_gt30_count, max(a.temp_lt20_count) AS temp_lt20_count, max(a.non_rain_count) AS non_rain_days_count, max(a.min_msl_pres) AS min_msl_pressure, min(a.min_mslp_date) AS min_mslp_date, max(a.max_msl_pres) AS max_msl_pressure, min(a.max_mslp_date) AS max_mslp_date, max(a.avg_msl_pres) AS avg_msl_pressure, max(a.tot_evaporation) AS tot_evaporation, max(a.avg_evaporation) AS avg_evaporation, max(a.tot_sunshine) AS tot_sunshine, max(a.avg_sunshine) AS avg_sunshine, max(a.max_gust) AS max_gust, min(a.max_gust_date) AS max_gust_date, max(a.max_wind_run) AS max_wind_run, min(a.max_run_date) AS max_run_date, max(mn_9am_wind_speed) as mn_9am_wind_speed
   FROM ( SELECT dat.station_no, dat.mon, dat.tot_rain, dat.max_rain, maxraindate.max_rain_date, dat.max_max_air_temp, maxmaxtempdate.max_max_temp_date, round(dat.mn_max_air_temp,1) as mn_max_air_temp, round(dat.mn_min_air_temp,1) as mn_min_air_temp, dat.min_max_air_temp, minmaxtempdate.min_max_temp_date, dat.min_min_air_temp, minmintempdate.min_min_temp_date, dat.max_min_air_temp, maxmintempdate.max_min_temp_date, to_char(dat.mean_temp, '9999990.0'::text) AS mean_temp, dat.max_ground_temp, maxgrounddate.max_ground_date, dat.min_ground_temp, mingrounddate.min_ground_date, round(dat.mn_ground_temp,1) as mn_ground_temp, dat.x01_rain_count, dat.x02_rain_count, dat.x1_rain_count, dat.x10_rain_count, dat.x50_rain_count, dat.non_rain_count, dat.temp_gt30_count, dat.temp_lt20_count, subdaily.min_msl_pres, minmslpdate.min_mslp_date, subdaily.max_msl_pres, maxmslpdate.max_mslp_date, to_char(subdaily.avg_msl_pres, '9999990.0'::text) AS avg_msl_pres, dat.tot_evaporation, to_char(dat.avg_evaporation, '9999990.0'::text) AS avg_evaporation, dat.tot_sunshine, to_char(dat.avg_sunshine, '9999990.0'::text) AS avg_sunshine, dat.max_gust, maxgustdate.max_gust_date, dat.max_wind_run, maxrundate.max_run_date, round(subdaily_9am.mn_9am_wind_speed,1) as mn_9am_wind_speed
           FROM ( SELECT day.station_no, to_char(day.lsd, 'Mon yyyy'::text) AS mon, sum(day.rain_24h) AS tot_rain, max(day.rain_24h) AS max_rain, avg(day.max_air_temp) AS mn_max_air_temp, avg(day.min_air_temp) AS mn_min_air_temp, max(day.max_air_temp) AS max_max_air_temp, min(day.max_air_temp) AS min_max_air_temp, min(day.min_air_temp) AS min_min_air_temp, max(day.min_air_temp) AS max_min_air_temp, avg((day.max_air_temp + day.min_air_temp) / 2::numeric) AS mean_temp, min(day.ground_temp) AS min_ground_temp, max(day.ground_temp) AS max_ground_temp, avg(day.ground_temp) AS mn_ground_temp, sum(
                        CASE
                            WHEN day.rain_24h >= 0.1 THEN 1
                            ELSE 0
                        END) AS x01_rain_count, sum(
                        CASE
                            WHEN day.rain_24h >= 0.2 THEN 1
                            ELSE 0
                        END) AS x02_rain_count, sum(
                        CASE
                            WHEN day.rain_24h >= 1::numeric THEN 1
                            ELSE 0
                        END) AS x1_rain_count, sum(
                        CASE
                            WHEN day.rain_24h >= 10::numeric THEN 1
                            ELSE 0
                        END) AS x10_rain_count, sum(
                        CASE
                            WHEN day.rain_24h >= 50::numeric THEN 1
                            ELSE 0
                        END) AS x50_rain_count, sum(
                        CASE
                            WHEN day.rain_24h < 0.1 THEN 1
                            ELSE 0
                        END) AS non_rain_count, sum(
                        CASE
                            WHEN day.max_air_temp >= 30.0 THEN 1
                            ELSE 0
                        END) AS temp_gt30_count, sum(
                        CASE
                            WHEN day.min_air_temp <= 20.0 THEN 1
                            ELSE 0
                        END) AS temp_lt20_count, sum(day.evaporation) AS tot_evaporation, avg(day.evaporation) AS avg_evaporation, sum(day.sunshine_duration) AS tot_sunshine, avg(day.sunshine_duration) AS avg_sunshine, max(day.max_gust_speed) AS max_gust, max(day.wind_run_gt10) AS max_wind_run
                   FROM obs_daily day
                  WHERE upper(day.station_no) = $1
                    AND date_trunc('month', day.lsd) = $2
                    AND (day.rain_24h IS NULL OR (day.rain_24h_qa IN ( SELECT codes_simple.code
                           FROM codes_simple
                          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) AND (day.max_air_temp IS NULL OR (day.max_air_temp_qa IN ( SELECT codes_simple.code
                           FROM codes_simple
                          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) AND (day.min_air_temp IS NULL OR (day.min_air_temp_qa IN ( SELECT codes_simple.code
                           FROM codes_simple
                          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) AND (day.ground_temp IS NULL OR (day.ground_temp_qa IN ( SELECT codes_simple.code
                           FROM codes_simple
                          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) AND (day.evaporation IS NULL OR (day.evaporation_qa IN ( SELECT codes_simple.code
                           FROM codes_simple
                          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) AND (day.sunshine_duration IS NULL OR (day.sunshine_duration_qa IN ( SELECT codes_simple.code
                           FROM codes_simple
                          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) AND (day.max_gust_speed IS NULL OR (day.max_gust_speed_qa IN ( SELECT codes_simple.code
                           FROM codes_simple
                          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) AND (day.wind_run_gt10 IS NULL OR (day.wind_run_gt10_qa IN ( SELECT codes_simple.code
                           FROM codes_simple
                          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text)))
                  GROUP BY day.station_no, to_char(day.lsd, 'Mon yyyy'::text)) dat
      LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_max_temp_date, obs_daily.max_air_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
                   FROM obs_daily
                  WHERE upper(station_no) = $1
                    AND (obs_daily.max_air_temp_qa IN ( SELECT codes_simple.code
                           FROM codes_simple
                          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) maxmaxtempdate ON dat.station_no::text = maxmaxtempdate.station_no::text AND dat.mon = maxmaxtempdate.mon AND dat.max_max_air_temp = maxmaxtempdate.max_air_temp
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS min_max_temp_date, obs_daily.max_air_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
              FROM obs_daily
             WHERE upper(station_no) = $1
               AND (obs_daily.max_air_temp_qa IN ( SELECT codes_simple.code
                      FROM codes_simple
                     WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) minmaxtempdate ON dat.station_no::text = minmaxtempdate.station_no::text AND dat.mon = minmaxtempdate.mon AND dat.min_max_air_temp = minmaxtempdate.max_air_temp
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS min_min_temp_date, obs_daily.min_air_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
         FROM obs_daily
        WHERE upper(station_no) = $1
          AND (obs_daily.min_air_temp_qa IN ( SELECT codes_simple.code
                 FROM codes_simple
                WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) minmintempdate ON dat.min_min_air_temp = minmintempdate.min_air_temp AND dat.mon = minmintempdate.mon AND dat.station_no::text = minmintempdate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_min_temp_date, obs_daily.min_air_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
    FROM obs_daily
   WHERE upper(station_no) = $1
     AND (obs_daily.min_air_temp_qa IN ( SELECT codes_simple.code
            FROM codes_simple
           WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) maxmintempdate ON dat.max_min_air_temp = maxmintempdate.min_air_temp AND dat.mon = maxmintempdate.mon AND dat.station_no::text = maxmintempdate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_rain_date, obs_daily.rain_24h, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily
  WHERE upper(station_no) = $1
    AND (obs_daily.rain_24h_qa IN ( SELECT codes_simple.code
           FROM codes_simple
          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) maxraindate ON dat.max_rain = maxraindate.rain_24h AND dat.mon = maxraindate.mon AND dat.station_no::text = maxraindate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS min_ground_date, obs_daily.ground_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily
  WHERE upper(station_no) = $1
    AND (obs_daily.ground_temp_qa IN ( SELECT codes_simple.code
           FROM codes_simple
          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) mingrounddate ON dat.min_ground_temp = mingrounddate.ground_temp AND dat.mon = mingrounddate.mon AND dat.station_no::text = mingrounddate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_ground_date, obs_daily.ground_temp, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily
  WHERE upper(station_no) = $1
    AND (obs_daily.ground_temp_qa IN ( SELECT codes_simple.code
           FROM codes_simple
          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) maxgrounddate ON dat.max_ground_temp = maxgrounddate.ground_temp AND dat.mon = maxgrounddate.mon AND dat.station_no::text = maxgrounddate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_gust_date, obs_daily.max_gust_speed, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily
  WHERE upper(station_no) = $1
    AND (obs_daily.max_gust_speed_qa IN ( SELECT codes_simple.code
           FROM codes_simple
          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) maxgustdate ON dat.max_gust = maxgustdate.max_gust_speed AND dat.mon = maxgustdate.mon AND dat.station_no::text = maxgustdate.station_no::text
   LEFT JOIN ( SELECT obs_daily.station_no, obs_daily.lsd, to_char(obs_daily.lsd, 'Dy ddth'::text) AS max_run_date, obs_daily.wind_run_gt10, to_char(obs_daily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_daily
  WHERE upper(station_no) = $1
    AND (obs_daily.wind_run_gt10_qa IN ( SELECT codes_simple.code
           FROM codes_simple
          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) maxrundate ON dat.max_wind_run = maxrundate.wind_run_gt10 AND dat.mon = maxrundate.mon AND dat.station_no::text = maxrundate.station_no::text
   LEFT JOIN ( SELECT obs_subdaily.station_no, to_char(obs_subdaily.lsd, 'Mon yyyy'::text) AS mon, avg(obs_subdaily.wind_speed) AS mn_9am_wind_speed
   FROM obs_subdaily
   WHERE upper(station_no) = $1
     AND lct::time = $3
     AND (obs_subdaily.wind_speed_qa IN ( SELECT codes_simple.code
           FROM codes_simple
          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))
  GROUP BY obs_subdaily.station_no, to_char(obs_subdaily.lsd, 'Mon yyyy'::text)) subdaily_9am ON dat.mon = subdaily_9am.mon AND dat.station_no::text = subdaily_9am.station_no::text
   LEFT JOIN ( SELECT obs_subdaily.station_no, to_char(obs_subdaily.lsd, 'Mon yyyy'::text) AS mon, min(obs_subdaily.msl_pres) AS min_msl_pres, max(obs_subdaily.msl_pres) AS max_msl_pres, avg(obs_subdaily.msl_pres) AS avg_msl_pres
   FROM obs_subdaily
  WHERE upper(station_no) = $1
    AND (obs_subdaily.msl_pres_qa IN ( SELECT codes_simple.code
           FROM codes_simple
          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))
  GROUP BY obs_subdaily.station_no, to_char(obs_subdaily.lsd, 'Mon yyyy'::text)) subdaily ON dat.mon = subdaily.mon AND dat.station_no::text = subdaily.station_no::text
   LEFT JOIN ( SELECT obs_subdaily.station_no, obs_subdaily.lsd, to_char(obs_subdaily.lsd, 'Dy ddth'::text) AS max_mslp_date, obs_subdaily.msl_pres, to_char(obs_subdaily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_subdaily
  WHERE upper(station_no) = $1
    AND (obs_subdaily.msl_pres_qa IN ( SELECT codes_simple.code
           FROM codes_simple
          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) maxmslpdate ON subdaily.max_msl_pres = maxmslpdate.msl_pres AND subdaily.mon = maxmslpdate.mon AND subdaily.station_no::text = maxmslpdate.station_no::text
   LEFT JOIN ( SELECT obs_subdaily.station_no, obs_subdaily.lsd, to_char(obs_subdaily.lsd, 'Dy ddth'::text) AS min_mslp_date, obs_subdaily.msl_pres, to_char(obs_subdaily.lsd, 'Mon yyyy'::text) AS mon
   FROM obs_subdaily
  WHERE upper(station_no) = $1
    AND (obs_subdaily.msl_pres_qa IN ( SELECT codes_simple.code
           FROM codes_simple
          WHERE codes_simple.code_type::text = 'QUAL_HIGH'::text))) minmslpdate ON subdaily.min_msl_pres = minmslpdate.msl_pres AND subdaily.mon = minmslpdate.mon AND subdaily.station_no::text = minmslpdate.station_no::text) a
  GROUP BY a.station_no, a.mon;$_$;


ALTER FUNCTION public.obs_monthly_summary_high(stat_no character varying, yyyy_mm date, subdaily_time time without time zone) OWNER TO postgres;

--
-- Name: sec_to_gc(double precision); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.sec_to_gc(double precision) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT CASE WHEN $1 < 0 THEN 0::float8 WHEN $1/(2*earth()) > 1 THEN pi()*earth() ELSE 2*earth()*asin($1/(2*earth())) END$_$;


ALTER FUNCTION public.sec_to_gc(double precision) OWNER TO clideadmin;

--
-- Name: stations_id_wmo_dates_trg(); Type: FUNCTION; Schema: public; Owner: clideadmin
--

CREATE FUNCTION public.stations_id_wmo_dates_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    myrec RECORD;
  BEGIN
    IF TG_OP = 'INSERT' THEN
      SELECT * INTO myrec
        FROM stations
        WHERE id_wmo = NEW.id_wmo
          AND (start_date < NEW.end_date or NEW.end_date is null)
          AND (end_date > NEW.start_date or end_date is null);
      IF FOUND THEN
        RAISE EXCEPTION 'INSERT failed: overlapping dates with same id_wmo % for station_no % with dates (%,%)',
            myrec.id_wmo, myrec.station_no, myrec.start_date, myrec.end_date;
      END IF;
    END IF;
    IF TG_OP = 'UPDATE' THEN
      SELECT * INTO myrec
        FROM stations
        WHERE id_wmo = NEW.id_wmo
          AND (start_date < NEW.end_date or NEW.end_date is null)
          AND (end_date > NEW.start_date or end_date is null)
          AND id <> OLD.id;
      IF FOUND THEN
        RAISE EXCEPTION 'INSERT failed: overlapping dates with same id_wmo % for station_no % with dates (%,%)',
            myrec.id_wmo, myrec.station_no, myrec.start_date, myrec.end_date;
      END IF;
    END IF;

    RETURN NEW;
  END;
$$;


ALTER FUNCTION public.stations_id_wmo_dates_trg() OWNER TO clideadmin;

--
-- Name: utc_to_lct(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.utc_to_lct(station character varying, utc character varying) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT
  TO_CHAR($2::timestamp without time zone + CAST(CASE WHEN tm_diff IS NULL THEN utc_diff ELSE tm_diff END||' hours' AS INTERVAL), 'yyyy-mm-dd HH24:mi') as return_lct
FROM stations AS s
     INNER JOIN station_timezones AS st ON st.tm_zone = s.time_zone
     LEFT JOIN timezone_diffs AS td ON td.tm_zone = s.time_zone
                                   AND start_timestamp <= $2::date
                                   AND end_timestamp >= $2::date
 WHERE station_no = $1;
$_$;


ALTER FUNCTION public.utc_to_lct(station character varying, utc character varying) OWNER TO postgres;

--
-- Name: utc_to_lsd(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.utc_to_lsd(station character varying, utc character varying) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$
SELECT
  TO_CHAR($2::timestamp without time zone + CAST(utc_diff||' hours' AS INTERVAL), 'yyyy-mm-dd HH24:mi') as return_lsd
FROM stations AS s
     INNER JOIN station_timezones AS st ON st.tm_zone = s.time_zone
WHERE station_no = $1;
$_$;


ALTER FUNCTION public.utc_to_lsd(station character varying, utc character varying) OWNER TO postgres;

--
-- Name: &&; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.&& (
    FUNCTION = public.cube_overlap,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.&&),
    RESTRICT = areasel,
    JOIN = areajoinsel
);


ALTER OPERATOR public.&& (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: <; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.< (
    FUNCTION = public.cube_lt,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.>),
    NEGATOR = OPERATOR(public.>=),
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.<= (
    FUNCTION = public.cube_le,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.>=),
    NEGATOR = OPERATOR(public.>),
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.<> (
    FUNCTION = public.cube_ne,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.<>),
    NEGATOR = OPERATOR(public.=),
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: <@; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.<@ (
    FUNCTION = public.cube_contained,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.@>),
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: <@>; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.<@> (
    FUNCTION = public.geo_distance,
    LEFTARG = point,
    RIGHTARG = point,
    COMMUTATOR = OPERATOR(public.<@>)
);


ALTER OPERATOR public.<@> (point, point) OWNER TO clideadmin;

--
-- Name: =; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.= (
    FUNCTION = public.cube_eq,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.=),
    NEGATOR = OPERATOR(public.<>),
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: >; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.> (
    FUNCTION = public.cube_gt,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.<),
    NEGATOR = OPERATOR(public.<=),
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.>= (
    FUNCTION = public.cube_ge,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.<=),
    NEGATOR = OPERATOR(public.<),
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: @; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.@ (
    FUNCTION = public.cube_contains,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.~),
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: @>; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.@> (
    FUNCTION = public.cube_contains,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.<@),
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: clideadmin
--

CREATE OPERATOR public.~ (
    FUNCTION = public.cube_contained,
    LEFTARG = public.cube,
    RIGHTARG = public.cube,
    COMMUTATOR = OPERATOR(public.@),
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (public.cube, public.cube) OWNER TO clideadmin;

--
-- Name: cube_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY public.cube_ops USING btree;


ALTER OPERATOR FAMILY public.cube_ops USING btree OWNER TO postgres;

--
-- Name: cube_ops; Type: OPERATOR CLASS; Schema: public; Owner: clideadmin
--

CREATE OPERATOR CLASS public.cube_ops
    DEFAULT FOR TYPE public.cube USING btree FAMILY public.cube_ops AS
    OPERATOR 1 public.<(public.cube,public.cube) ,
    OPERATOR 2 public.<=(public.cube,public.cube) ,
    OPERATOR 3 public.=(public.cube,public.cube) ,
    OPERATOR 4 public.>=(public.cube,public.cube) ,
    OPERATOR 5 public.>(public.cube,public.cube) ,
    FUNCTION 1 (public.cube, public.cube) public.cube_cmp(public.cube,public.cube);


ALTER OPERATOR CLASS public.cube_ops USING btree OWNER TO clideadmin;

--
-- Name: gist_cube_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY public.gist_cube_ops USING gist;


ALTER OPERATOR FAMILY public.gist_cube_ops USING gist OWNER TO postgres;

--
-- Name: gist_cube_ops; Type: OPERATOR CLASS; Schema: public; Owner: clideadmin
--

CREATE OPERATOR CLASS public.gist_cube_ops
    DEFAULT FOR TYPE public.cube USING gist FAMILY public.gist_cube_ops AS
    OPERATOR 3 public.&&(public.cube,public.cube) ,
    OPERATOR 6 public.=(public.cube,public.cube) ,
    OPERATOR 7 public.@>(public.cube,public.cube) ,
    OPERATOR 8 public.<@(public.cube,public.cube) ,
    OPERATOR 13 public.@(public.cube,public.cube) ,
    OPERATOR 14 public.~(public.cube,public.cube) ,
    FUNCTION 1 (public.cube, public.cube) public.g_cube_consistent(internal,public.cube,integer,oid,internal) ,
    FUNCTION 2 (public.cube, public.cube) public.g_cube_union(internal,internal) ,
    FUNCTION 3 (public.cube, public.cube) public.g_cube_compress(internal) ,
    FUNCTION 4 (public.cube, public.cube) public.g_cube_decompress(internal) ,
    FUNCTION 5 (public.cube, public.cube) public.g_cube_penalty(internal,internal,internal) ,
    FUNCTION 6 (public.cube, public.cube) public.g_cube_picksplit(internal,internal) ,
    FUNCTION 7 (public.cube, public.cube) public.g_cube_same(public.cube,public.cube,internal);


ALTER OPERATOR CLASS public.gist_cube_ops USING gist OWNER TO clideadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Abstractenvironmentalmonitoringfacility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Abstractenvironmentalmonitoringfacility" (
    "Description" character varying(50),
    "Extension" character varying(50),
    "Geospatiallocation" character varying(50),
    "Onlineresource" character varying(50),
    "Responsibleparty" character varying(50),
    "AbstractenvironmentalmonitoringfacilityID" integer NOT NULL
);


ALTER TABLE public."Abstractenvironmentalmonitoringfacility" OWNER TO postgres;

--
-- Name: TABLE "Abstractenvironmentalmonitoringfacility"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Abstractenvironmentalmonitoringfacility" IS 'An abstract class for environmental monitoring facilities. An environmental monitoring facility may be a station, a platform (moving or stationary), or it may be a sensor or an instrument. WIGOS defines two concrete specialisations: ObservingFacility (to represent stations/platforms) and Equipment (to represent sensors/instruments). NOTE: The WIGOS specialisations of AbstractEnvironmentalMonitoringFacility (ObservingFacility, Equipment) can both be mapped conceptually to the INSPIRE EF EnvironmentalMonitoringFacility.';


--
-- Name: COLUMN "Abstractenvironmentalmonitoringfacility"."Description"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Abstractenvironmentalmonitoringfacility"."Description" IS '4-05 Non-formalized information about the location and surroundings at which an observation is made and that may influence it. In WIGOS, description is used to describe an observingFacility or Equipment. ';


--
-- Name: COLUMN "Abstractenvironmentalmonitoringfacility"."Extension"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Abstractenvironmentalmonitoringfacility"."Extension" IS 'This extension point is to facilitate the encoding of any other information for complimentary or local purposes such as complying with legislative frameworks.
However it should not be expected that any extension information will be appropriately processed, stored or made retrievable from any WIGOS systems or services. ';


--
-- Name: COLUMN "Abstractenvironmentalmonitoringfacility"."Geospatiallocation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Abstractenvironmentalmonitoringfacility"."Geospatiallocation" IS '3-07 Position in space defining the location of the environmental monitoring station/platform at the time of observation.

5-12 Geospatial location of instrument/sensor';


--
-- Name: COLUMN "Abstractenvironmentalmonitoringfacility"."Onlineresource"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Abstractenvironmentalmonitoringfacility"."Onlineresource" IS 'An online resource containing additional information about the facility or equipment';


--
-- Name: COLUMN "Abstractenvironmentalmonitoringfacility"."Responsibleparty"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Abstractenvironmentalmonitoringfacility"."Responsibleparty" IS 'The organisation responsible.';


--
-- Name: Altitude-or-depth; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Altitude-or-depth" (
    "Altitude-or-depthID" integer NOT NULL
);


ALTER TABLE public."Altitude-or-depth" OWNER TO postgres;

--
-- Name: TABLE "Altitude-or-depth"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Altitude-or-depth" IS 'The value for altitudeOrDepth, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/AltitudeOrDepth.

This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Altitudeordepthtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Altitudeordepthtype" (
    "AltitudeordepthtypeID" integer NOT NULL
);


ALTER TABLE public."Altitudeordepthtype" OWNER TO postgres;

--
-- Name: TABLE "Altitudeordepthtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Altitudeordepthtype" IS 'Codelist for altitude/depth classifications';


--
-- Name: Application-area; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Application-area" (
    "Application-areaID" integer NOT NULL
);


ALTER TABLE public."Application-area" OWNER TO postgres;

--
-- Name: TABLE "Application-area"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Application-area" IS 'The value(s) for applicationArea shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ApplicationArea.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Applicationareatype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Applicationareatype" (
    "ApplicationareatypeID" integer NOT NULL
);


ALTER TABLE public."Applicationareatype" OWNER TO postgres;

--
-- Name: TABLE "Applicationareatype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Applicationareatype" IS 'Application Area codelist

note to group:
14 application areas in WMO Core Metadata profile
Also comparable list in WIGOS - to review.';


--
-- Name: Attribution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Attribution" (
    "Originator" character varying(50),
    "Originatorurl" character varying(50),
    "Source" character varying(50),
    "Title" character varying(50),
    "AttributionID" integer NOT NULL
);


ALTER TABLE public."Attribution" OWNER TO postgres;

--
-- Name: COLUMN "Attribution"."Originator"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Attribution"."Originator" IS 'Identifies the individual and/or organization at the origin of the resource. This is typically the owner of the ressource, e.g., a data set.';


--
-- Name: COLUMN "Attribution"."Title"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Attribution"."Title" IS 'The title of the attributed work.';


--
-- Name: Climate-zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Climate-zone" (
    "Climate-zoneID" integer NOT NULL
);


ALTER TABLE public."Climate-zone" OWNER TO postgres;

--
-- Name: TABLE "Climate-zone"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Climate-zone" IS 'The value for climateZone shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ClimateZone.';


--
-- Name: Climatezone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Climatezone" (
    "Climatezone" character varying(50),
    "Validperiod" character varying(50),
    "ClimatezoneID" integer NOT NULL
);


ALTER TABLE public."Climatezone" OWNER TO postgres;

--
-- Name: TABLE "Climatezone"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Climatezone" IS 'A ClimateZone is a climateZone specification accompanied by a timestamp indicating the time from which that climateZone is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility may carry multiple climateZone which are valid over different consecutive periods of time. If only a single climateZone is specified, the timestamp is optional.';


--
-- Name: COLUMN "Climatezone"."Climatezone"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Climatezone"."Climatezone" IS '4-07 type of climate zone at the facility. From the ClimateZoneType codelist.';


--
-- Name: COLUMN "Climatezone"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Climatezone"."Validperiod" IS 'The time period for which the specified climateZone is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next climateZone on record. If only one climateZone is specified for an observing facility, the time stamp is optional.';


--
-- Name: Climatezonetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Climatezonetype" (
    "ClimatezonetypeID" integer NOT NULL
);


ALTER TABLE public."Climatezonetype" OWNER TO postgres;

--
-- Name: TABLE "Climatezonetype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Climatezonetype" IS '4-07 Climate Zone ';


--
-- Name: Communication-method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Communication-method" (
    "Communication-methodID" integer NOT NULL
);


ALTER TABLE public."Communication-method" OWNER TO postgres;

--
-- Name: TABLE "Communication-method"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Communication-method" IS 'The value for communicationMethod, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/DataCommunicationMethod.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Controlchecklocationtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Controlchecklocationtype" (
    "ControlchecklocationtypeID" integer NOT NULL
);


ALTER TABLE public."Controlchecklocationtype" OWNER TO postgres;

--
-- Name: TABLE "Controlchecklocationtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Controlchecklocationtype" IS '5-08  - Types of location used in control checks';


--
-- Name: Controlcheckreport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Controlcheckreport" (
    "Alternateuri" character varying(50),
    "Checklocation" character varying(50),
    "Controlcheckresult" character varying(50),
    "Periodofvalidity" character varying(50),
    "Standardname" character varying(50),
    "Standardserialnumber" character varying(50),
    "Standardtype" character varying(50),
    "Withinverificationlimit" boolean,
    "ControlcheckreportID" integer NOT NULL
);


ALTER TABLE public."Controlcheckreport" OWNER TO postgres;

--
-- Name: TABLE "Controlcheckreport"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Controlcheckreport" IS 'A ControlCheckReport describes a calibration type event. E.g. instrument was re-calibrated.';


--
-- Name: COLUMN "Controlcheckreport"."Alternateuri"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Controlcheckreport"."Alternateuri" IS '5-08 Alternatively the summary of the control check may be provided via a URI that resolves to a document containing this information.';


--
-- Name: COLUMN "Controlcheckreport"."Checklocation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Controlcheckreport"."Checklocation" IS '5-08 Location of sensor when check was performed (e.g. in-situ, offsite etc.) From codelist ControlCheckLocationType.';


--
-- Name: COLUMN "Controlcheckreport"."Controlcheckresult"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Controlcheckreport"."Controlcheckresult" IS '5-08 Result of the control check, from InstrumentControlResultType codelist';


--
-- Name: COLUMN "Controlcheckreport"."Periodofvalidity"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Controlcheckreport"."Periodofvalidity" IS '5-08 period of validity of the control check (e.g. 4 years)';


--
-- Name: COLUMN "Controlcheckreport"."Standardname"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Controlcheckreport"."Standardname" IS '5-08 Nameof the Standard used.';


--
-- Name: COLUMN "Controlcheckreport"."Standardserialnumber"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Controlcheckreport"."Standardserialnumber" IS '5-08 Serial Number of the standard used.';


--
-- Name: COLUMN "Controlcheckreport"."Standardtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Controlcheckreport"."Standardtype" IS '5-08 Type of the Standard used. From the StandardType code list.';


--
-- Name: COLUMN "Controlcheckreport"."Withinverificationlimit"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Controlcheckreport"."Withinverificationlimit" IS '5-08 Was the instrument found to be within verification limits (True if yes, False if no)';


--
-- Name: Controlstandardtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Controlstandardtype" (
    "ControlstandardtypeID" integer NOT NULL
);


ALTER TABLE public."Controlstandardtype" OWNER TO postgres;

--
-- Name: TABLE "Controlstandardtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Controlstandardtype" IS '5-08 Codelist for types of Control Standards';


--
-- Name: Coordinatereferencesystemtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Coordinatereferencesystemtype" (
    "CoordinatereferencesystemtypeID" integer NOT NULL
);


ALTER TABLE public."Coordinatereferencesystemtype" OWNER TO postgres;

--
-- Name: Coordinatesreferencesystemtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Coordinatesreferencesystemtype" (
    "CoordinatesreferencesystemtypeID" integer NOT NULL
);


ALTER TABLE public."Coordinatesreferencesystemtype" OWNER TO postgres;

--
-- Name: TABLE "Coordinatesreferencesystemtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Coordinatesreferencesystemtype" IS 'Coordinate reference system codelist';


--
-- Name: Data-format; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Data-format" (
    "Data-formatID" integer NOT NULL
);


ALTER TABLE public."Data-format" OWNER TO postgres;

--
-- Name: TABLE "Data-format"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Data-format" IS 'The value for dataFormat, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/DataFormat.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Data-use-constraints; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Data-use-constraints" (
    "Data-use-constraintsID" integer NOT NULL
);


ALTER TABLE public."Data-use-constraints" OWNER TO postgres;

--
-- Name: TABLE "Data-use-constraints"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Data-use-constraints" IS 'The value for dataUseConstraints, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/DataPolicy.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Datacommunicationmethodtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Datacommunicationmethodtype" (
    "DatacommunicationmethodtypeID" integer NOT NULL
);


ALTER TABLE public."Datacommunicationmethodtype" OWNER TO postgres;

--
-- Name: TABLE "Datacommunicationmethodtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Datacommunicationmethodtype" IS 'Data Communication method';


--
-- Name: Dataformattype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Dataformattype" (
    "DataformattypeID" integer NOT NULL
);


ALTER TABLE public."Dataformattype" OWNER TO postgres;

--
-- Name: TABLE "Dataformattype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Dataformattype" IS 'Data format codelist';


--
-- Name: Datageneration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Datageneration" (
    "Validperiod" character varying(50),
    "DatagenerationID" integer NOT NULL,
    "DeploymentID" integer
);


ALTER TABLE public."Datageneration" OWNER TO postgres;

--
-- Name: COLUMN "Datageneration"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Datageneration"."Validperiod" IS 'The period of time for which this processing arrangement was/is in place. (Note: this time period must fall within the time period specified in the Deployment).';


--
-- Name: Datapolicy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Datapolicy" (
    "Attribution" character varying(50),
    "Datapolicy" character varying(50),
    "DatapolicyID" integer NOT NULL
);


ALTER TABLE public."Datapolicy" OWNER TO postgres;

--
-- Name: COLUMN "Datapolicy"."Attribution"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Datapolicy"."Attribution" IS 'Describes the attribution details pertinent to dataPolicy';


--
-- Name: COLUMN "Datapolicy"."Datapolicy"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Datapolicy"."Datapolicy" IS '9-02 Details relating to the use and limitations surrounding data imposed by the supervising organization.';


--
-- Name: Datapolicytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Datapolicytype" (
    "DatapolicytypeID" integer NOT NULL
);


ALTER TABLE public."Datapolicytype" OWNER TO postgres;

--
-- Name: TABLE "Datapolicytype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Datapolicytype" IS 'Data Policy / use constraints codelist';


--
-- Name: Deployment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Deployment" (
    "Applicationarea" character varying(50),
    "Communicationmethod" character varying(50),
    "Configuration" character varying(50),
    "Controlschedule" character varying(50),
    "Exposure" character varying(50),
    "Heightabovelocalreferencesurface" character varying(50),
    "Instrumentoperatingstatus" character varying(50),
    "Localreferencesurface" character varying(50),
    "Maintenanceschedule" character varying(50),
    "Representativeness" character varying(50),
    "Sourceofobservation" character varying(50),
    "Validperiod" character varying(50),
    "DeploymentID" integer NOT NULL,
    "ProcessID" integer
);


ALTER TABLE public."Deployment" OWNER TO postgres;

--
-- Name: TABLE "Deployment"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Deployment" IS 'The deployment(s) describe which equipment is deployed, during which time period, and in which configuration in the course of generating observations. A Deployment can describe any period of time (equipment could be deployed for less than a day, e.g. a mobile sensor deployed in the field, or it could be deployed for many years.) A defining characteristic of the Deployment is that the configuration described in the Deployment remains, by-and-large, unchanged for the duration of the deployment. If the configuration changes, then a new Deployment must be recorded.';


--
-- Name: COLUMN "Deployment"."Applicationarea"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Applicationarea" IS '2-01 The context within, or intended application(s) for which the observation is primarily made or which has/have the most stringent requirements.';


--
-- Name: COLUMN "Deployment"."Communicationmethod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Communicationmethod" IS '3-08 The primary data communication method, from the DataCommunicationMethodType codelist.';


--
-- Name: COLUMN "Deployment"."Configuration"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Configuration" IS '5-06 Description of any shielding or configuration/setup of the instrumentation.';


--
-- Name: COLUMN "Deployment"."Controlschedule"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Controlschedule" IS '5-07 Description of schedule for calibrations or verification of instrument.';


--
-- Name: COLUMN "Deployment"."Exposure"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Exposure" IS '5-15 The degree to which an instrument is affected by external influences according to the CIMO classification. Value from ExposureType codelist.';


--
-- Name: COLUMN "Deployment"."Heightabovelocalreferencesurface"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Heightabovelocalreferencesurface" IS '5-05 Vertical distance of sensor from specified reference surface, in the direction away from the earth''s center. Positive values indicate above reference surface, negative values indicate below references surface (e.g., below ocean surface).';


--
-- Name: COLUMN "Deployment"."Instrumentoperatingstatus"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Instrumentoperatingstatus" IS '5-04 The operational status of the instrument when deployed (Operational, testing etc.).';


--
-- Name: COLUMN "Deployment"."Localreferencesurface"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Localreferencesurface" IS '5-05 Description of the specified reference surface taken from the codelist LocalReferenceSurfaceType';


--
-- Name: COLUMN "Deployment"."Maintenanceschedule"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Maintenanceschedule" IS '5-10 A description (and schedule) of maintenance that is routinely performed on an instrument';


--
-- Name: COLUMN "Deployment"."Representativeness"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Representativeness" IS '1-05 An assessment of the representativeness of the observations from the RepresentativenessType codelist.';


--
-- Name: COLUMN "Deployment"."Sourceofobservation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Sourceofobservation" IS '5-01 The source of the observation (manual, automatic, visual etc.) from the SourceOfObservationType codelist.';


--
-- Name: COLUMN "Deployment"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Deployment"."Validperiod" IS 'The period of time for which this deployment configuration was/is in place. (Note: this time period must fall within the time period specified in the OM_Observation phenomenonTime)';


--
-- Name: Deployment-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Deployment-valid" (
    "Deployment-validID" integer NOT NULL
);


ALTER TABLE public."Deployment-valid" OWNER TO postgres;

--
-- Name: TABLE "Deployment-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Deployment-valid" IS 'XML encodings of Deployment shall conform to the XML form for Deployment specified in the WMDR XML Schema.';


--
-- Name: Description; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Description" (
    "Description" character varying(50),
    "Validperiod" character varying(50),
    "DescriptionID" integer NOT NULL
);


ALTER TABLE public."Description" OWNER TO postgres;

--
-- Name: TABLE "Description"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Description" IS 'A Description is a description accompanied by a timestamp indicating the time from which that description is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility or Equipment may carry multiple descriptions which are valid over different periods of time.';


--
-- Name: COLUMN "Description"."Description"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Description"."Description" IS '4-05 Non-formalized information about the location and surroundings at which an observation is made and that may influence it. In WIGOS, description is used to describe an observingFacility or Equipment. ';


--
-- Name: COLUMN "Description"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Description"."Validperiod" IS 'Specifies at least the begin date of the indicated description. If omitted, the dateEstablished of the facility or deployedEquipment.validPeriod will be assumed.';


--
-- Name: Equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Equipment" (
    "Driftperunittime" character varying(50),
    "Firmwareversion" character varying(50),
    "Manufacturer" character varying(50),
    "Model" character varying(50),
    "Observablerange" character varying(50),
    "Observingmethod" character varying(50),
    "Observingmethoddetails" character varying(50),
    "Serialnumber" character varying(50),
    "Specificationlink" character varying(50),
    "Specifiedabsoluteuncertainty" character varying(50),
    "Specifiedrelativeuncertainty" character varying(50),
    "Subequipment" character varying(50),
    "Uncertaintyevalproc" character varying(50),
    "EquipmentID" integer NOT NULL,
    "DeploymentID" integer,
    facility integer
);


ALTER TABLE public."Equipment" OWNER TO postgres;

--
-- Name: TABLE "Equipment"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Equipment" IS 'Equipment or instrument used to make observations.';


--
-- Name: COLUMN "Equipment"."Driftperunittime"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Driftperunittime" IS '5-03 Intrinsic capability of the measurement/observing method - drift per unit time. Typically a percentage per unit time but could be absolute e.g. 1 deg per year.';


--
-- Name: COLUMN "Equipment"."Firmwareversion"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Firmwareversion" IS '5-09 Firmware version of the equipment';


--
-- Name: COLUMN "Equipment"."Manufacturer"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Manufacturer" IS '5-09 Manufacturer of the equipment';


--
-- Name: COLUMN "Equipment"."Model"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Model" IS '5-09 Model number of the equipment';


--
-- Name: COLUMN "Equipment"."Observablerange"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Observablerange" IS '5-03 Intrinsic capability of the measurement/observing method - range';


--
-- Name: COLUMN "Equipment"."Observingmethod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Observingmethod" IS '5-02 The method of measurement/observation used from the ObservingMethodType codelist.';


--
-- Name: COLUMN "Equipment"."Observingmethoddetails"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Observingmethoddetails" IS '5-02 A description of the method of measurement/observation used from the ObservingMethodType codelist. ';


--
-- Name: COLUMN "Equipment"."Serialnumber"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Serialnumber" IS '5-09 Serial number of the equipment ';


--
-- Name: COLUMN "Equipment"."Specificationlink"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Specificationlink" IS '5-03 Link to manufacturers (or other) specification describing the equipment.';


--
-- Name: COLUMN "Equipment"."Specifiedabsoluteuncertainty"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Specifiedabsoluteuncertainty" IS '5-03 Intrinsic capability of the measurement/observing method - specified absolute uncertainty e.g. 0.2 deg C (k=2).';


--
-- Name: COLUMN "Equipment"."Specifiedrelativeuncertainty"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Equipment"."Specifiedrelativeuncertainty" IS '5-03 Intrinsic capability of the measurement/observing method - specified relative uncertainty. Typically a percentage.';


--
-- Name: Equipment-log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Equipment-log" (
    "Equipment-log" character varying(50),
    "Equipment-logID" integer NOT NULL
);


ALTER TABLE public."Equipment-log" OWNER TO postgres;

--
-- Name: Equipment-log-entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Equipment-log-entries" (
    "Equipment-log-entriesID" integer NOT NULL
);


ALTER TABLE public."Equipment-log-entries" OWNER TO postgres;

--
-- Name: TABLE "Equipment-log-entries"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Equipment-log-entries" IS 'Log entries in a EquipmentLog shall describe control checks or maintenance of the Equipment and shall conform to the XML forms for ControlCheckReport or MaintenanceReport in the WMDR XML Schema.';


--
-- Name: Equipment-log-entries-control-location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Equipment-log-entries-control-location" (
    "Equipment-log-entries-control-locationID" integer NOT NULL
);


ALTER TABLE public."Equipment-log-entries-control-location" OWNER TO postgres;

--
-- Name: TABLE "Equipment-log-entries-control-location"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Equipment-log-entries-control-location" IS 'Where a log entry is a ControlCheckReport, the value of checkLocation shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ControlLocation. ';


--
-- Name: Equipment-log-entries-control-result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Equipment-log-entries-control-result" (
    "Equipment-log-entries-control-resultID" integer NOT NULL
);


ALTER TABLE public."Equipment-log-entries-control-result" OWNER TO postgres;

--
-- Name: TABLE "Equipment-log-entries-control-result"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Equipment-log-entries-control-result" IS 'http://def.wmo.int/wmdr/2017/req/equipment/equipment-log-entries-control-result
Where a log entry is a ControlCheckReport, the value of controlCheckResult shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ControlResult. ';


--
-- Name: Equipment-log-entries-control-standard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Equipment-log-entries-control-standard" (
    "Equipment-log-entries-control-standardID" integer NOT NULL
);


ALTER TABLE public."Equipment-log-entries-control-standard" OWNER TO postgres;

--
-- Name: TABLE "Equipment-log-entries-control-standard"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Equipment-log-entries-control-standard" IS 'Where a log entry is a ControlCheckReport, the value of standardType shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ControlStandardType. ';


--
-- Name: Equipment-log-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Equipment-log-valid" (
    "Equipment-log-validID" integer NOT NULL
);


ALTER TABLE public."Equipment-log-valid" OWNER TO postgres;

--
-- Name: TABLE "Equipment-log-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Equipment-log-valid" IS 'XML encodings of EquipmentLog shall conform to the XML form for EquipmentLog specified in the WMDR XML Schema.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Equipment-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Equipment-valid" (
    "Equipment-validID" integer NOT NULL
);


ALTER TABLE public."Equipment-valid" OWNER TO postgres;

--
-- Name: TABLE "Equipment-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Equipment-valid" IS 'XML encodings of Equipment shall conform to the XML form for Equipment specified in the WMDR XML Schema.';


--
-- Name: EquipmentEquipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."EquipmentEquipment" (
    "subEquipment" integer,
    "EquipmentID" integer
);


ALTER TABLE public."EquipmentEquipment" OWNER TO postgres;

--
-- Name: Equipmentlog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Equipmentlog" (
    "EquipmentlogID" integer NOT NULL,
    equipment integer
);


ALTER TABLE public."Equipmentlog" OWNER TO postgres;

--
-- Name: TABLE "Equipmentlog"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Equipmentlog" IS '5-13 The EquipmentLog is used to capture notable events and extra information about the equipment used to obtain the observations, such as actual maintenance performed on the instrument.';


--
-- Name: Eventreport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Eventreport" (
    "Typeofevent" character varying(50),
    "Validperiod" character varying(50),
    "EventreportID" integer NOT NULL
);


ALTER TABLE public."Eventreport" OWNER TO postgres;

--
-- Name: COLUMN "Eventreport"."Typeofevent"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Eventreport"."Typeofevent" IS 'The type of event, taken from the EventType codelist (e.g. tree removal, storm damage etc).';


--
-- Name: Eventtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Eventtype" (
    "EventtypeID" integer NOT NULL
);


ALTER TABLE public."Eventtype" OWNER TO postgres;

--
-- Name: TABLE "Eventtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Eventtype" IS 'Codelist for events at station/platform';


--
-- Name: Exposure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Exposure" (
    "ExposureID" integer NOT NULL
);


ALTER TABLE public."Exposure" OWNER TO postgres;

--
-- Name: TABLE "Exposure"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Exposure" IS 'The value for exposure, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/Exposure.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Exposuretype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Exposuretype" (
    "ExposuretypeID" integer NOT NULL
);


ALTER TABLE public."Exposuretype" OWNER TO postgres;

--
-- Name: TABLE "Exposuretype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Exposuretype" IS 'Codelist for exposure of instrument';


--
-- Name: Facility-log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Facility-log" (
    "Facility-log" character varying(50),
    "Facility-logID" integer NOT NULL
);


ALTER TABLE public."Facility-log" OWNER TO postgres;

--
-- Name: Facility-log-entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Facility-log-entries" (
    "Facility-log-entriesID" integer NOT NULL
);


ALTER TABLE public."Facility-log-entries" OWNER TO postgres;

--
-- Name: TABLE "Facility-log-entries"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Facility-log-entries" IS 'Log entries in a FacilityLog shall describe events at the facility and shall conform to the XML form for EventReport in the WMDR XML Schema. ';


--
-- Name: Facility-log-entries-event-type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Facility-log-entries-event-type" (
    "Facility-log-entries-event-typeID" integer NOT NULL
);


ALTER TABLE public."Facility-log-entries-event-type" OWNER TO postgres;

--
-- Name: TABLE "Facility-log-entries-event-type"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Facility-log-entries-event-type" IS 'The value for typeOfEvent in a EventReport shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/EventAtFacility.';


--
-- Name: Facility-log-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Facility-log-valid" (
    "Facility-log-validID" integer NOT NULL
);


ALTER TABLE public."Facility-log-valid" OWNER TO postgres;

--
-- Name: TABLE "Facility-log-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Facility-log-valid" IS 'XML encodings of FacilityLog shall conform to the XML form for FacilityLog specified in the WMDR XML Schema.';


--
-- Name: Facility-type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Facility-type" (
    "Facility-typeID" integer NOT NULL
);


ALTER TABLE public."Facility-type" OWNER TO postgres;

--
-- Name: TABLE "Facility-type"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Facility-type" IS 'The value for facilityType, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/FacilityType.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Facility-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Facility-valid" (
    "Facility-validID" integer NOT NULL
);


ALTER TABLE public."Facility-valid" OWNER TO postgres;

--
-- Name: TABLE "Facility-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Facility-valid" IS 'XML encodings of ObservingFacility shall conform to the XML form for ObservingFacility specified in the WMDR XML Schema.';


--
-- Name: FacilitySetObservingFacility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."FacilitySetObservingFacility" (
    facility integer,
    "facilitySet" integer
);


ALTER TABLE public."FacilitySetObservingFacility" OWNER TO postgres;

--
-- Name: Facilitylog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Facilitylog" (
    "FacilitylogID" integer NOT NULL,
    facility integer
);


ALTER TABLE public."Facilitylog" OWNER TO postgres;

--
-- Name: TABLE "Facilitylog"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Facilitylog" IS '4-04 The FacilityLog is used to capture notable events and extra information about the observing facility or its surroundings. ';


--
-- Name: Facilityset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Facilityset" (
    "FacilitysetID" integer NOT NULL
);


ALTER TABLE public."Facilityset" OWNER TO postgres;

--
-- Name: TABLE "Facilityset"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Facilityset" IS 'A set of associated ObservingFacilities. Association (grouping) criteria can vary and maybe program/network specific. Examples: In GAW, some Global stations consist of several distinct observing facilities; The NASA A-Train may be considered a FacilitySet comprised of several individual satellites.';


--
-- Name: Frequencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Frequencies" (
    "Bandwidth" character varying(50),
    "Channel" character varying(50),
    "Frequency" character varying(50),
    "Frequencyuse" character varying(50),
    "Polarization" character varying(50),
    "Purposeoffrequencyuse" character varying(50),
    "Transmissionmode" character varying(50),
    "FrequenciesID" integer NOT NULL,
    "EquipmentID" integer
);


ALTER TABLE public."Frequencies" OWNER TO postgres;

--
-- Name: COLUMN "Frequencies"."Bandwidth"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Frequencies"."Bandwidth" IS 'The difference of the highest and the lowest frequency, expressed as a number with a unit of measure (uom). Expected values for gml attribute uom are: Hz, kHz, MHz, GHz, THz';


--
-- Name: COLUMN "Frequencies"."Channel"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Frequencies"."Channel" IS 'A name describing the frequency used';


--
-- Name: COLUMN "Frequencies"."Frequency"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Frequencies"."Frequency" IS 'The nominal frequency used, expressed as a number with a unit of measure (uom). Expected values for gml attribute uom are: Hz, kHz, MHz, GHz, THz';


--
-- Name: COLUMN "Frequencies"."Frequencyuse"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Frequencies"."Frequencyuse" IS 'expected values are: Transmit, Receive, TransmitReceive';


--
-- Name: COLUMN "Frequencies"."Purposeoffrequencyuse"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Frequencies"."Purposeoffrequencyuse" IS 'expected values are: observation, telecomms';


--
-- Name: COLUMN "Frequencies"."Transmissionmode"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Frequencies"."Transmissionmode" IS 'expected values are: pulsed, continuous
use conditional on frequencyUse = Transmit';


--
-- Name: Frequencyusetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Frequencyusetype" (
    "FrequencyusetypeID" integer NOT NULL
);


ALTER TABLE public."Frequencyusetype" OWNER TO postgres;

--
-- Name: TABLE "Frequencyusetype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Frequencyusetype" IS '5-03 Instrument specifications. This is a proxy for several more specific elements, her used for FeatureType "Frequencies". Frequency use type (transmit, receive, telecoms)';


--
-- Name: Geopositioning-method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Geopositioning-method" (
    "Geopositioning-methodID" integer NOT NULL
);


ALTER TABLE public."Geopositioning-method" OWNER TO postgres;

--
-- Name: TABLE "Geopositioning-method"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Geopositioning-method" IS 'The value for geopositioningMethod, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/GeopoistioningMethod.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Geopositioningmethodtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Geopositioningmethodtype" (
    "GeopositioningmethodtypeID" integer NOT NULL
);


ALTER TABLE public."Geopositioningmethodtype" OWNER TO postgres;

--
-- Name: TABLE "Geopositioningmethodtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Geopositioningmethodtype" IS 'Geopositiong Method / Coordinate Source codelist';


--
-- Name: Geospatiallocation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Geospatiallocation" (
    "Coordinatereferencesystem" character varying(50),
    "Geolocation" character varying(50),
    "Geopositioningmethod" character varying(50),
    "Validperiod" character varying(50),
    "GeospatiallocationID" integer NOT NULL
);


ALTER TABLE public."Geospatiallocation" OWNER TO postgres;

--
-- Name: TABLE "Geospatiallocation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Geospatiallocation" IS 'A GeospatialLocation is a geospatial location accompanied by a timestamp indicating the time from which that location is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility or Equipment may carry multiple locations which are valid over different periods of time.';


--
-- Name: COLUMN "Geospatiallocation"."Geolocation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Geospatiallocation"."Geolocation" IS '3-07 Representative or conventional geospatial location of observing facility, the reference location. This will always be a point location, but this location can change with time.

5-12 Geospatial location of instrument or observing equipment, typically the location of the sensing element or sample inlet. This will always be a point location, but this location can change with time. ';


--
-- Name: COLUMN "Geospatiallocation"."Geopositioningmethod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Geospatiallocation"."Geopositioningmethod" IS 'Element describes the method used to establish the specified geoLocation. [Codelist 11-01]';


--
-- Name: COLUMN "Geospatiallocation"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Geospatiallocation"."Validperiod" IS 'The time period for which this geoLocation is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next geoLocation on record.';


--
-- Name: Header; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Header" (
    "Filedatetime" timestamp without time zone,
    "Recordowner" character varying(50),
    "Version" integer,
    "HeaderID" integer NOT NULL
);


ALTER TABLE public."Header" OWNER TO postgres;

--
-- Name: TABLE "Header"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Header" IS 'Header contains header information about a WIGOSMetadataRecord. This is metadata about the record used to facilitate transport or ingestion into a system such as OSCAR.';


--
-- Name: COLUMN "Header"."Filedatetime"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Header"."Filedatetime" IS 'Date and time this file was last updated.';


--
-- Name: COLUMN "Header"."Recordowner"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Header"."Recordowner" IS 'The organisation responsible for the metadata.';


--
-- Name: Instrument-operating-status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Instrument-operating-status" (
    "Instrument-operating-statusID" integer NOT NULL
);


ALTER TABLE public."Instrument-operating-status" OWNER TO postgres;

--
-- Name: TABLE "Instrument-operating-status"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Instrument-operating-status" IS 'The value for instrumentOperatingStatus shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/InstrumentOperatingStatus.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Instrumentcontrolresulttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Instrumentcontrolresulttype" (
    "InstrumentcontrolresulttypeID" integer NOT NULL
);


ALTER TABLE public."Instrumentcontrolresulttype" OWNER TO postgres;

--
-- Name: TABLE "Instrumentcontrolresulttype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Instrumentcontrolresulttype" IS 'Result of an instrument control check';


--
-- Name: Instrumentcontrolscheduletype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Instrumentcontrolscheduletype" (
    "InstrumentcontrolscheduletypeID" integer NOT NULL
);


ALTER TABLE public."Instrumentcontrolscheduletype" OWNER TO postgres;

--
-- Name: TABLE "Instrumentcontrolscheduletype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Instrumentcontrolscheduletype" IS '5-07 Instrument control schedule';


--
-- Name: Instrumentoperatingstatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Instrumentoperatingstatus" (
    "Instrumentoperatingstatus" character varying(50),
    "Validperiod" character varying(50),
    "InstrumentoperatingstatusID" integer NOT NULL
);


ALTER TABLE public."Instrumentoperatingstatus" OWNER TO postgres;

--
-- Name: COLUMN "Instrumentoperatingstatus"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Instrumentoperatingstatus"."Validperiod" IS 'The time period for which the specified instrumentOperatingStatus is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next instrumentOperatingStatus on record. If only one instrumentOperatingStatus is specified for an equipment, the time stamp is optional.';


--
-- Name: Instrumentoperatingstatustype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Instrumentoperatingstatustype" (
    "InstrumentoperatingstatustypeID" integer NOT NULL
);


ALTER TABLE public."Instrumentoperatingstatustype" OWNER TO postgres;

--
-- Name: TABLE "Instrumentoperatingstatustype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Instrumentoperatingstatustype" IS '5-04 Instrument operating status';


--
-- Name: Level-of-data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Level-of-data" (
    "Level-of-dataID" integer NOT NULL
);


ALTER TABLE public."Level-of-data" OWNER TO postgres;

--
-- Name: TABLE "Level-of-data"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Level-of-data" IS 'The value for levelOfData, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/LevelOfData.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Levelofdatatype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Levelofdatatype" (
    "LevelofdatatypeID" integer NOT NULL
);


ALTER TABLE public."Levelofdatatype" OWNER TO postgres;

--
-- Name: TABLE "Levelofdatatype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Levelofdatatype" IS 'Level of data codelist';


--
-- Name: Local-topography; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Local-topography" (
    "Local-topographyID" integer NOT NULL
);


ALTER TABLE public."Local-topography" OWNER TO postgres;

--
-- Name: TABLE "Local-topography"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Local-topography" IS 'The value for localTopography, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/LocalTopography.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Localreferencesurfacetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Localreferencesurfacetype" (
    "LocalreferencesurfacetypeID" integer NOT NULL
);


ALTER TABLE public."Localreferencesurfacetype" OWNER TO postgres;

--
-- Name: TABLE "Localreferencesurfacetype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Localreferencesurfacetype" IS '5-05 Local Reference Surface type.';


--
-- Name: Localtopographytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Localtopographytype" (
    "LocaltopographytypeID" integer NOT NULL
);


ALTER TABLE public."Localtopographytype" OWNER TO postgres;

--
-- Name: TABLE "Localtopographytype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Localtopographytype" IS 'Local topography codelist (based on Speight 2009)';


--
-- Name: Log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Log" (
    "Logentry" character varying(50),
    "LogID" integer NOT NULL
);


ALTER TABLE public."Log" OWNER TO postgres;

--
-- Name: TABLE "Log"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Log" IS 'At the abstract level a log is simply a record of log entries. The requirements for a log may depend on the type of log it is therefore specialized logs exist for specific types of log (such as ControlCheckReports, MaintenanceReports and EventReports).';


--
-- Name: COLUMN "Log"."Logentry"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Log"."Logentry" IS 'An entry in a Log. ';


--
-- Name: Logentry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Logentry" (
    "Author" character varying(50),
    "Datetime" timestamp without time zone,
    "Description" character varying(50),
    "Documentationurl" character varying(50),
    "LogentryID" integer NOT NULL
);


ALTER TABLE public."Logentry" OWNER TO postgres;

--
-- Name: TABLE "Logentry"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Logentry" IS 'At the abstract level a log entry contains the time, author and descriptions of the activity or event being logged. This class is specialized further to provide more specific log entry types where needed. ';


--
-- Name: COLUMN "Logentry"."Author"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Logentry"."Author" IS 'Author of the log entry.';


--
-- Name: COLUMN "Logentry"."Datetime"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Logentry"."Datetime" IS 'Date and time of the event being logged';


--
-- Name: COLUMN "Logentry"."Description"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Logentry"."Description" IS 'Description of the log entry';


--
-- Name: COLUMN "Logentry"."Documentationurl"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Logentry"."Documentationurl" IS 'Link to additional documents, photos etc. about the event being logged.';


--
-- Name: Maintenancereport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Maintenancereport" (
    "Maintenanceparty" character varying(50),
    "MaintenancereportID" integer NOT NULL
);


ALTER TABLE public."Maintenancereport" OWNER TO postgres;

--
-- Name: TABLE "Maintenancereport"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Maintenancereport" IS '5-13 Description of maintenance (actual) performed on instrument.';


--
-- Name: COLUMN "Maintenancereport"."Maintenanceparty"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Maintenancereport"."Maintenanceparty" IS '5-11 Details of who performed the maintenance (individual or organisation).';


--
-- Name: Measurementunittype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Measurementunittype" (
    "MeasurementunittypeID" integer NOT NULL
);


ALTER TABLE public."Measurementunittype" OWNER TO postgres;

--
-- Name: TABLE "Measurementunittype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Measurementunittype" IS 'Codelist for Measurement Unit [according to common code table C-6 (WMO, 2013)]';


--
-- Name: Metadata-record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Metadata-record" (
    "Metadata-record" character varying(50),
    "Metadata-recordID" integer NOT NULL
);


ALTER TABLE public."Metadata-record" OWNER TO postgres;

--
-- Name: Observation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observation" (
    "Observation-segment" character varying(50),
    "ObservationID" integer NOT NULL
);


ALTER TABLE public."Observation" OWNER TO postgres;

--
-- Name: Observation-feature-of-interest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observation-feature-of-interest" (
    "Observation-feature-of-interestID" integer NOT NULL
);


ALTER TABLE public."Observation-feature-of-interest" OWNER TO postgres;

--
-- Name: TABLE "Observation-feature-of-interest"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observation-feature-of-interest" IS 'XML encodings of OM_Observation in WIGOS shall use O&M Spatial Sampling Features to describe the om:featureOfInterest as a feature with geometry describing the geometric location or range of the observations.';


--
-- Name: Observation-observed-property; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observation-observed-property" (
    "Observation-observed-propertyID" integer NOT NULL
);


ALTER TABLE public."Observation-observed-property" OWNER TO postgres;

--
-- Name: TABLE "Observation-observed-property"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observation-observed-property" IS 'The value for om:observedProperty (observed variable) shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ObservedVariable';


--
-- Name: Observation-process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observation-process" (
    "Observation-processID" integer NOT NULL
);


ALTER TABLE public."Observation-process" OWNER TO postgres;

--
-- Name: TABLE "Observation-process"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observation-process" IS 'XML encodings of OM_Observation in WIGOS shall use the WIGOS Process type to describe the om:procedure.';


--
-- Name: Observation-result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observation-result" (
    "Observation-resultID" integer NOT NULL
);


ALTER TABLE public."Observation-result" OWNER TO postgres;

--
-- Name: TABLE "Observation-result"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observation-result" IS 'XML encodings of OM_Observation in WIGOS shall use the WIGOS ResultSet type to describe the om:result.';


--
-- Name: Observation-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observation-valid" (
    "Observation-validID" integer NOT NULL
);


ALTER TABLE public."Observation-valid" OWNER TO postgres;

--
-- Name: TABLE "Observation-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observation-valid" IS 'XML encodings of OM_Observation shall conform to the XML form for OM_Observation specified in ISO 19156 O&M XML schema. ';


--
-- Name: Observedvariabletype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observedvariabletype" (
    "ObservedvariabletypeID" integer NOT NULL
);


ALTER TABLE public."Observedvariabletype" OWNER TO postgres;

--
-- Name: TABLE "Observedvariabletype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observedvariabletype" IS 'Observed variable - measurand';


--
-- Name: Observing-facility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observing-facility" (
    "Observing-facility" character varying(50),
    "Observing-facilityID" integer NOT NULL
);


ALTER TABLE public."Observing-facility" OWNER TO postgres;

--
-- Name: Observing-method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observing-method" (
    "Observing-methodID" integer NOT NULL
);


ALTER TABLE public."Observing-method" OWNER TO postgres;

--
-- Name: TABLE "Observing-method"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observing-method" IS 'The value(s) for observingMethod shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ObservingMethod.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Observingcapability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observingcapability" (
    "Observation" character varying(50),
    "Programaffiliation" character varying(50),
    "ObservingcapabilityID" integer NOT NULL,
    facility integer
);


ALTER TABLE public."Observingcapability" OWNER TO postgres;

--
-- Name: Observingfacility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observingfacility" (
    "Climatezone" character varying(50),
    "Dateclosed" date,
    "Dateestablished" date,
    "Facilitytype" character varying(50),
    "Population" character varying(50),
    "Programaffiliation" character varying(50),
    "Surfacecover" character varying(50),
    "Surfaceroughness" character varying(50),
    "Territory" character varying(50),
    "Timezone" character varying(50),
    "Topographybathymetry" character varying(50),
    "Wmoregion" character varying(50),
    "ObservingfacilityID" integer NOT NULL
);


ALTER TABLE public."Observingfacility" OWNER TO postgres;

--
-- Name: TABLE "Observingfacility"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observingfacility" IS '[WMDS Category 3] An observing facility (station/platform) can be anything that supports making observations, e.g., a fixed station, moving equipment or a remote sensing platform. In abstract terms, an observing facility groups a near colocation of observing equipment managed by a single entity or several entities.';


--
-- Name: COLUMN "Observingfacility"."Climatezone"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Observingfacility"."Climatezone" IS '4-07 type of climate zone at the facility. From the ClimateZoneType codelist.';


--
-- Name: COLUMN "Observingfacility"."Facilitytype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Observingfacility"."Facilitytype" IS '3-04 The type of the observing facility from the MonitoringFacilityType codelist.';


--
-- Name: COLUMN "Observingfacility"."Programaffiliation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Observingfacility"."Programaffiliation" IS '2-02 The global, regional or national programme(s)/network(s) that the ObservingFacility is associated with. programAffiliation also enables the specification of a program-specific identifier of the ObservingFacility, an alias name,  the validPeriod of the programAffiliation, as well as the reportingStatus of an ObservingFacility under the respective program.';


--
-- Name: COLUMN "Observingfacility"."Surfacecover"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Observingfacility"."Surfacecover" IS '4-01 The (bio)physical cover on the earth''s surface in the vicinity of the observations from the LandCoverType codelist . 
NOTE: Only applies for surface-based (fixed) observing facilities.';


--
-- Name: COLUMN "Observingfacility"."Surfaceroughness"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Observingfacility"."Surfaceroughness" IS '4-06 surface roughness at the facility. From the SurfaceRoughnessType codelist.';


--
-- Name: COLUMN "Observingfacility"."Territory"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Observingfacility"."Territory" IS '3-02 The territory the observing facility is located in, from the TerritoryType codelist.';


--
-- Name: COLUMN "Observingfacility"."Timezone"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Observingfacility"."Timezone" IS 'Time zone the observing facility is located in, from the timeZoneTypeType codelist.';


--
-- Name: COLUMN "Observingfacility"."Topographybathymetry"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Observingfacility"."Topographybathymetry" IS '4-03 Topography or bathymetry characterizes the shape or configuration of a geographical feature, represented on a map by contour lines. It is implemented as a timestamped composite of four elements.';


--
-- Name: COLUMN "Observingfacility"."Wmoregion"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Observingfacility"."Wmoregion" IS '3-01 The WMO region the observing facility is located in, from the WMORegionType codelist.';


--
-- Name: Observingfacilitytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observingfacilitytype" (
    "ObservingfacilitytypeID" integer NOT NULL
);


ALTER TABLE public."Observingfacilitytype" OWNER TO postgres;

--
-- Name: TABLE "Observingfacilitytype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observingfacilitytype" IS 'Codelist for classifications of Observing Facilities (Stations, Platforms)';


--
-- Name: Observingmethodtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Observingmethodtype" (
    "ObservingmethodtypeID" integer NOT NULL
);


ALTER TABLE public."Observingmethodtype" OWNER TO postgres;

--
-- Name: TABLE "Observingmethodtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Observingmethodtype" IS '5-02 Measurement/observing method type';


--
-- Name: Polarizationtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Polarizationtype" (
    "PolarizationtypeID" integer NOT NULL
);


ALTER TABLE public."Polarizationtype" OWNER TO postgres;

--
-- Name: TABLE "Polarizationtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Polarizationtype" IS '5-03 Instrument specifications. This is a proxy for several more specific elements, her used for FeatureType "Frequencies". Polarization type (LHCP, RHCP, linear, LHCD&RHCP, single, dual)';


--
-- Name: Population; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Population" (
    "Population10km" integer,
    "Population50km" integer,
    "Validperiod" character varying(50),
    "PopulationID" integer NOT NULL
);


ALTER TABLE public."Population" OWNER TO postgres;

--
-- Name: TABLE "Population"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Population" IS 'A Population is a population specification accompanied by a timestamp indicating the time from which that population is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility may carry multiple population specifications which are valid over different consecutive periods of time. If only a single population is specified, the timestamp is optional.';


--
-- Name: COLUMN "Population"."Population10km"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Population"."Population10km" IS 'Population in a 10 km radius around the observing facility, specified in 1000s.';


--
-- Name: COLUMN "Population"."Population50km"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Population"."Population50km" IS 'Population in a 50 km radius around the observing facility, specified in 1000s.';


--
-- Name: COLUMN "Population"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Population"."Validperiod" IS 'The time period for which the specified climateZone is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next climateZone on record. If only one climateZone is specified for an observing facility, the time stamp is optional.';


--
-- Name: Process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Process" (
    "Process" character varying(50),
    "ProcessID" integer NOT NULL
);


ALTER TABLE public."Process" OWNER TO postgres;

--
-- Name: TABLE "Process"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Process" IS 'Details of the process used in the observation';


--
-- Name: Process-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Process-valid" (
    "Process-validID" integer NOT NULL
);


ALTER TABLE public."Process-valid" OWNER TO postgres;

--
-- Name: TABLE "Process-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Process-valid" IS 'XML encodings of Process shall conform to the XML form for Process specified in the WMDR XML Schema.';


--
-- Name: Processing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Processing" (
    "Aggregationperiod" character varying(50),
    "Dataprocessing" character varying(50),
    "Processingcentre" character varying(50),
    "Softwaredetails" character varying(50),
    "Softwareurl" character varying(50),
    "ProcessingID" integer NOT NULL,
    "DatagenerationID" integer
);


ALTER TABLE public."Processing" OWNER TO postgres;

--
-- Name: TABLE "Processing"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Processing" IS '[WMDS Category 7] Details of the processing procedures including analysis and post-processing.';


--
-- Name: COLUMN "Processing"."Aggregationperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Processing"."Aggregationperiod" IS '7-09 Time period over which individual samples/observations are aggregated';


--
-- Name: COLUMN "Processing"."Dataprocessing"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Processing"."Dataprocessing" IS '7-01 A description of the data processing used to generate observations including, if relevant, algorithms used to derive the result.';


--
-- Name: COLUMN "Processing"."Processingcentre"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Processing"."Processingcentre" IS '7-02 Center at which the observation is processed. Although this is a free text string, it is expected that in practice this value should be from a controlled list of known centers.';


--
-- Name: COLUMN "Processing"."Softwaredetails"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Processing"."Softwaredetails" IS '7-05 Name and version of the software or processor used to derive the values';


--
-- Name: COLUMN "Processing"."Softwareurl"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Processing"."Softwareurl" IS '7-05 URL for the software or processor used to derive the values';


--
-- Name: Processing-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Processing-valid" (
    "Processing-validID" integer NOT NULL
);


ALTER TABLE public."Processing-valid" OWNER TO postgres;

--
-- Name: TABLE "Processing-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Processing-valid" IS 'XML encodings of Processing shall conform to the XML form for Processing specified in the WMDR XML Schema.';


--
-- Name: Program-affiliation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Program-affiliation" (
    "Program-affiliationID" integer NOT NULL
);


ALTER TABLE public."Program-affiliation" OWNER TO postgres;

--
-- Name: TABLE "Program-affiliation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Program-affiliation" IS 'The value(s) for programAffiliation shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ProgramAffiliation.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Programaffiliation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Programaffiliation" (
    "Programaffiliation" character varying(50),
    "Programspecificfacilityid" character varying(50),
    "Reportingstatus" character varying(50),
    "ProgramaffiliationID" integer NOT NULL
);


ALTER TABLE public."Programaffiliation" OWNER TO postgres;

--
-- Name: Programornetworkaffiliationtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Programornetworkaffiliationtype" (
    "ProgramornetworkaffiliationtypeID" integer NOT NULL
);


ALTER TABLE public."Programornetworkaffiliationtype" OWNER TO postgres;

--
-- Name: TABLE "Programornetworkaffiliationtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Programornetworkaffiliationtype" IS 'Codelist of Programme or Network Affiliations';


--
-- Name: Purposeoffrequencyusetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Purposeoffrequencyusetype" (
    "PurposeoffrequencyusetypeID" integer NOT NULL
);


ALTER TABLE public."Purposeoffrequencyusetype" OWNER TO postgres;

--
-- Name: TABLE "Purposeoffrequencyusetype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Purposeoffrequencyusetype" IS '5-03 Instrument specifications. This is a proxy for several more specific elements, here used for Type "PurposeOfFrequencyUseType". PurposeOfFrequencyUseType uses values (observation, telecomms)';


--
-- Name: Qualityflagtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Qualityflagtype" (
    "QualityflagtypeID" integer NOT NULL
);


ALTER TABLE public."Qualityflagtype" OWNER TO postgres;

--
-- Name: TABLE "Qualityflagtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Qualityflagtype" IS 'Quality Flag codelist. ';


--
-- Name: Record-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Record-valid" (
    "Record-validID" integer NOT NULL
);


ALTER TABLE public."Record-valid" OWNER TO postgres;

--
-- Name: TABLE "Record-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Record-valid" IS 'XML encodings of WIGOSMetadataRecord shall conform to the XML form for WIGOSMetadataRecord specified in the WMDR XML Schema.';


--
-- Name: Reference-time; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reference-time" (
    "Reference-timeID" integer NOT NULL
);


ALTER TABLE public."Reference-time" OWNER TO postgres;

--
-- Name: TABLE "Reference-time"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Reference-time" IS 'The value for referenceTime, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ReferenceTime.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Referencetimetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Referencetimetype" (
    "ReferencetimetypeID" integer NOT NULL
);


ALTER TABLE public."Referencetimetype" OWNER TO postgres;

--
-- Name: TABLE "Referencetimetype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Referencetimetype" IS '710 Reference time codelist';


--
-- Name: Relative-elevation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Relative-elevation" (
    "Relative-elevationID" integer NOT NULL
);


ALTER TABLE public."Relative-elevation" OWNER TO postgres;

--
-- Name: TABLE "Relative-elevation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Relative-elevation" IS 'The value for relativeElevation, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/RelativeElevation.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Relativeelevationtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Relativeelevationtype" (
    "RelativeelevationtypeID" integer NOT NULL
);


ALTER TABLE public."Relativeelevationtype" OWNER TO postgres;

--
-- Name: TABLE "Relativeelevationtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Relativeelevationtype" IS 'Relative elevation codelist';


--
-- Name: Reporting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reporting" (
    "Dataformat" character varying(50),
    "Dataformatversion" character varying(50),
    "Datapolicy" character varying(50),
    "Internationalexchange" boolean,
    "Levelofdata" character varying(50),
    "Numberofobservationsinreportinginterval" integer,
    "Numericalresolution" integer,
    "Officialstatus" boolean,
    "Referencedatum" character varying(50),
    "Referencetimesource" character varying(50),
    "Spatialreportinginterval" character varying(50),
    "Temporalreportinginterval" character varying(50),
    "Timeliness" character varying(50),
    "Timestampmeaning" character varying(50),
    "Uom" character varying(50),
    "ReportingID" integer NOT NULL,
    "DatagenerationID" integer
);


ALTER TABLE public."Reporting" OWNER TO postgres;

--
-- Name: TABLE "Reporting"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Reporting" IS '[WMDS Category 7] Details of the reporting procedures.';


--
-- Name: COLUMN "Reporting"."Dataformat"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Dataformat" IS '7-07 Description of the format in which the observed variable is primarily being provided, from the DataFormatType codelist. ';


--
-- Name: COLUMN "Reporting"."Dataformatversion"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Dataformatversion" IS '7-08 Version of the data format.';


--
-- Name: COLUMN "Reporting"."Datapolicy"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Datapolicy" IS '9-02 Details relating to the use and limitations surrounding data imposed by the supervising organization.';


--
-- Name: COLUMN "Reporting"."Levelofdata"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Levelofdata" IS '7-06 Level of data processing';


--
-- Name: COLUMN "Reporting"."Numberofobservationsinreportinginterval"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Numberofobservationsinreportinginterval" IS 'Specifies how many aggregated observations are reported on average in each temporal reporting interval. For full temporal coverage, the number of observations reported = temporal reporting interval / aggregation period.';


--
-- Name: COLUMN "Reporting"."Numericalresolution"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Numericalresolution" IS '7-12 Numerical resolution is a measure of the detail to which a numerical quantity is expressed. This is synonymous to numerical precision of the reporting, but can be different than the numerical precision of the observed value.';


--
-- Name: COLUMN "Reporting"."Officialstatus"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Officialstatus" IS '5-14 Official status of observation.';


--
-- Name: COLUMN "Reporting"."Referencedatum"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Referencedatum" IS '7-11 Reference datum used to convert observed quantity to reported quantity';


--
-- Name: COLUMN "Reporting"."Referencetimesource"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Referencetimesource" IS '7-10 Time reference used for observations.';


--
-- Name: COLUMN "Reporting"."Spatialreportinginterval"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Spatialreportinginterval" IS '7-03 Spatial interval over which the observed variable is reported. Note that this is expressed as length, without geo-referencing. ';


--
-- Name: COLUMN "Reporting"."Temporalreportinginterval"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Temporalreportinginterval" IS '7-03 Time interval over which the observed variable is reported. Note that this is a temporal distance, e.g., (every) 1 hour. ';


--
-- Name: COLUMN "Reporting"."Timeliness"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Timeliness" IS '7-13 Timeliness of reporting is the typical time taken between completion of the observation and when it becomes available to users.';


--
-- Name: COLUMN "Reporting"."Timestampmeaning"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Timestampmeaning" IS '7-03 Meaning of the time stamp in the temporalReportingInterval taken from the TimeStampMeaning codelist.';


--
-- Name: COLUMN "Reporting"."Uom"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reporting"."Uom" IS '1-02 Measurement Unit (unit of measure)';


--
-- Name: Reporting-status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reporting-status" (
    "Reporting-statusID" integer NOT NULL
);


ALTER TABLE public."Reporting-status" OWNER TO postgres;

--
-- Name: TABLE "Reporting-status"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Reporting-status" IS 'The value for reportingStatus shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/ReportingStatus.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Reporting-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reporting-valid" (
    "Reporting-validID" integer NOT NULL
);


ALTER TABLE public."Reporting-valid" OWNER TO postgres;

--
-- Name: TABLE "Reporting-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Reporting-valid" IS 'XML encodings of Reporting shall conform to the XML form for Reporting specified in the WMDR XML Schema.';


--
-- Name: Reportingstatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reportingstatus" (
    "Reportingstatus" character varying(50),
    "Validperiod" character varying(50),
    "ReportingstatusID" integer NOT NULL
);


ALTER TABLE public."Reportingstatus" OWNER TO postgres;

--
-- Name: TABLE "Reportingstatus"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Reportingstatus" IS 'A ReportingStatus is a reporting / operational status of an observing facility accompanied by a timestamp indicating the time from which that status is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility may carry multiple reporting statuses which are valid over different consecutive periods of time. If only a single reporting status is specified, the timestamp is optional and is inferred from the dateEstablished.';


--
-- Name: COLUMN "Reportingstatus"."Reportingstatus"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reportingstatus"."Reportingstatus" IS '3-09 Declared reporting status of an observing facility [under a certain network/program affiliation]. ';


--
-- Name: COLUMN "Reportingstatus"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Reportingstatus"."Validperiod" IS 'The time period for which the specified reporting status is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next territory on record. If only one reporting status is specified for an observing facility, the time stamp is optional.';


--
-- Name: Reportingstatustype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reportingstatustype" (
    "ReportingstatustypeID" integer NOT NULL
);


ALTER TABLE public."Reportingstatustype" OWNER TO postgres;

--
-- Name: TABLE "Reportingstatustype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Reportingstatustype" IS 'Station reporting status';


--
-- Name: Representativeness; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Representativeness" (
    "RepresentativenessID" integer NOT NULL
);


ALTER TABLE public."Representativeness" OWNER TO postgres;

--
-- Name: TABLE "Representativeness"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Representativeness" IS 'The value for representativeness, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/Representativeness


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Representativenesstype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Representativenesstype" (
    "RepresentativenesstypeID" integer NOT NULL
);


ALTER TABLE public."Representativenesstype" OWNER TO postgres;

--
-- Name: TABLE "Representativenesstype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Representativenesstype" IS 'Representativeness codelist.';


--
-- Name: Responsibleparty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Responsibleparty" (
    "Responsibleparty" character varying(50),
    "Validperiod" character varying(50),
    "ResponsiblepartyID" integer NOT NULL
);


ALTER TABLE public."Responsibleparty" OWNER TO postgres;

--
-- Name: TABLE "Responsibleparty"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Responsibleparty" IS 'A ResponsibleParty is an individual or organization accompanied by a timestamp indicating the time from which that responsibleParty is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility or Equipment may carry multiple responsibleParty which are valid over different periods of time.';


--
-- Name: COLUMN "Responsibleparty"."Responsibleparty"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Responsibleparty"."Responsibleparty" IS '10-01 Party (organization or individual) responsible for the observing facility or equipment.';


--
-- Name: COLUMN "Responsibleparty"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Responsibleparty"."Validperiod" IS 'The time period for which this responsibleParty is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next responsibleParty on record.';


--
-- Name: Resultset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Resultset" (
    "Distributioninfo" character varying(50),
    "ResultsetID" integer NOT NULL
);


ALTER TABLE public."Resultset" OWNER TO postgres;

--
-- Name: TABLE "Resultset"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Resultset" IS 'The ResultSet contains distribution information for the observation result(s). This may contain direct links to the data or to services or websites where the data can be sourced. Each MD_Distribution shall use CI_OnlineResource to point to URLs where data can be found. In order to distinguish the different URLs in a ResultSet. the description property of each MD_Distribution shall be used do describe what the URL resolves to (near real time data, archive etc.)';


--
-- Name: COLUMN "Resultset"."Distributioninfo"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Resultset"."Distributioninfo" IS 'The distributionInfo provides information about how to source the data, described using MD_Distribution from ISO 19115.';


--
-- Name: Sampletreatmenttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sampletreatmenttype" (
    "SampletreatmenttypeID" integer NOT NULL
);


ALTER TABLE public."Sampletreatmenttype" OWNER TO postgres;

--
-- Name: TABLE "Sampletreatmenttype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Sampletreatmenttype" IS 'Sample Treatment codelist';


--
-- Name: Sampling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sampling" (
    "Samplespertimeperiod" integer,
    "Sampletreatment" character varying(50),
    "Samplingprocedure" character varying(50),
    "Samplingproceduredescription" character varying(50),
    "Samplingstrategy" character varying(50),
    "Samplingtimeperiod" character varying(50),
    "Spatialsamplingresolution" character varying(50),
    "Spatialsamplingresolutiondetails" character varying(50),
    "Temporalsamplinginterval" character varying(50),
    "SamplingID" integer NOT NULL,
    "DatagenerationID" integer
);


ALTER TABLE public."Sampling" OWNER TO postgres;

--
-- Name: TABLE "Sampling"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Sampling" IS '6-01 Description of the procedure(s) involved in obtaining a sample/making an observation.';


--
-- Name: COLUMN "Sampling"."Sampletreatment"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Sampling"."Sampletreatment" IS '6-02 Description of chemical or physical treatment of the sample prior to analysis from the SampleTreatmentType codelist.';


--
-- Name: COLUMN "Sampling"."Samplingprocedure"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Sampling"."Samplingprocedure" IS '6-01 The procedure(s) involved in obtaining a sample/making an observation. Taken from the SamplingProcedureType codelist';


--
-- Name: COLUMN "Sampling"."Samplingproceduredescription"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Sampling"."Samplingproceduredescription" IS '6-01 Description of the procedure(s) involved in obtaining a sample/making an observation.';


--
-- Name: COLUMN "Sampling"."Samplingstrategy"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Sampling"."Samplingstrategy" IS '6-03 The strategy used to generate the observed variable.';


--
-- Name: COLUMN "Sampling"."Samplingtimeperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Sampling"."Samplingtimeperiod" IS '6-04 The period of time over which a measurement is taken. This value is a duration, e.g. 1 hour, not specific times and dates. ';


--
-- Name: COLUMN "Sampling"."Spatialsamplingresolution"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Sampling"."Spatialsamplingresolution" IS '6-05 The spatial sampling resolution is the size of the smallest observable object. The value of this property may be supported by explanatory information in spatialSamplingResolutionDescription.';


--
-- Name: COLUMN "Sampling"."Spatialsamplingresolutiondetails"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Sampling"."Spatialsamplingresolutiondetails" IS '6-05 Explanatory information about the exact meaning of the value of samplingResolution. Note: not currently supported.';


--
-- Name: COLUMN "Sampling"."Temporalsamplinginterval"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Sampling"."Temporalsamplinginterval" IS '6-06 Time period (as a duration) between the beginning of consecutive sampling periods.';


--
-- Name: Sampling-strategy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sampling-strategy" (
    "Sampling-strategyID" integer NOT NULL
);


ALTER TABLE public."Sampling-strategy" OWNER TO postgres;

--
-- Name: TABLE "Sampling-strategy"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Sampling-strategy" IS 'The value for samplingStrategy, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdsSamplingStrategy.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Sampling-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sampling-valid" (
    "Sampling-validID" integer NOT NULL
);


ALTER TABLE public."Sampling-valid" OWNER TO postgres;

--
-- Name: TABLE "Sampling-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Sampling-valid" IS 'XML encodings of Sampling shall conform to the XML form for Sampling specified in the WMDR XML Schema.';


--
-- Name: Samplingproceduretype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Samplingproceduretype" (
    "SamplingproceduretypeID" integer NOT NULL
);


ALTER TABLE public."Samplingproceduretype" OWNER TO postgres;

--
-- Name: TABLE "Samplingproceduretype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Samplingproceduretype" IS 'Sampling Procedure codelist';


--
-- Name: Samplingstrategytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Samplingstrategytype" (
    "SamplingstrategytypeID" integer NOT NULL
);


ALTER TABLE public."Samplingstrategytype" OWNER TO postgres;

--
-- Name: TABLE "Samplingstrategytype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Samplingstrategytype" IS 'Sampling Strategy codelist';


--
-- Name: Schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Schedule" (
    "Diurnalbasetime" time without time zone,
    "Endhour" integer,
    "Endminute" integer,
    "Endmonth" integer,
    "Endweekday" integer,
    "Starthour" integer,
    "Startminute" integer,
    "Startmonth" integer,
    "Startweekday" integer,
    "ScheduleID" integer NOT NULL,
    "DatagenerationID" integer
);


ALTER TABLE public."Schedule" OWNER TO postgres;

--
-- Name: TABLE "Schedule"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Schedule" IS '6-08 Description of the schedule of observation. Note: Schedules are defined in terms of months covered, weekdays covered, hours and minutes covered during each day. A complete definition of a schedule requires specification of the temporalReportingInterval, and may require the specification of diurnalBaseTime.';


--
-- Name: COLUMN "Schedule"."Endhour"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Schedule"."Endhour" IS 'End hour of schedule (0 to 23)';


--
-- Name: COLUMN "Schedule"."Endminute"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Schedule"."Endminute" IS 'End minute of schedule (0 to 59)';


--
-- Name: COLUMN "Schedule"."Endmonth"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Schedule"."Endmonth" IS 'End month of schedule (January = 1, December = 12)';


--
-- Name: COLUMN "Schedule"."Endweekday"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Schedule"."Endweekday" IS 'End day of schedule (Monday = 1, Sunday = 7)';


--
-- Name: COLUMN "Schedule"."Starthour"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Schedule"."Starthour" IS 'Start hour of schedule (0 to 23)';


--
-- Name: COLUMN "Schedule"."Startminute"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Schedule"."Startminute" IS 'Start minute of schedule (0 to 59)';


--
-- Name: COLUMN "Schedule"."Startmonth"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Schedule"."Startmonth" IS 'Start month of schedule (January = 1, December = 12)';


--
-- Name: COLUMN "Schedule"."Startweekday"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Schedule"."Startweekday" IS 'Start day of schedule (Monday = 1, Sunday = 7)';


--
-- Name: Source-of-observation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Source-of-observation" (
    "Source-of-observationID" integer NOT NULL
);


ALTER TABLE public."Source-of-observation" OWNER TO postgres;

--
-- Name: TABLE "Source-of-observation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Source-of-observation" IS 'The value(s) for sourceOfObservation shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/SourceOfObservation.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Sourceofobservationtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sourceofobservationtype" (
    "SourceofobservationtypeID" integer NOT NULL
);


ALTER TABLE public."Sourceofobservationtype" OWNER TO postgres;

--
-- Name: TABLE "Sourceofobservationtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Sourceofobservationtype" IS '5-01 Source of observations in dataset (e.g. manual, automatic, visual)';


--
-- Name: Surface-cover; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Surface-cover" (
    "Surface-coverID" integer NOT NULL
);


ALTER TABLE public."Surface-cover" OWNER TO postgres;

--
-- Name: TABLE "Surface-cover"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Surface-cover" IS 'The value for surfaceCover, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/SurfaceCover.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Surface-cover-classification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Surface-cover-classification" (
    "Surface-cover-classificationID" integer NOT NULL
);


ALTER TABLE public."Surface-cover-classification" OWNER TO postgres;

--
-- Name: TABLE "Surface-cover-classification"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Surface-cover-classification" IS 'The value for surfaceCoverClassification shall be taken from one of the SurfaceCoverClassificationType codelists at http://codes.wmo.int.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Surface-roughness; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Surface-roughness" (
    "Surface-roughnessID" integer NOT NULL
);


ALTER TABLE public."Surface-roughness" OWNER TO postgres;

--
-- Name: TABLE "Surface-roughness"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Surface-roughness" IS 'The value for surfaceRoughness shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/SurfaceRoughnessDavenport.';


--
-- Name: Surfacecover; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Surfacecover" (
    "Surfacecover" character varying(50),
    "Surfacecoverclassification" character varying(50),
    "Validperiod" character varying(50),
    "SurfacecoverID" integer NOT NULL
);


ALTER TABLE public."Surfacecover" OWNER TO postgres;

--
-- Name: TABLE "Surfacecover"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Surfacecover" IS 'A SurfaceCover is a climate zone accompanied by a timestamp indicating the time from which that surface cover class is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility may carry multiple surface cover classes which are valid over different consecutive periods of time. If only a single surface cover class is specified, the timestamp is optional.';


--
-- Name: COLUMN "Surfacecover"."Surfacecover"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Surfacecover"."Surfacecover" IS '4-01 The (bio)physical cover on the earth''s surface in the vicinity of the observations from the LandCoverType codelist . 
NOTE: Only applies for surface-based (fixed) observing facilities.';


--
-- Name: COLUMN "Surfacecover"."Surfacecoverclassification"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Surfacecover"."Surfacecoverclassification" IS '4-02 Reference to a surface cover classification type from the SurfaceCoverClassificationType codelist. NOTE: only if 4-01 is specified';


--
-- Name: COLUMN "Surfacecover"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Surfacecover"."Validperiod" IS 'The time period for which the specified surfaceCover is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next surfaceCover on record. If only one surfaceCover is specified for an observing facility, the time stamp is optional.';


--
-- Name: Surfacecoverclassificationtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Surfacecoverclassificationtype" (
    "SurfacecoverclassificationtypeID" integer NOT NULL
);


ALTER TABLE public."Surfacecoverclassificationtype" OWNER TO postgres;

--
-- Name: TABLE "Surfacecoverclassificationtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Surfacecoverclassificationtype" IS 'Surface Cover Classification Type';


--
-- Name: Surfacecovertype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Surfacecovertype" (
    "SurfacecovertypeID" integer NOT NULL
);


ALTER TABLE public."Surfacecovertype" OWNER TO postgres;

--
-- Name: TABLE "Surfacecovertype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Surfacecovertype" IS 'Surface cover types';


--
-- Name: Surfaceroughness; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Surfaceroughness" (
    "Surfaceroughness" character varying(50),
    "Validperiod" character varying(50),
    "SurfaceroughnessID" integer NOT NULL
);


ALTER TABLE public."Surfaceroughness" OWNER TO postgres;

--
-- Name: TABLE "Surfaceroughness"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Surfaceroughness" IS 'A SurfaceRoughness is a specification of surfaceRoughness accompanied by a timestamp indicating the time from which that surfaceRoughness is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility may carry multiple surfaceRoughness specifications which are valid over different consecutive periods of time. If only a single surfaceRoughness is specified, the timestamp is optional.';


--
-- Name: COLUMN "Surfaceroughness"."Surfaceroughness"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Surfaceroughness"."Surfaceroughness" IS '4-06 surface roughness at the facility. From the SurfaceRoughnessType codelist.';


--
-- Name: COLUMN "Surfaceroughness"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Surfaceroughness"."Validperiod" IS 'The time period for which the specified surfaceRoughness is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next surfaceRoughness on record. If only one surfaceRoughness is specified for an observing facility, the time stamp is optional.';


--
-- Name: Surfaceroughnesstype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Surfaceroughnesstype" (
    "SurfaceroughnesstypeID" integer NOT NULL
);


ALTER TABLE public."Surfaceroughnesstype" OWNER TO postgres;

--
-- Name: TABLE "Surfaceroughnesstype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Surfaceroughnesstype" IS '4-06';


--
-- Name: Territory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Territory" (
    "Territoryname" character varying(50),
    "Validperiod" character varying(50),
    "TerritoryID" integer NOT NULL
);


ALTER TABLE public."Territory" OWNER TO postgres;

--
-- Name: TABLE "Territory"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Territory" IS 'A Territory is a territory specification accompanied by a timestamp indicating the time from which that territory is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility may carry multiple territories which are valid over different consecutive periods of time. If only a single territory is specified, the timestamp is optional.';


--
-- Name: COLUMN "Territory"."Territoryname"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Territory"."Territoryname" IS '3-02 The territory the observing facility is located in, from the TerritoryType codelist.';


--
-- Name: COLUMN "Territory"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Territory"."Validperiod" IS 'The time period for which the specified territory is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next territory on record. If only one territory is specified for an observing facility, the time stamp is optional.';


--
-- Name: Territory-name; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Territory-name" (
    "Territory-nameID" integer NOT NULL
);


ALTER TABLE public."Territory-name" OWNER TO postgres;

--
-- Name: TABLE "Territory-name"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Territory-name" IS 'The value for territoryName shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/TerritoryName.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Territorytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Territorytype" (
    "TerritorytypeID" integer NOT NULL
);


ALTER TABLE public."Territorytype" OWNER TO postgres;

--
-- Name: TABLE "Territorytype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Territorytype" IS 'WMO Territories (territory of origin of the data)';


--
-- Name: Time-encoding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Time-encoding" (
    "Time-encoding" character varying(50),
    "Time-encodingID" integer NOT NULL
);


ALTER TABLE public."Time-encoding" OWNER TO postgres;

--
-- Name: Time-stamp-meaning; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Time-stamp-meaning" (
    "Time-stamp-meaningID" integer NOT NULL
);


ALTER TABLE public."Time-stamp-meaning" OWNER TO postgres;

--
-- Name: TABLE "Time-stamp-meaning"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Time-stamp-meaning" IS 'The value for temporalReportingTimeStampMeaning, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/TimeStampMeaning.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Time-zone-explicit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Time-zone-explicit" (
    "Time-zone-explicitID" integer NOT NULL
);


ALTER TABLE public."Time-zone-explicit" OWNER TO postgres;

--
-- Name: TABLE "Time-zone-explicit"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Time-zone-explicit" IS 'All times shall be encoded using ISO 8601 time format. A time-zone designator must be supplied for all times. If the time is given as UTC then the time zone designator is ''Z'' e.g.

2016-12-25T12:00Z

For times given in a local (non UTC) time the time zone designator shall be expressed as an offset from UTC using plus or minus offsets.

For example, the following date times are all the same moment in time:

2016-12-25T10:00Z (10am, timezone is  UTC)

2016-12-25T14:00+04:00  (2pm, timezone is UTC + 4 hours)

2016-12-25T06:00-04:00   (6am, timezone is UTC -4 hours)';


--
-- Name: Timestampmeaningtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Timestampmeaningtype" (
    "TimestampmeaningtypeID" integer NOT NULL
);


ALTER TABLE public."Timestampmeaningtype" OWNER TO postgres;

--
-- Name: TABLE "Timestampmeaningtype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Timestampmeaningtype" IS 'Time stamp meaning codelist';


--
-- Name: Timezone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Timezone" (
    "Timezone" character varying(50),
    "Validperiod" character varying(50),
    "TimezoneID" integer NOT NULL
);


ALTER TABLE public."Timezone" OWNER TO postgres;

--
-- Name: TABLE "Timezone"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Timezone" IS 'A TmeZone is a timeZone specification accompanied by a timestamp indicating the time from which that timeZone is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility may carry multiple timeZone specifications which are valid over different consecutive periods of time. If only a single timeZone is specified, the timestamp is optional.';


--
-- Name: COLUMN "Timezone"."Timezone"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Timezone"."Timezone" IS 'Time zone of the observing facility';


--
-- Name: COLUMN "Timezone"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Timezone"."Validperiod" IS 'The time period for which the specified climateZone is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next climateZone on record. If only one climateZone is specified for an observing facility, the time stamp is optional.';


--
-- Name: Timezonetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Timezonetype" (
    "TimezonetypeID" integer NOT NULL
);


ALTER TABLE public."Timezonetype" OWNER TO postgres;

--
-- Name: Topographic-context; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Topographic-context" (
    "Topographic-contextID" integer NOT NULL
);


ALTER TABLE public."Topographic-context" OWNER TO postgres;

--
-- Name: TABLE "Topographic-context"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Topographic-context" IS 'The value for topographicContext, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/TopographicContext.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Topographiccontexttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Topographiccontexttype" (
    "TopographiccontexttypeID" integer NOT NULL
);


ALTER TABLE public."Topographiccontexttype" OWNER TO postgres;

--
-- Name: TABLE "Topographiccontexttype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Topographiccontexttype" IS 'Topographic Context codelist (based on Hammond 1954)';


--
-- Name: Topographybathymetry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Topographybathymetry" (
    "Altitudeordepth" character varying(50),
    "Localtopography" character varying(50),
    "Relativeelevation" character varying(50),
    "Topographiccontext" character varying(50),
    "Validperiod" character varying(50),
    "TopographybathymetryID" integer NOT NULL
);


ALTER TABLE public."Topographybathymetry" OWNER TO postgres;

--
-- Name: TABLE "Topographybathymetry"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Topographybathymetry" IS 'A TopographyBathymetry is a specification of topography / bathymetry accompanied by a timestamp indicating the time from which that topographyBathymetry specification is considered to be valid. If known, an end time may also be provided. In WIGOS, an ObservingFacility may carry multiple topographyBathymetry specifications which are valid over different consecutive periods of time. If only a single topographyBathymetry is specified, the timestamp is optional.';


--
-- Name: COLUMN "Topographybathymetry"."Altitudeordepth"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Topographybathymetry"."Altitudeordepth" IS '4-03 The altitude/depth with respect to mean sea level from the AltitudeOrDepthTypeCodelist';


--
-- Name: COLUMN "Topographybathymetry"."Localtopography"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Topographybathymetry"."Localtopography" IS '4-03 The local topography from the LocalTopographyType codelist';


--
-- Name: COLUMN "Topographybathymetry"."Relativeelevation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Topographybathymetry"."Relativeelevation" IS '4-03 The relative elevation from the RelativeElevationType codelist';


--
-- Name: COLUMN "Topographybathymetry"."Topographiccontext"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Topographybathymetry"."Topographiccontext" IS '4-03 The topographic context from the TopographicContextType codelist';


--
-- Name: COLUMN "Topographybathymetry"."Validperiod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Topographybathymetry"."Validperiod" IS 'The time period for which the specified topographyBathymetry is known to be valid. Normally, this will be specified as a "from" date, implying that the validity extends but does not include the next topographyBathymetry on record. If only one topographyBathymetry is specified for an observing facility, the time stamp is optional.';


--
-- Name: Traceabilitytype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Traceabilitytype" (
    "TraceabilitytypeID" integer NOT NULL
);


ALTER TABLE public."Traceabilitytype" OWNER TO postgres;

--
-- Name: TABLE "Traceabilitytype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Traceabilitytype" IS 'Traceability codelist';


--
-- Name: Transmissionmodetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Transmissionmodetype" (
    "TransmissionmodetypeID" integer NOT NULL
);


ALTER TABLE public."Transmissionmodetype" OWNER TO postgres;

--
-- Name: TABLE "Transmissionmodetype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Transmissionmodetype" IS '5-03 Instrument specifications. This is a proxy for several more specific elements, her used for Type "TransmissionModeType". TransmissionModeType uses values (pulsed, continuous-wave)';


--
-- Name: Uncertaintyevalproctype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Uncertaintyevalproctype" (
    "UncertaintyevalproctypeID" integer NOT NULL
);


ALTER TABLE public."Uncertaintyevalproctype" OWNER TO postgres;

--
-- Name: TABLE "Uncertaintyevalproctype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Uncertaintyevalproctype" IS 'Uncertainty evaluation procedure codelist';


--
-- Name: Unique-observed-variable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Unique-observed-variable" (
    "Unique-observed-variableID" integer NOT NULL
);


ALTER TABLE public."Unique-observed-variable" OWNER TO postgres;

--
-- Name: TABLE "Unique-observed-variable"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Unique-observed-variable" IS 'Each OM_Observation should describe the observation of a different observed variable (e.g. humidity, air temperature) from a station/facility. ';


--
-- Name: Unit-of-measure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Unit-of-measure" (
    "Unit-of-measureID" integer NOT NULL
);


ALTER TABLE public."Unit-of-measure" OWNER TO postgres;

--
-- Name: TABLE "Unit-of-measure"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Unit-of-measure" IS 'The value for uom, if supplied, shall be taken from the code table published online at http://codes.wmo.int/common/Unit.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Valid-local-references; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Valid-local-references" (
    "Valid-local-referencesID" integer NOT NULL
);


ALTER TABLE public."Valid-local-references" OWNER TO postgres;

--
-- Name: TABLE "Valid-local-references"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Valid-local-references" IS 'Where xlink:href is used to refer to a local object (using the #id notation) there must be a corresponding object with gml:id equal to "id" in the same XML document.

Where xlink:href is used to make a reference to a non-local object, e.g. using a WIGOS identifier or a link to a term in a codelist then this is not applicable.';


--
-- Name: Well-formed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Well-formed" (
    "Well-formedID" integer NOT NULL
);


ALTER TABLE public."Well-formed" OWNER TO postgres;

--
-- Name: TABLE "Well-formed"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Well-formed" IS 'XML encodings of WMDR shall be well formed XML documents (syntactically correct). A well-formed XML document conforms to the XML specification. (https://www.w3.org/TR/REC-xml/ )';


--
-- Name: Wigosmetadatarecord; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Wigosmetadatarecord" (
    "Deployment" character varying(50),
    "Equipment" character varying(50),
    "Equipmentlog" character varying(50),
    "Extension" character varying(50),
    "Facility" character varying(50),
    "Facilitylog" character varying(50),
    "Facilityset" character varying(50),
    "Headerinformation" character varying(50),
    "Observation" character varying(50),
    "WigosmetadatarecordID" integer NOT NULL
);


ALTER TABLE public."Wigosmetadatarecord" OWNER TO postgres;

--
-- Name: TABLE "Wigosmetadatarecord"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Wigosmetadatarecord" IS 'The WIGOSMetadataRecord is a container for WIGOS information for the purposes of packaging the information for delivery to, or transfer between, systems.';


--
-- Name: COLUMN "Wigosmetadatarecord"."Deployment"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Wigosmetadatarecord"."Deployment" IS 'A Deployment instance in this record. Note that Deployments may also be encoded inline with the OM_Observation (as part of the Process).';


--
-- Name: COLUMN "Wigosmetadatarecord"."Equipment"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Wigosmetadatarecord"."Equipment" IS 'An Equipment instance in this metadata record.';


--
-- Name: COLUMN "Wigosmetadatarecord"."Equipmentlog"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Wigosmetadatarecord"."Equipmentlog" IS 'An EquipmentLog instance in this metadata record. Note that an EquipmentLog may also be encoded inline with the Equipment instance.';


--
-- Name: COLUMN "Wigosmetadatarecord"."Extension"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Wigosmetadatarecord"."Extension" IS 'This extension point is to facilitate the encoding of any other information for complimentary or local purposes such as complying with legislative frameworks.
However it should not be expected that any extension information will be appropriately processed, stored or made retrievable from any WIGOS systems or services. ';


--
-- Name: COLUMN "Wigosmetadatarecord"."Facility"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Wigosmetadatarecord"."Facility" IS 'An ObservingFacility instance in this metadata record.';


--
-- Name: COLUMN "Wigosmetadatarecord"."Facilitylog"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Wigosmetadatarecord"."Facilitylog" IS 'A FacilityLog instance in this metadata record. Note that an FacilityLog may also be encoded inline with the ObservingFacility instance.';


--
-- Name: COLUMN "Wigosmetadatarecord"."Facilityset"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Wigosmetadatarecord"."Facilityset" IS 'A FacilitySet instance in this metadata record. The FacilitySet will simply consist of links to ObservingFacilities belonging to the set.';


--
-- Name: COLUMN "Wigosmetadatarecord"."Headerinformation"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."Wigosmetadatarecord"."Headerinformation" IS 'A header section must be included with every WIGOS MetadataRecord.';


--
-- Name: Wmo-region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Wmo-region" (
    "Wmo-regionID" integer NOT NULL
);


ALTER TABLE public."Wmo-region" OWNER TO postgres;

--
-- Name: TABLE "Wmo-region"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Wmo-region" IS 'The value for wmoRegion shall be taken from the code table published online at http://codes.wmo.int/common/wmdr/WMORegion.


This codelist is also described in the WIGOS Metadata Standard, Chapter VII.';


--
-- Name: Wmoregiontype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Wmoregiontype" (
    "WmoregiontypeID" integer NOT NULL
);


ALTER TABLE public."Wmoregiontype" OWNER TO postgres;

--
-- Name: TABLE "Wmoregiontype"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Wmoregiontype" IS 'WMO Regions (region of origin of data)';


--
-- Name: Xml-rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Xml-rules" (
    "Xml-rules" character varying(50),
    "Xml-rulesID" integer NOT NULL
);


ALTER TABLE public."Xml-rules" OWNER TO postgres;

--
-- Name: Xsd-valid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Xsd-valid" (
    "Xsd-validID" integer NOT NULL
);


ALTER TABLE public."Xsd-valid" OWNER TO postgres;

--
-- Name: TABLE "Xsd-valid"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Xsd-valid" IS 'XML encodings of WMDR shall validate against the WMDR XML Schema (xsd).';


--
-- Name: cdms_get_ext_views; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.cdms_get_ext_views AS
 SELECT tables.table_name
   FROM information_schema.tables
  WHERE (((tables.table_type)::text = 'VIEW'::text) AND ((tables.table_schema)::text <> ALL (ARRAY['pg_catalog'::text, 'information_schema'::text])) AND ((tables.table_name)::text ~~ 'ext_%'::text));


ALTER TABLE public.cdms_get_ext_views OWNER TO clidegui;

--
-- Name: codes_simple_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.codes_simple_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.codes_simple_id OWNER TO clidegui;

--
-- Name: SEQUENCE codes_simple_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.codes_simple_id IS 'PK sequence for codes_simple';


--
-- Name: codes_simple; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.codes_simple (
    id integer DEFAULT nextval('public.codes_simple_id'::regclass) NOT NULL,
    code_type character varying(40) NOT NULL,
    code character varying(40) NOT NULL,
    description character varying(400),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone NOT NULL
);


ALTER TABLE public.codes_simple OWNER TO clidegui;

--
-- Name: TABLE codes_simple; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.codes_simple IS 'List of codes used in CliDE';


--
-- Name: COLUMN codes_simple.code_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.codes_simple.code_type IS 'Character code type';


--
-- Name: COLUMN codes_simple.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.codes_simple.description IS 'Description of code';


--
-- Name: COLUMN codes_simple.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.codes_simple.change_user IS 'User of last change';


--
-- Name: COLUMN codes_simple.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.codes_simple.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN codes_simple.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.codes_simple.insert_datetime IS 'Timestamp of insert';


--
-- Name: datums; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.datums (
    datum_name character varying(20) NOT NULL,
    description character varying(100)
);


ALTER TABLE public.datums OWNER TO clidegui;

--
-- Name: TABLE datums; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.datums IS 'Geodetic datums';


--
-- Name: equipment_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.equipment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.equipment_id OWNER TO clidegui;

--
-- Name: SEQUENCE equipment_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.equipment_id IS 'PK sequence for equipment';


--
-- Name: equipment; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.equipment (
    id integer DEFAULT nextval('public.equipment_id'::regclass) NOT NULL,
    type character varying(50),
    comments character varying(1000),
    version character varying(50)
);


ALTER TABLE public.equipment OWNER TO clidegui;

--
-- Name: TABLE equipment; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.equipment IS 'Stores equipment master information.';


--
-- Name: COLUMN equipment.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.equipment.id IS 'Surrogate Key';


--
-- Name: COLUMN equipment.type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.equipment.type IS 'Type of equipment';


--
-- Name: COLUMN equipment.comments; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.equipment.comments IS 'Comments for equipment';


--
-- Name: COLUMN equipment.version; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.equipment.version IS 'Version of equipment';


--
-- Name: station_types_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_types_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_types_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_types_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_types_id IS 'PK sequence for station status';


--
-- Name: station_types; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_types (
    id integer DEFAULT nextval('public.station_types_id'::regclass) NOT NULL,
    station_type character varying(10) NOT NULL,
    description character varying(50)
);


ALTER TABLE public.station_types OWNER TO clidegui;

--
-- Name: TABLE station_types; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_types IS 'Stores allowed values for stations.type_id';


--
-- Name: COLUMN station_types.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_types.id IS 'Surrogate Key';


--
-- Name: COLUMN station_types.station_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_types.station_type IS 'Station type code';


--
-- Name: COLUMN station_types.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_types.description IS 'Station type description';


--
-- Name: ext_class; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_class AS
 SELECT station_types.id,
    station_types.station_type AS class,
    station_types.description
   FROM public.station_types;


ALTER TABLE public.ext_class OWNER TO clidegui;

--
-- Name: ext_equipment; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_equipment AS
 SELECT equipment.id,
    equipment.type,
    equipment.comments,
    equipment.version
   FROM public.equipment;


ALTER TABLE public.ext_equipment OWNER TO clidegui;

--
-- Name: obs_aero_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_aero_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_aero_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_aero_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_aero_id IS 'PK sequence for obs_aero';


--
-- Name: obs_aero; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_aero (
    id integer DEFAULT nextval('public.obs_aero_id'::regclass) NOT NULL,
    station_no character varying(15) NOT NULL,
    lsd timestamp without time zone NOT NULL,
    gmt timestamp without time zone,
    lct timestamp without time zone,
    data_source character(2) NOT NULL,
    insert_datetime timestamp without time zone NOT NULL,
    change_datetime timestamp without time zone,
    change_user character varying(20),
    qa_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    comments character varying(1000),
    message_type character(1),
    wind_dir numeric(4,0),
    wind_dir_qa character(2),
    wind_speed numeric(4,1),
    wind_speed_qa character(2),
    max_gust_10m numeric(4,1),
    max_gust_10m_qa character(2),
    cavok_or_skc character(1),
    visibility numeric(7,3),
    visibility_qa character(2),
    pres_wea_intensity_1 numeric(1,0),
    pres_wea_desc_1 character(2),
    pres_wea_phen_1 character varying(6),
    pres_wea_1_qa character(2),
    pres_wea_intensity_2 numeric(1,0),
    pres_wea_desc_2 character(2),
    pres_wea_phen_2 character varying(6),
    pres_wea_2_qa character(2),
    pres_wea_intensity_3 numeric(1,0),
    pres_wea_desc_3 character(2),
    pres_wea_phen_3 character varying(6),
    pres_wea_3_qa character(2),
    cloud_amt_oktas_1 numeric(2,0),
    cloud_amt_code_1 character(3),
    cloud_amt_1_qa character(2),
    cloud_type_1 character varying(2),
    cloud_type_1_qa character(2),
    cloud_height_code_1 character(3),
    cloud_height_1_qa character(2),
    cloud_amt_oktas_2 numeric(2,0),
    cloud_amt_code_2 character(3),
    cloud_amt_2_qa character(2),
    cloud_type_2 character varying(2),
    cloud_type_2_qa character(2),
    cloud_height_code_2 character(3),
    cloud_height_2_qa character(2),
    cloud_amt_oktas_3 numeric(2,0),
    cloud_amt_code_3 character(3),
    cloud_amt_3_qa character(2),
    cloud_type_3 character varying(2),
    cloud_type_3_qa character(2),
    cloud_height_code_3 character(3),
    cloud_height_3_qa character(2),
    cloud_amt_oktas_4 numeric(2,0),
    cloud_amt_code_4 character(3),
    cloud_amt_4_qa character(2),
    cloud_type_4 character varying(2),
    cloud_type_4_qa character(2),
    cloud_height_code_4 character(3),
    cloud_height_4_qa character(2),
    cloud_amt_oktas_5 numeric(2,0),
    cloud_amt_code_5 character(3),
    cloud_amt_5_qa character(2),
    cloud_type_5 character varying(2),
    cloud_type_5_qa character(2),
    cloud_height_code_5 character(3),
    cloud_height_5_qa character(2),
    cloud_amt_oktas_6 numeric(2,0),
    cloud_amt_code_6 character(3),
    cloud_amt_6_qa character(2),
    cloud_type_6 character varying(2),
    cloud_type_6_qa character(2),
    cloud_height_code_6 character(3),
    cloud_height_6_qa character(2),
    ceiling_clear_flag numeric(1,0),
    ceiling_clear_flag_qa character(2),
    air_temp numeric(4,1),
    air_temp_f numeric(4,1),
    air_temp_qa character(2),
    dew_point numeric(4,1),
    dew_point_f numeric(4,1),
    dew_point_qa character(2),
    qnh numeric(7,1),
    qnh_inches numeric(8,3),
    qnh_qa character(2),
    rec_wea_desc_1 character(2),
    rec_wea_phen_1 character varying(6),
    rec_wea_1_qa character(2),
    rec_wea_desc_2 character(2),
    rec_wea_phen_2 character varying(6),
    rec_wea_2_qa character(2),
    rec_wea_desc_3 character(2),
    rec_wea_phen_3 character varying(6),
    rec_wea_3_qa character(2),
    text_msg character varying(1024),
    error_flag numeric(1,0),
    remarks character varying(400),
    remarks_qa character(2),
    wind_speed_knots numeric(5,1),
    max_gust_10m_knots numeric(5,1),
    visibility_miles numeric(7,3)
);


ALTER TABLE public.obs_aero OWNER TO clidegui;

--
-- Name: TABLE obs_aero; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_aero IS 'METAR / SPECI Aero message observations';


--
-- Name: COLUMN obs_aero.station_no; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.station_no IS 'Local Station identifier';


--
-- Name: COLUMN obs_aero.lsd; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.lsd IS 'Local System Time (No Daylight Savings)';


--
-- Name: COLUMN obs_aero.gmt; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.gmt IS 'GMT (UTC+0)';


--
-- Name: COLUMN obs_aero.lct; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.lct IS 'Local Clock Time (With Daylight Savings)';


--
-- Name: COLUMN obs_aero.data_source; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.data_source IS 'Code for data source (Ref Table??)';


--
-- Name: COLUMN obs_aero.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.insert_datetime IS 'Date/time row is inserted';


--
-- Name: COLUMN obs_aero.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.change_datetime IS 'Date/time row is changed';


--
-- Name: COLUMN obs_aero.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.change_user IS 'User who added/changed row';


--
-- Name: COLUMN obs_aero.qa_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.qa_flag IS 'QA flag for row (Y/N)';


--
-- Name: COLUMN obs_aero.comments; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.comments IS 'User comments';


--
-- Name: COLUMN obs_aero.message_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.message_type IS 'M=METAR, S=SPECI';


--
-- Name: COLUMN obs_aero.wind_dir; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.wind_dir IS 'Degrees (0-360)';


--
-- Name: COLUMN obs_aero.wind_speed; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.wind_speed IS 'Wind Speed (M/s to 0.1)';


--
-- Name: COLUMN obs_aero.max_gust_10m; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.max_gust_10m IS 'Max Wind Speed (M/s to 0.1)';


--
-- Name: COLUMN obs_aero.cavok_or_skc; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cavok_or_skc IS 'C=CAVOK, S=SKC';


--
-- Name: COLUMN obs_aero.visibility; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.visibility IS 'Km to (0.001)';


--
-- Name: COLUMN obs_aero.pres_wea_intensity_1; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.pres_wea_intensity_1 IS '0=Light, 1=Moderate, 2=Heavy,3=In Vicinity';


--
-- Name: COLUMN obs_aero.pres_wea_desc_1; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.pres_wea_desc_1 IS 'MI,BC,PR,DR,BL,SH,TS,FZ';


--
-- Name: COLUMN obs_aero.pres_wea_phen_1; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.pres_wea_phen_1 IS 'DZ,RA,SN,SG,IC,PL,GR,GS, BR, FG, FU, VA, DU, SA, HZ, PO, SQ, FC, SS, DS (WMO 4678)';


--
-- Name: COLUMN obs_aero.pres_wea_intensity_2; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.pres_wea_intensity_2 IS '0=Light, 1=Moderate, 2=Heavy,3=In Vicinity';


--
-- Name: COLUMN obs_aero.pres_wea_desc_2; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.pres_wea_desc_2 IS 'MI,BC,PR,DR,BL,SH,TS,FZ';


--
-- Name: COLUMN obs_aero.pres_wea_phen_2; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.pres_wea_phen_2 IS 'DZ,RA,SN,SG,IC,PL,GR,GS, BR, FG, FU, VA, DU, SA, HZ, PO, SQ, FC, SS, DS (WMO 4678)';


--
-- Name: COLUMN obs_aero.pres_wea_intensity_3; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.pres_wea_intensity_3 IS '0=Light, 1=Moderate, 2=Heavy,3=In Vicinity';


--
-- Name: COLUMN obs_aero.pres_wea_desc_3; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.pres_wea_desc_3 IS 'MI,BC,PR,DR,BL,SH,TS,FZ';


--
-- Name: COLUMN obs_aero.pres_wea_phen_3; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.pres_wea_phen_3 IS 'DZ,RA,SN,SG,IC,PL,GR,GS, BR, FG, FU, VA, DU, SA, HZ, PO, SQ, FC, SS, DS (WMO 4678)';


--
-- Name: COLUMN obs_aero.cloud_amt_oktas_1; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_oktas_1 IS 'Oktas (0-9)';


--
-- Name: COLUMN obs_aero.cloud_amt_code_1; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_code_1 IS 'FEW, SCD, BKN,OVC';


--
-- Name: COLUMN obs_aero.cloud_type_1; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_type_1 IS 'ST, SC, CU, etc';


--
-- Name: COLUMN obs_aero.cloud_height_code_1; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_height_code_1 IS 'Code (WMO Code 1690)';


--
-- Name: COLUMN obs_aero.cloud_amt_oktas_2; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_oktas_2 IS 'Oktas (0-9)';


--
-- Name: COLUMN obs_aero.cloud_amt_code_2; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_code_2 IS 'FEW, SCD, BKN,OVC';


--
-- Name: COLUMN obs_aero.cloud_type_2; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_type_2 IS 'ST, SC, CU, etc';


--
-- Name: COLUMN obs_aero.cloud_height_code_2; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_height_code_2 IS 'Code (WMO Code 1690)';


--
-- Name: COLUMN obs_aero.cloud_amt_oktas_3; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_oktas_3 IS 'Oktas (0-9)';


--
-- Name: COLUMN obs_aero.cloud_amt_code_3; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_code_3 IS 'FEW, SCD, BKN,OVC';


--
-- Name: COLUMN obs_aero.cloud_type_3; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_type_3 IS 'ST, SC, CU, etc';


--
-- Name: COLUMN obs_aero.cloud_height_code_3; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_height_code_3 IS 'Code (WMO Code 1690)';


--
-- Name: COLUMN obs_aero.cloud_amt_oktas_4; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_oktas_4 IS 'Oktas (0-9)';


--
-- Name: COLUMN obs_aero.cloud_amt_code_4; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_code_4 IS 'FEW, SCD, BKN,OVC';


--
-- Name: COLUMN obs_aero.cloud_type_4; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_type_4 IS 'ST, SC, CU, etc';


--
-- Name: COLUMN obs_aero.cloud_height_code_4; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_height_code_4 IS 'Code (WMO Code 1690)';


--
-- Name: COLUMN obs_aero.cloud_amt_oktas_5; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_oktas_5 IS 'Oktas (0-9)';


--
-- Name: COLUMN obs_aero.cloud_amt_code_5; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_code_5 IS 'FEW, SCD, BKN,OVC';


--
-- Name: COLUMN obs_aero.cloud_type_5; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_type_5 IS 'ST, SC, CU, etc';


--
-- Name: COLUMN obs_aero.cloud_height_code_5; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_height_code_5 IS 'Code (WMO Code 1690)';


--
-- Name: COLUMN obs_aero.cloud_amt_oktas_6; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_oktas_6 IS 'Oktas (0-9)';


--
-- Name: COLUMN obs_aero.cloud_amt_code_6; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_amt_code_6 IS 'FEW, SCD, BKN,OVC';


--
-- Name: COLUMN obs_aero.cloud_type_6; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_type_6 IS '0-9';


--
-- Name: COLUMN obs_aero.cloud_height_code_6; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.cloud_height_code_6 IS 'Code (WMO Code 1690)';


--
-- Name: COLUMN obs_aero.ceiling_clear_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.ceiling_clear_flag IS 'Code (0,1=CLR BLW 125)';


--
-- Name: COLUMN obs_aero.air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.air_temp IS 'C to 0.1';


--
-- Name: COLUMN obs_aero.air_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.air_temp_f IS 'F to 0.1';


--
-- Name: COLUMN obs_aero.dew_point; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.dew_point IS 'C to 0.1';


--
-- Name: COLUMN obs_aero.dew_point_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.dew_point_f IS 'F to 0.1';


--
-- Name: COLUMN obs_aero.qnh; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.qnh IS 'hPa to 0.1';


--
-- Name: COLUMN obs_aero.qnh_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.qnh_inches IS 'Inches to 0.001';


--
-- Name: COLUMN obs_aero.rec_wea_desc_1; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.rec_wea_desc_1 IS 'MI,BC,PR,BL,SH,TS,FZ';


--
-- Name: COLUMN obs_aero.rec_wea_phen_1; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.rec_wea_phen_1 IS 'REFZRA, REFZDZ, RERA, RESN, REGR, REBLSN,REDS, RESS, RETS, REUP';


--
-- Name: COLUMN obs_aero.rec_wea_desc_2; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.rec_wea_desc_2 IS 'MI,BC,PR,BL,SH,TS,FZ';


--
-- Name: COLUMN obs_aero.rec_wea_phen_2; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.rec_wea_phen_2 IS 'REFZRA, REFZDZ, RERA, RESN, REGR, REBLSN,REDS, RESS, RETS, REUP';


--
-- Name: COLUMN obs_aero.rec_wea_desc_3; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.rec_wea_desc_3 IS 'MI,BC,PR,BL,SH,TS,FZ';


--
-- Name: COLUMN obs_aero.rec_wea_phen_3; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.rec_wea_phen_3 IS 'REFZRA, REFZDZ, RERA, RESN, REGR, REBLSN,REDS, RESS, RETS, REUP';


--
-- Name: COLUMN obs_aero.text_msg; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.text_msg IS 'METAR/SPECI msg';


--
-- Name: COLUMN obs_aero.error_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.error_flag IS 'Code (1=Yes, 0=No)';


--
-- Name: COLUMN obs_aero.remarks; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.remarks IS 'Additional Remarks supplied by observer. (Mainly paper docs)';


--
-- Name: COLUMN obs_aero.wind_speed_knots; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.wind_speed_knots IS 'Wind Speed in Knots';


--
-- Name: COLUMN obs_aero.max_gust_10m_knots; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aero.max_gust_10m_knots IS 'Max Gust >10M Knots';


--
-- Name: ext_obs_aero; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_aero AS
 SELECT obs_aero.id,
    obs_aero.station_no,
    obs_aero.lsd,
    obs_aero.gmt,
    obs_aero.lct,
    obs_aero.data_source,
    obs_aero.insert_datetime,
    obs_aero.change_datetime,
    obs_aero.change_user,
    obs_aero.qa_flag,
    obs_aero.comments,
    obs_aero.message_type,
    obs_aero.wind_dir,
    obs_aero.wind_dir_qa,
    obs_aero.wind_speed,
    obs_aero.wind_speed_qa,
    obs_aero.max_gust_10m,
    obs_aero.max_gust_10m_qa,
    obs_aero.cavok_or_skc,
    obs_aero.visibility,
    obs_aero.visibility_qa,
    obs_aero.pres_wea_intensity_1,
    obs_aero.pres_wea_desc_1,
    obs_aero.pres_wea_phen_1,
    obs_aero.pres_wea_1_qa,
    obs_aero.pres_wea_intensity_2,
    obs_aero.pres_wea_desc_2,
    obs_aero.pres_wea_phen_2,
    obs_aero.pres_wea_2_qa,
    obs_aero.pres_wea_intensity_3,
    obs_aero.pres_wea_desc_3,
    obs_aero.pres_wea_phen_3,
    obs_aero.pres_wea_3_qa,
    obs_aero.cloud_amt_oktas_1,
    obs_aero.cloud_amt_code_1,
    obs_aero.cloud_amt_1_qa,
    obs_aero.cloud_type_1,
    obs_aero.cloud_type_1_qa,
    obs_aero.cloud_height_code_1,
    obs_aero.cloud_height_1_qa,
    obs_aero.cloud_amt_oktas_2,
    obs_aero.cloud_amt_code_2,
    obs_aero.cloud_amt_2_qa,
    obs_aero.cloud_type_2,
    obs_aero.cloud_type_2_qa,
    obs_aero.cloud_height_code_2,
    obs_aero.cloud_height_2_qa,
    obs_aero.cloud_amt_oktas_3,
    obs_aero.cloud_amt_code_3,
    obs_aero.cloud_amt_3_qa,
    obs_aero.cloud_type_3,
    obs_aero.cloud_type_3_qa,
    obs_aero.cloud_height_code_3,
    obs_aero.cloud_height_3_qa,
    obs_aero.cloud_amt_oktas_4,
    obs_aero.cloud_amt_code_4,
    obs_aero.cloud_amt_4_qa,
    obs_aero.cloud_type_4,
    obs_aero.cloud_type_4_qa,
    obs_aero.cloud_height_code_4,
    obs_aero.cloud_height_4_qa,
    obs_aero.cloud_amt_oktas_5,
    obs_aero.cloud_amt_code_5,
    obs_aero.cloud_amt_5_qa,
    obs_aero.cloud_type_5,
    obs_aero.cloud_type_5_qa,
    obs_aero.cloud_height_code_5,
    obs_aero.cloud_height_5_qa,
    obs_aero.cloud_amt_oktas_6,
    obs_aero.cloud_amt_code_6,
    obs_aero.cloud_amt_6_qa,
    obs_aero.cloud_type_6,
    obs_aero.cloud_type_6_qa,
    obs_aero.cloud_height_code_6,
    obs_aero.cloud_height_6_qa,
    obs_aero.ceiling_clear_flag,
    obs_aero.ceiling_clear_flag_qa,
    obs_aero.air_temp,
    obs_aero.air_temp_f,
    obs_aero.air_temp_qa,
    obs_aero.dew_point,
    obs_aero.dew_point_f,
    obs_aero.dew_point_qa,
    obs_aero.qnh,
    obs_aero.qnh_inches,
    obs_aero.qnh_qa,
    obs_aero.rec_wea_desc_1,
    obs_aero.rec_wea_phen_1,
    obs_aero.rec_wea_1_qa,
    obs_aero.rec_wea_desc_2,
    obs_aero.rec_wea_phen_2,
    obs_aero.rec_wea_2_qa,
    obs_aero.rec_wea_desc_3,
    obs_aero.rec_wea_phen_3,
    obs_aero.rec_wea_3_qa,
    obs_aero.text_msg,
    obs_aero.error_flag,
    obs_aero.remarks,
    obs_aero.remarks_qa,
    obs_aero.wind_speed_knots,
    obs_aero.max_gust_10m_knots,
    obs_aero.visibility_miles
   FROM public.obs_aero
  ORDER BY obs_aero.station_no, obs_aero.lsd;


ALTER TABLE public.ext_obs_aero OWNER TO clidegui;

--
-- Name: obs_aws_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_aws_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_aws_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_aws_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_aws_id IS 'PK sequence for obs_aws';


--
-- Name: obs_aws; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_aws (
    id integer DEFAULT nextval('public.obs_aws_id'::regclass) NOT NULL,
    station_no character varying(15) NOT NULL,
    lsd timestamp without time zone NOT NULL,
    gmt timestamp without time zone,
    lct timestamp without time zone,
    insert_datetime timestamp without time zone NOT NULL,
    change_datetime timestamp without time zone,
    change_user character varying(20),
    data_source character(2),
    qa_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    measure_period smallint,
    mn_wind_dir_pt character(3),
    mn_wind_dir_deg smallint,
    mn_wind_dir_qa character(2),
    mn_wind_dir_stddev numeric(3,1),
    mn_wind_dir_stddev_qa character(2),
    mn_wind_speed numeric(7,1),
    mn_wind_speed_qa character(2),
    mn_wind_speed_stddev numeric(7,1),
    mn_wind_speed_stddev_qa character(2),
    mn_gust_speed numeric(7,1),
    mn_gust_speed_qa character(2),
    mn_gust_time character varying(8),
    mn_gust_time_qa character(2),
    mn_gust_dir_pt character(3),
    mn_gust_dir_deg smallint,
    mn_gust_dir_qa character(2),
    inst_gust_speed numeric(7,1),
    inst_gust_qa character(2),
    inst_gust_time character varying(8),
    inst_gust_time_qa character(2),
    inst_gust_dir_pt character(3),
    inst_gust_dir_deg smallint,
    inst_gust_dir_qa character(2),
    mn_temp numeric(7,1),
    mn_temp_qa character(2),
    mn_temp_subaveraging numeric(7,1),
    mn_temp_subaveraging_period smallint,
    mn_temp_subaveraging_qa character(2),
    max_temp numeric(7,1),
    max_temp_time character varying(8),
    max_temp_time_qa character(2),
    max_temp_qa character(2),
    min_temp numeric(7,1),
    min_temp_qa character(2),
    min_temp_time character varying(8),
    min_temp_time_qa character(2),
    min_grass_temp numeric(7,1),
    min_grass_temp_qa character(2),
    min_grass_temp_time character varying(8),
    min_grass_temp_time_qa character(2),
    mn_humidity numeric(4,1),
    mn_humidity_qa character(2),
    max_humidity numeric(4,1),
    max_humidity_qa character(2),
    max_humidity_time character varying(8),
    max_humidity_time_qa character(2),
    min_humidity numeric(4,1),
    min_humidity_qa character(2),
    min_humidity_time character varying(8),
    min_humidity_time_qa character(2),
    mn_station_pres numeric(5,1),
    mn_station_pres_qa character(2),
    mn_sea_level_pres numeric(5,1),
    mn_sea_level_pres_qa character(2),
    max_pres numeric(5,1),
    max_pres_qa character(2),
    max_pres_time character varying(8),
    max_pres_time_qa character(2),
    min_pres numeric(5,1),
    min_pres_qa character(2),
    min_pres_time character varying(8),
    min_pres_time_qa character(2),
    tot_rain numeric(6,1),
    tot_rain_qa character(2),
    tot_rain_two numeric(6,1),
    tot_rain_two_qa character(2),
    tot_sun integer,
    tot_sun_qa character(2),
    tot_insolation numeric(7,2),
    tot_insolation_qa character(2),
    leaf_wetness smallint,
    leaf_wetness_qa character(2),
    mn_uv numeric(4,0),
    mn_uv_qa character(2),
    mn_soil_moisture_10 numeric(3,1),
    mn_soil_moisture_10_qa character(2),
    mn_soil_temp_10 numeric(5,1),
    mn_soil_temp_10_qa character(2),
    mn_soil_moisture_20 numeric(3,1),
    mn_soil_moisture_20_qa character(2),
    mn_soil_temp_20 numeric(5,1),
    mn_soil_temp_20_qa character(2),
    mn_soil_moisture_30 numeric(3,1),
    mn_soil_moisture_30_qa character(2),
    mn_soil_temp_30 numeric(5,1),
    mn_soil_temp_30_qa character(2),
    mn_soil_moisture_50 numeric(3,1),
    mn_soil_moisture_50_qa character(2),
    mn_soil_temp_50 numeric(5,1),
    mn_soil_temp_50_qa character(2),
    mn_soil_moisture_100 numeric(3,1),
    mn_soil_moisture_100_qa character(2),
    mn_soil_temp_100 numeric(5,1),
    mn_soil_temp_100_qa character(2)
);


ALTER TABLE public.obs_aws OWNER TO clidegui;

--
-- Name: TABLE obs_aws; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_aws IS 'AWS observations';


--
-- Name: COLUMN obs_aws.station_no; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.station_no IS 'Local Station identifier';


--
-- Name: COLUMN obs_aws.lsd; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.lsd IS 'Local System Time (No Daylight Savings)';


--
-- Name: COLUMN obs_aws.gmt; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.gmt IS 'GMT (UTC+0)';


--
-- Name: COLUMN obs_aws.lct; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.lct IS 'Local Clock Time (With Daylight Savings)';


--
-- Name: COLUMN obs_aws.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.insert_datetime IS 'Date/time row is inserted';


--
-- Name: COLUMN obs_aws.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.change_datetime IS 'Date/time row is changed';


--
-- Name: COLUMN obs_aws.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.change_user IS 'User who added/changed row';


--
-- Name: COLUMN obs_aws.qa_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.qa_flag IS 'QA flag for row (Y/N)';


--
-- Name: COLUMN obs_aws.measure_period; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.measure_period IS 'Average Period in minutes. "Standard" is (10 min)';


--
-- Name: COLUMN obs_aws.mn_wind_dir_pt; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_wind_dir_pt IS '(10 min) mean direction in points. ("ENE")';


--
-- Name: COLUMN obs_aws.mn_wind_dir_deg; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_wind_dir_deg IS '(10 min) mean direction in degrees. (0-360)';


--
-- Name: COLUMN obs_aws.mn_wind_dir_stddev; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_wind_dir_stddev IS '(10 min) mean dir Std Dev';


--
-- Name: COLUMN obs_aws.mn_wind_speed; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_wind_speed IS '(10 min) mean wind speed (m/s to 0.1)';


--
-- Name: COLUMN obs_aws.mn_wind_speed_stddev; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_wind_speed_stddev IS '(10 min) mean speed Std Dev (m/s to 0.1)';


--
-- Name: COLUMN obs_aws.mn_gust_speed; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_gust_speed IS '(10 min) mean gust speed (m/s to 0.1)';


--
-- Name: COLUMN obs_aws.mn_gust_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_gust_time IS 'Time at end of sample period';


--
-- Name: COLUMN obs_aws.mn_gust_dir_pt; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_gust_dir_pt IS 'Mean Direction of maximum wind speed. ("ENE")';


--
-- Name: COLUMN obs_aws.mn_gust_dir_deg; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_gust_dir_deg IS 'Mean Direction of maximum wind speed. (0-360)';


--
-- Name: COLUMN obs_aws.inst_gust_speed; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.inst_gust_speed IS 'Instantaneous gust speed (m/s to 0.1)';


--
-- Name: COLUMN obs_aws.inst_gust_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.inst_gust_time IS 'Time of instantaneous gust speed (09:30)';


--
-- Name: COLUMN obs_aws.inst_gust_dir_pt; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.inst_gust_dir_pt IS 'Direction of instantaneous gust speed. ("ENE")';


--
-- Name: COLUMN obs_aws.inst_gust_dir_deg; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.inst_gust_dir_deg IS 'Direction of instantaneous gust speed. (0-360)';


--
-- Name: COLUMN obs_aws.mn_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_temp IS '(10 min) mean. (C to 0.1)';


--
-- Name: COLUMN obs_aws.mn_temp_subaveraging; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_temp_subaveraging IS 'Sub-averaged temp (C to 0.1)';


--
-- Name: COLUMN obs_aws.mn_temp_subaveraging_period; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_temp_subaveraging_period IS 'Sub-averaging period (minutes)';


--
-- Name: COLUMN obs_aws.max_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.max_temp IS '(10 min) maximum. (C to 0.1)';


--
-- Name: COLUMN obs_aws.max_temp_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.max_temp_time IS 'Time of max temperature. (hh:mm:ss)';


--
-- Name: COLUMN obs_aws.min_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.min_temp IS '(10 min) minimum. (C to 0.1)';


--
-- Name: COLUMN obs_aws.min_temp_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.min_temp_time IS 'Time of min temperature.  (hh:mm:ss)';


--
-- Name: COLUMN obs_aws.min_grass_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.min_grass_temp IS '(10 min) minimum grass temp. (C to 0.1)';


--
-- Name: COLUMN obs_aws.min_grass_temp_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.min_grass_temp_time IS 'Time of min grass temp.  (hh:mm:ss)';


--
-- Name: COLUMN obs_aws.mn_humidity; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_humidity IS '(10 min)average humidity (% to 0.1)';


--
-- Name: COLUMN obs_aws.max_humidity; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.max_humidity IS '(10 min) maximum humidity (% to 0.1)';


--
-- Name: COLUMN obs_aws.max_humidity_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.max_humidity_time IS 'Time of maximum humidity.  (hh:mm:ss)';


--
-- Name: COLUMN obs_aws.min_humidity; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.min_humidity IS '(10 min) minimum humidity (% to 0.1)';


--
-- Name: COLUMN obs_aws.min_humidity_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.min_humidity_time IS 'Time of minimum humidity.  (hh:mm:ss)';


--
-- Name: COLUMN obs_aws.mn_station_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_station_pres IS 'Average station pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_aws.mn_sea_level_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_sea_level_pres IS 'Average sea level pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_aws.max_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.max_pres IS 'Maximum pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_aws.max_pres_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.max_pres_time IS 'Time of maximum pressure.  (hh:mm:ss)';


--
-- Name: COLUMN obs_aws.min_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.min_pres IS 'Minimum pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_aws.min_pres_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.min_pres_time IS 'Time of minimum pressure.  (hh:mm:ss)';


--
-- Name: COLUMN obs_aws.tot_rain; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.tot_rain IS '(10 min) total rainfall (mm to 0.1)';


--
-- Name: COLUMN obs_aws.tot_rain_two; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.tot_rain_two IS '(10 min) total rainfall instrument #2 (mm to 0.1)';


--
-- Name: COLUMN obs_aws.tot_sun; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.tot_sun IS '(10 min) total sunshine (secs, max 600)';


--
-- Name: COLUMN obs_aws.tot_insolation; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.tot_insolation IS '(10 min) insolation (Mj/m2 to 0.01)';


--
-- Name: COLUMN obs_aws.leaf_wetness; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.leaf_wetness IS '1/0 indicating leaf wetness.';


--
-- Name: COLUMN obs_aws.mn_uv; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_uv IS '(10 min) mean UV (mV)';


--
-- Name: COLUMN obs_aws.mn_soil_moisture_10; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_moisture_10 IS '(10 min) mean soil moisture at 10cm (% to 0.1)';


--
-- Name: COLUMN obs_aws.mn_soil_temp_10; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_temp_10 IS '(10 min) mean soil temperature at 10cm (C to 0.1)';


--
-- Name: COLUMN obs_aws.mn_soil_moisture_20; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_moisture_20 IS '(10 min) mean soil moisture at 20cm (% to 0.1)';


--
-- Name: COLUMN obs_aws.mn_soil_temp_20; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_temp_20 IS '(10 min) mean soil temperature at 20cm (C to 0.1)';


--
-- Name: COLUMN obs_aws.mn_soil_moisture_30; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_moisture_30 IS '(10 min) mean soil moisture at 30cm (% to 0.1)';


--
-- Name: COLUMN obs_aws.mn_soil_temp_30; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_temp_30 IS '(10 min) mean soil temperature at 30cm (C to 0.1)';


--
-- Name: COLUMN obs_aws.mn_soil_moisture_50; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_moisture_50 IS '(10 min) mean soil moisture at 50cm (% to 0.1)';


--
-- Name: COLUMN obs_aws.mn_soil_temp_50; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_temp_50 IS '(10 min) mean soil temperature at 50cm (C to 0.1)';


--
-- Name: COLUMN obs_aws.mn_soil_moisture_100; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_moisture_100 IS '(10 min) mean soil moisture at 100cm (% to 0.1)';


--
-- Name: COLUMN obs_aws.mn_soil_temp_100; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_aws.mn_soil_temp_100 IS '(10 min) mean soil temperature at 100cm (C to 0.1)';


--
-- Name: ext_obs_aws; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_aws AS
 SELECT obs_aws.id,
    obs_aws.station_no,
    obs_aws.lsd,
    obs_aws.gmt,
    obs_aws.lct,
    obs_aws.insert_datetime,
    obs_aws.change_datetime,
    obs_aws.change_user,
    obs_aws.data_source,
    obs_aws.qa_flag,
    obs_aws.measure_period,
    obs_aws.mn_wind_dir_pt,
    obs_aws.mn_wind_dir_deg,
    obs_aws.mn_wind_dir_qa,
    obs_aws.mn_wind_dir_stddev,
    obs_aws.mn_wind_dir_stddev_qa,
    obs_aws.mn_wind_speed,
    obs_aws.mn_wind_speed_qa,
    obs_aws.mn_wind_speed_stddev,
    obs_aws.mn_wind_speed_stddev_qa,
    obs_aws.mn_gust_speed,
    obs_aws.mn_gust_speed_qa,
    obs_aws.mn_gust_time,
    obs_aws.mn_gust_time_qa,
    obs_aws.mn_gust_dir_pt,
    obs_aws.mn_gust_dir_deg,
    obs_aws.mn_gust_dir_qa,
    obs_aws.inst_gust_speed,
    obs_aws.inst_gust_qa,
    obs_aws.inst_gust_time,
    obs_aws.inst_gust_time_qa,
    obs_aws.inst_gust_dir_pt,
    obs_aws.inst_gust_dir_deg,
    obs_aws.inst_gust_dir_qa,
    obs_aws.mn_temp,
    obs_aws.mn_temp_qa,
    obs_aws.mn_temp_subaveraging,
    obs_aws.mn_temp_subaveraging_period,
    obs_aws.mn_temp_subaveraging_qa,
    obs_aws.max_temp,
    obs_aws.max_temp_time,
    obs_aws.max_temp_time_qa,
    obs_aws.max_temp_qa,
    obs_aws.min_temp,
    obs_aws.min_temp_qa,
    obs_aws.min_temp_time,
    obs_aws.min_temp_time_qa,
    obs_aws.min_grass_temp,
    obs_aws.min_grass_temp_qa,
    obs_aws.min_grass_temp_time,
    obs_aws.min_grass_temp_time_qa,
    obs_aws.mn_humidity,
    obs_aws.mn_humidity_qa,
    obs_aws.max_humidity,
    obs_aws.max_humidity_qa,
    obs_aws.max_humidity_time,
    obs_aws.max_humidity_time_qa,
    obs_aws.min_humidity,
    obs_aws.min_humidity_qa,
    obs_aws.min_humidity_time,
    obs_aws.min_humidity_time_qa,
    obs_aws.mn_station_pres,
    obs_aws.mn_station_pres_qa,
    obs_aws.mn_sea_level_pres,
    obs_aws.mn_sea_level_pres_qa,
    obs_aws.max_pres,
    obs_aws.max_pres_qa,
    obs_aws.max_pres_time,
    obs_aws.max_pres_time_qa,
    obs_aws.min_pres,
    obs_aws.min_pres_qa,
    obs_aws.min_pres_time,
    obs_aws.min_pres_time_qa,
    obs_aws.tot_rain,
    obs_aws.tot_rain_qa,
    obs_aws.tot_rain_two,
    obs_aws.tot_rain_two_qa,
    obs_aws.tot_sun,
    obs_aws.tot_sun_qa,
    obs_aws.tot_insolation,
    obs_aws.tot_insolation_qa,
    obs_aws.leaf_wetness,
    obs_aws.leaf_wetness_qa,
    obs_aws.mn_uv,
    obs_aws.mn_uv_qa,
    obs_aws.mn_soil_moisture_10,
    obs_aws.mn_soil_moisture_10_qa,
    obs_aws.mn_soil_temp_10,
    obs_aws.mn_soil_temp_10_qa,
    obs_aws.mn_soil_moisture_20,
    obs_aws.mn_soil_moisture_20_qa,
    obs_aws.mn_soil_temp_20,
    obs_aws.mn_soil_temp_20_qa,
    obs_aws.mn_soil_moisture_30,
    obs_aws.mn_soil_moisture_30_qa,
    obs_aws.mn_soil_temp_30,
    obs_aws.mn_soil_temp_30_qa,
    obs_aws.mn_soil_moisture_50,
    obs_aws.mn_soil_moisture_50_qa,
    obs_aws.mn_soil_temp_50,
    obs_aws.mn_soil_temp_50_qa,
    obs_aws.mn_soil_moisture_100,
    obs_aws.mn_soil_moisture_100_qa,
    obs_aws.mn_soil_temp_100,
    obs_aws.mn_soil_temp_100_qa
   FROM public.obs_aws
  ORDER BY obs_aws.station_no, obs_aws.lsd;


ALTER TABLE public.ext_obs_aws OWNER TO clidegui;

--
-- Name: obs_daily_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_daily_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_daily_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_daily_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_daily_id IS 'PK sequence for obs_daily';


--
-- Name: obs_daily; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_daily (
    id integer DEFAULT nextval('public.obs_daily_id'::regclass) NOT NULL,
    station_no character varying(15) NOT NULL,
    lsd timestamp without time zone NOT NULL,
    data_source character(2) NOT NULL,
    insert_datetime timestamp without time zone DEFAULT now() NOT NULL,
    change_datetime timestamp without time zone,
    change_user character varying(20),
    qa_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    aws_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    comments character varying(1000),
    rain_24h numeric(6,1),
    rain_24h_inches numeric(7,3),
    rain_24h_period numeric(2,0),
    rain_24h_type character varying(10),
    rain_24h_count numeric(2,0),
    rain_24h_qa character(2),
    max_air_temp numeric(7,1),
    max_air_temp_f numeric(7,1),
    max_air_temp_period numeric(2,0),
    max_air_temp_time character varying(5),
    max_air_temp_qa character(2),
    min_air_temp numeric(5,1),
    min_air_temp_f numeric(5,1),
    min_air_temp_period numeric(2,0),
    min_air_temp_time character varying(5),
    min_air_temp_qa character(2),
    reg_max_air_temp numeric(7,1),
    reg_max_air_temp_qa character(2),
    reg_min_air_temp numeric(7,1),
    reg_min_air_temp_qa character(2),
    ground_temp numeric(5,1),
    ground_temp_f numeric(5,1),
    ground_temp_qa character(2),
    max_gust_dir numeric(3,0),
    max_gust_dir_qa character(2),
    max_gust_speed numeric(4,1),
    max_gust_speed_kts numeric(3,0),
    max_gust_speed_bft character varying(2),
    max_gust_speed_qa character(2),
    max_gust_time character varying(5),
    max_gust_time_qa character(2),
    wind_run_lt10 numeric(6,2),
    wind_run_lt10_miles numeric(6,2),
    wind_run_lt10_period numeric(3,0),
    wind_run_lt10_qa character(2),
    wind_run_gt10 numeric(6,2),
    wind_run_gt10_miles numeric(6,2),
    wind_run_gt10_period numeric(3,0),
    wind_run_gt10_qa character(2),
    evaporation numeric(4,1),
    evaporation_inches numeric(5,3),
    evaporation_period numeric(3,0),
    evaporation_qa character(2),
    evap_water_max_temp numeric(5,1),
    evap_water_max_temp_f numeric(5,1),
    evap_water_max_temp_qa character(2),
    evap_water_min_temp numeric(5,1),
    evap_water_min_temp_f numeric(5,1),
    evap_water_min_temp_qa character(2),
    sunshine_duration numeric(3,1),
    sunshine_duration_qa character(2),
    river_height numeric(5,1),
    river_height_in numeric(8,1),
    river_height_qa character(2),
    radiation numeric(6,1),
    radiation_qa character(2),
    thunder_flag character(1),
    thunder_flag_qa character(2),
    frost_flag character(1),
    frost_flag_qa character(2),
    dust_flag character(1),
    dust_flag_qa character(2),
    haze_flag character(1),
    haze_flag_qa character(2),
    fog_flag character(1),
    fog_flag_qa character(2),
    strong_wind_flag character(1),
    strong_wind_flag_qa character(2),
    gale_flag character(1),
    gale_flag_qa character(2),
    hail_flag character(1),
    hail_flag_qa character(2),
    snow_flag character(1),
    snow_flag_qa character(2),
    lightning_flag character(1),
    lightning_flag_qa character(2),
    shower_flag character(1),
    shower_flag_qa character(2),
    rain_flag character(1),
    rain_flag_qa character(2),
    dew_flag character(1),
    dew_flag_qa character(2)
);


ALTER TABLE public.obs_daily OWNER TO clidegui;

--
-- Name: TABLE obs_daily; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_daily IS 'Daily surface observations';


--
-- Name: COLUMN obs_daily.station_no; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.station_no IS 'Local Station identifier';


--
-- Name: COLUMN obs_daily.lsd; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.lsd IS 'Local System Time (No Daylight Savings)';


--
-- Name: COLUMN obs_daily.data_source; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.data_source IS 'Code for data source (DATA_SRC)';


--
-- Name: COLUMN obs_daily.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.insert_datetime IS 'Date/time row is inserted';


--
-- Name: COLUMN obs_daily.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.change_datetime IS 'Date/time row is changed';


--
-- Name: COLUMN obs_daily.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.change_user IS 'User who added/changed row';


--
-- Name: COLUMN obs_daily.qa_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.qa_flag IS 'QA flag for row (Y/N)';


--
-- Name: COLUMN obs_daily.aws_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.aws_flag IS 'AWS sourced data or not (Y/N)';


--
-- Name: COLUMN obs_daily.comments; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.comments IS 'User comments';


--
-- Name: COLUMN obs_daily.rain_24h; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.rain_24h IS 'LCT 0900 to 0900 (mm to 0.1)';


--
-- Name: COLUMN obs_daily.rain_24h_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.rain_24h_inches IS 'LCT 0900 to 0900 (inches to 0.001)';


--
-- Name: COLUMN obs_daily.rain_24h_period; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.rain_24h_period IS 'Period of data: Normally 1 day';


--
-- Name: COLUMN obs_daily.rain_24h_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.rain_24h_type IS 'rain,frost,fog,dew,trace,snow,other, n/a';


--
-- Name: COLUMN obs_daily.rain_24h_count; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.rain_24h_count IS 'No of days rain has fallen. Default 1.';


--
-- Name: COLUMN obs_daily.rain_24h_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.rain_24h_qa IS 'Quality code for rain_24h';


--
-- Name: COLUMN obs_daily.max_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_air_temp IS 'Maximum air temperature (0.1C). Standard 0900';


--
-- Name: COLUMN obs_daily.max_air_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_air_temp_f IS 'Maximum air temperature (0.1F). Standard 0900';


--
-- Name: COLUMN obs_daily.max_air_temp_period; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_air_temp_period IS 'Period for max air temp (hours). Standard 0900';


--
-- Name: COLUMN obs_daily.max_air_temp_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_air_temp_time IS 'Time that max air temp was reached. Standard 0900';


--
-- Name: COLUMN obs_daily.max_air_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_air_temp_qa IS 'Quality code for max_air_temp';


--
-- Name: COLUMN obs_daily.min_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.min_air_temp IS 'Minimum air temperature (0.1C). Standard 0900';


--
-- Name: COLUMN obs_daily.min_air_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.min_air_temp_f IS 'Minimum air temperature (0.1F). Standard 0900';


--
-- Name: COLUMN obs_daily.min_air_temp_period; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.min_air_temp_period IS 'Period for min air temp (hours). Standard 0900';


--
-- Name: COLUMN obs_daily.min_air_temp_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.min_air_temp_time IS 'Time that min air temp was reached. Standard 0900';


--
-- Name: COLUMN obs_daily.min_air_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.min_air_temp_qa IS 'Quality code for min_air_temp';


--
-- Name: COLUMN obs_daily.reg_max_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.reg_max_air_temp IS 'Maximum air temperature (0.1C). Regional.';


--
-- Name: COLUMN obs_daily.reg_max_air_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.reg_max_air_temp_qa IS 'Quality code for max_air_temp_reg';


--
-- Name: COLUMN obs_daily.reg_min_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.reg_min_air_temp IS 'Minimum air temperature (0.1C). Regional.';


--
-- Name: COLUMN obs_daily.reg_min_air_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.reg_min_air_temp_qa IS 'Quality code for min_air_temp';


--
-- Name: COLUMN obs_daily.ground_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.ground_temp IS 'Ground surface temp (0.1C)';


--
-- Name: COLUMN obs_daily.ground_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.ground_temp_f IS 'Ground surface temp (0.1F)';


--
-- Name: COLUMN obs_daily.ground_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.ground_temp_qa IS 'Quality code for ground_temp';


--
-- Name: COLUMN obs_daily.max_gust_dir; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_gust_dir IS 'Degrees (0-360)';


--
-- Name: COLUMN obs_daily.max_gust_dir_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_gust_dir_qa IS 'Quality code for max_gust_dir';


--
-- Name: COLUMN obs_daily.max_gust_speed; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_gust_speed IS 'Speed of max wind gust M/s (0.1)';


--
-- Name: COLUMN obs_daily.max_gust_speed_bft; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_gust_speed_bft IS 'Speed of max wind gust Beaufort';


--
-- Name: COLUMN obs_daily.max_gust_speed_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_gust_speed_qa IS 'Quality code for max_gust_speed';


--
-- Name: COLUMN obs_daily.max_gust_time; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_gust_time IS 'Time of max wind gust';


--
-- Name: COLUMN obs_daily.max_gust_time_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.max_gust_time_qa IS 'Quality code for max_gust_time';


--
-- Name: COLUMN obs_daily.wind_run_lt10; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.wind_run_lt10 IS 'Wind run taken from <10M (evaporation) Km';


--
-- Name: COLUMN obs_daily.wind_run_lt10_miles; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.wind_run_lt10_miles IS 'Wind run taken from <10M (evaporation) Miles';


--
-- Name: COLUMN obs_daily.wind_run_lt10_period; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.wind_run_lt10_period IS 'Period in hours for Wind run <10';


--
-- Name: COLUMN obs_daily.wind_run_lt10_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.wind_run_lt10_qa IS 'Quality code for wind_run_lt10';


--
-- Name: COLUMN obs_daily.wind_run_gt10; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.wind_run_gt10 IS 'Wind run taken from >10M anemometer Km';


--
-- Name: COLUMN obs_daily.wind_run_gt10_miles; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.wind_run_gt10_miles IS 'Wind run taken from >10M anemometer Miles';


--
-- Name: COLUMN obs_daily.wind_run_gt10_period; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.wind_run_gt10_period IS 'Period in hours for Wind run >10';


--
-- Name: COLUMN obs_daily.wind_run_gt10_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.wind_run_gt10_qa IS 'Quality code for wind_run_gt10';


--
-- Name: COLUMN obs_daily.evaporation; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evaporation IS 'Evaporation in mm (0.1)';


--
-- Name: COLUMN obs_daily.evaporation_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evaporation_inches IS 'Evaporation in inches (0.001)';


--
-- Name: COLUMN obs_daily.evaporation_period; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evaporation_period IS 'Period in hours for evaporation';


--
-- Name: COLUMN obs_daily.evaporation_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evaporation_qa IS 'Quality code for evaporation';


--
-- Name: COLUMN obs_daily.evap_water_max_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evap_water_max_temp IS 'Max water temp (0.1C)';


--
-- Name: COLUMN obs_daily.evap_water_max_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evap_water_max_temp_f IS 'Max water temp (0.1F)';


--
-- Name: COLUMN obs_daily.evap_water_max_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evap_water_max_temp_qa IS 'Quality code for evap_max_temp';


--
-- Name: COLUMN obs_daily.evap_water_min_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evap_water_min_temp IS 'Min water temp (0.1C)';


--
-- Name: COLUMN obs_daily.evap_water_min_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evap_water_min_temp_f IS 'Min water temp (0.1F)';


--
-- Name: COLUMN obs_daily.evap_water_min_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.evap_water_min_temp_qa IS 'Quality code for evap_min_temp';


--
-- Name: COLUMN obs_daily.sunshine_duration; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.sunshine_duration IS 'Decimal Hours to (0.1)';


--
-- Name: COLUMN obs_daily.sunshine_duration_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.sunshine_duration_qa IS 'Quality code for sunshine_duration';


--
-- Name: COLUMN obs_daily.river_height; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.river_height IS 'Daily river height reading (0.1M)';


--
-- Name: COLUMN obs_daily.river_height_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.river_height_qa IS 'Quality code for river_height';


--
-- Name: COLUMN obs_daily.radiation; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.radiation IS 'Daily radiation Mj/M to 0.1';


--
-- Name: COLUMN obs_daily.radiation_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.radiation_qa IS 'Quality code for radiation';


--
-- Name: COLUMN obs_daily.thunder_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.thunder_flag IS 'Y/N for thunder';


--
-- Name: COLUMN obs_daily.thunder_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.thunder_flag_qa IS 'Quality code for thunder_flag';


--
-- Name: COLUMN obs_daily.frost_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.frost_flag IS 'Y/N for frost';


--
-- Name: COLUMN obs_daily.frost_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.frost_flag_qa IS 'Quality code for frost_flag';


--
-- Name: COLUMN obs_daily.dust_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.dust_flag IS 'Y/N for dust';


--
-- Name: COLUMN obs_daily.dust_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.dust_flag_qa IS 'Quality code for dust_flag';


--
-- Name: COLUMN obs_daily.haze_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.haze_flag IS 'Y/N for haze';


--
-- Name: COLUMN obs_daily.haze_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.haze_flag_qa IS 'Quality code for haze_flag';


--
-- Name: COLUMN obs_daily.fog_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.fog_flag IS 'Y/N for fog';


--
-- Name: COLUMN obs_daily.fog_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.fog_flag_qa IS 'Quality code for fog_flag';


--
-- Name: COLUMN obs_daily.strong_wind_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.strong_wind_flag IS 'Y/N for strong wind';


--
-- Name: COLUMN obs_daily.strong_wind_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.strong_wind_flag_qa IS 'Quality code for strong_wind_flag';


--
-- Name: COLUMN obs_daily.gale_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.gale_flag IS 'Y/N for gale';


--
-- Name: COLUMN obs_daily.gale_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.gale_flag_qa IS 'Quality code for gale_flag';


--
-- Name: COLUMN obs_daily.hail_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.hail_flag IS 'Y/N for hail';


--
-- Name: COLUMN obs_daily.hail_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.hail_flag_qa IS 'Quality code for hail_flag';


--
-- Name: COLUMN obs_daily.snow_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.snow_flag IS 'Y/N for snow';


--
-- Name: COLUMN obs_daily.snow_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.snow_flag_qa IS 'Quality code for snow_flag';


--
-- Name: COLUMN obs_daily.lightning_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.lightning_flag IS 'Y/N for lightning';


--
-- Name: COLUMN obs_daily.lightning_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.lightning_flag_qa IS 'Quality code for lightning_flag';


--
-- Name: COLUMN obs_daily.shower_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.shower_flag IS 'Y/N for shower';


--
-- Name: COLUMN obs_daily.shower_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.shower_flag_qa IS 'Quality code for shower_flag';


--
-- Name: COLUMN obs_daily.rain_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.rain_flag IS 'Y/N for rain';


--
-- Name: COLUMN obs_daily.rain_flag_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_daily.rain_flag_qa IS 'Quality code for rain_flag';


--
-- Name: obs_subdaily_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_subdaily_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_subdaily_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_subdaily_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_subdaily_id IS 'PK sequence for obs_subdaily';


--
-- Name: obs_subdaily; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_subdaily (
    id integer DEFAULT nextval('public.obs_subdaily_id'::regclass) NOT NULL,
    station_no character varying(15) NOT NULL,
    lsd timestamp without time zone NOT NULL,
    gmt timestamp without time zone,
    lct timestamp without time zone,
    data_source character(2) NOT NULL,
    insert_datetime timestamp without time zone NOT NULL,
    change_datetime timestamp without time zone,
    change_user character varying(20),
    qa_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    aws_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    comments character varying(1000),
    air_temp numeric(7,1),
    air_temp_f numeric(7,1),
    air_temp_qa character(2),
    sea_water_temp numeric(7,1),
    sea_water_temp_f numeric(7,1),
    sea_water_temp_qa character(2),
    wet_bulb numeric(7,1),
    wet_bulb_f numeric(7,1),
    wet_bulb_qa character(2),
    dew_point numeric(7,1),
    dew_point_f numeric(7,1),
    dew_point_qa character(2),
    rel_humidity numeric(4,1),
    rel_humidity_qa character(2),
    baro_temp numeric(7,1),
    baro_temp_f numeric(7,1),
    baro_temp_qa character(2),
    pres_as_read numeric(7,1),
    pres_as_read_inches numeric(8,3),
    pres_as_read_qa character(2),
    station_pres numeric(7,1),
    station_pres_inches numeric(8,3),
    station_pres_qa character(2),
    msl_pres numeric(7,1),
    msl_pres_inches numeric(8,3),
    msl_pres_qa character(2),
    vapour_pres numeric(7,1),
    vapour_pres_inches numeric(8,3),
    vapour_pres_qa character(2),
    qnh numeric(7,1),
    qnh_qa character(2),
    visibility numeric(7,3),
    visibility_miles numeric(7,3),
    visibility_code character(1),
    visibility_qa character(2),
    rain_3h numeric(7,1),
    rain_3h_inches numeric(7,3),
    rain_3h_qa character(2),
    rain_3h_hours numeric(3,0) DEFAULT 3,
    rain_cum numeric(7,1),
    rain_cum_inches numeric(7,3),
    rain_cum_qa character(2),
    wind_dir numeric(3,0),
    wind_dir_qa character(2),
    wind_dir_std_dev numeric(3,0),
    wind_dir_std_dev_qa character(2),
    wind_speed numeric(5,1),
    wind_speed_knots numeric(5,1),
    wind_speed_mph numeric(5,1),
    wind_speed_bft character(2),
    wind_speed_qa character(2),
    pres_weather_code character varying(2),
    pres_weather_bft character varying(20),
    pres_weather_qa character(2),
    past_weather_code character varying(2),
    past_weather_bft character varying(20),
    past_weather_qa character(2),
    tot_cloud_oktas smallint,
    tot_cloud_tenths smallint,
    tot_cloud_qa character(2),
    tot_low_cloud_oktas smallint,
    tot_low_cloud_tenths smallint,
    tot_low_cloud_height integer,
    tot_low_cloud_qa character(2),
    state_of_sea character varying(2),
    state_of_sea_qa character(2),
    state_of_swell character varying(2),
    state_of_swell_qa character(2),
    swell_direction character varying(3),
    swell_direction_qa character(2),
    sea_level numeric(5,3),
    sea_level_qa character(2),
    sea_level_residual numeric(5,3),
    sea_level_residual_qa character(2),
    sea_level_resid_adj numeric(5,3),
    sea_level_resid_adj_qa character(2),
    radiation numeric(6,1),
    radiation_qa character(2),
    sunshine numeric(3,1),
    sunshine_qa character(2),
    tot_low_cloud_height_feet integer,
    wind_gust_kts numeric(3,0),
    wind_gust numeric(6,1),
    wind_gust_qa character(2),
    wind_gust_dir numeric(3,0),
    wind_gust_dir_qa character(2),
    river_height numeric(7,3),
    river_height_in numeric(8,1),
    river_height_qa character(2),
    qnh_inches numeric(8,3)
);


ALTER TABLE public.obs_subdaily OWNER TO clidegui;

--
-- Name: TABLE obs_subdaily; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_subdaily IS 'Sub Daily surface observations';


--
-- Name: COLUMN obs_subdaily.station_no; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.station_no IS 'Local Station identifier';


--
-- Name: COLUMN obs_subdaily.lsd; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.lsd IS 'Local System Time (No Daylight Savings)';


--
-- Name: COLUMN obs_subdaily.gmt; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.gmt IS 'GMT (UTC+0)';


--
-- Name: COLUMN obs_subdaily.lct; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.lct IS 'Local Clock Time (With Daylight Savings)';


--
-- Name: COLUMN obs_subdaily.data_source; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.data_source IS 'Code for data source (DATA_SRC)';


--
-- Name: COLUMN obs_subdaily.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.insert_datetime IS 'Date/time row is inserted';


--
-- Name: COLUMN obs_subdaily.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.change_datetime IS 'Date/time row is changed';


--
-- Name: COLUMN obs_subdaily.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.change_user IS 'User who added/changed row';


--
-- Name: COLUMN obs_subdaily.qa_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.qa_flag IS 'QA flag for row (Y/N)';


--
-- Name: COLUMN obs_subdaily.aws_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.aws_flag IS 'AWS sourced data or not (Y/N)';


--
-- Name: COLUMN obs_subdaily.comments; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.comments IS 'User comments';


--
-- Name: COLUMN obs_subdaily.air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.air_temp IS 'Current Air temperature (0.1C)';


--
-- Name: COLUMN obs_subdaily.air_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.air_temp_f IS 'Current Air Temp in Fahrenheit (0.1F)';


--
-- Name: COLUMN obs_subdaily.air_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.air_temp_qa IS 'Quality Code for air_temp';


--
-- Name: COLUMN obs_subdaily.sea_water_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sea_water_temp IS 'Current Sea water Temperature (0.1C)';


--
-- Name: COLUMN obs_subdaily.sea_water_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sea_water_temp_f IS 'Current Sea water Temp in Fahrenheit (0.1F)';


--
-- Name: COLUMN obs_subdaily.sea_water_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sea_water_temp_qa IS 'Quality Code for sea_water_temp';


--
-- Name: COLUMN obs_subdaily.wet_bulb; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wet_bulb IS 'Current Wet bulb reading (0.1C)';


--
-- Name: COLUMN obs_subdaily.wet_bulb_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wet_bulb_f IS 'Current Wet bulb reading in Fahrenheit (0.1F)';


--
-- Name: COLUMN obs_subdaily.wet_bulb_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wet_bulb_qa IS 'Quality Code for wet_bulb';


--
-- Name: COLUMN obs_subdaily.dew_point; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.dew_point IS 'Current Dew Point Temperature (0.1C)';


--
-- Name: COLUMN obs_subdaily.dew_point_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.dew_point_f IS 'Current Dew Point Fahrenheit (0.1F)';


--
-- Name: COLUMN obs_subdaily.dew_point_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.dew_point_qa IS 'Quality Code for dew_point';


--
-- Name: COLUMN obs_subdaily.rel_humidity; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.rel_humidity IS 'Relative humidity  (% to 0.1)';


--
-- Name: COLUMN obs_subdaily.rel_humidity_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.rel_humidity_qa IS 'Quality Code for rel_humidity';


--
-- Name: COLUMN obs_subdaily.baro_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.baro_temp IS 'Current Barometer Temperature (0.1C)';


--
-- Name: COLUMN obs_subdaily.baro_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.baro_temp_f IS 'Current Barometer Fahrenheit (0.1F)';


--
-- Name: COLUMN obs_subdaily.baro_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.baro_temp_qa IS 'Quality Code for baro_temp';


--
-- Name: COLUMN obs_subdaily.pres_as_read; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.pres_as_read IS 'Pressure as read from barometer (hPa to 0.1)';


--
-- Name: COLUMN obs_subdaily.pres_as_read_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.pres_as_read_inches IS 'Pressure as read from barometer (Inches to 0.001)';


--
-- Name: COLUMN obs_subdaily.pres_as_read_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.pres_as_read_qa IS 'Quality Code for pres_as_read';


--
-- Name: COLUMN obs_subdaily.station_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.station_pres IS 'Station Pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_subdaily.station_pres_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.station_pres_inches IS 'Station Pressure (Inches to 0.001)';


--
-- Name: COLUMN obs_subdaily.station_pres_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.station_pres_qa IS 'Quality Code for station_pres';


--
-- Name: COLUMN obs_subdaily.msl_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.msl_pres IS 'Mean Sea Level Pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_subdaily.msl_pres_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.msl_pres_inches IS 'Mean Sea Level Pressure (Inches to 0.001)';


--
-- Name: COLUMN obs_subdaily.msl_pres_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.msl_pres_qa IS 'Quality Code for msl_pres';


--
-- Name: COLUMN obs_subdaily.vapour_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.vapour_pres IS 'Vapour Pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_subdaily.vapour_pres_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.vapour_pres_inches IS 'Vapour Pressure (Inches to 0.001)';


--
-- Name: COLUMN obs_subdaily.vapour_pres_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.vapour_pres_qa IS 'Quality Code for vapour_pres';


--
-- Name: COLUMN obs_subdaily.qnh; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.qnh IS 'Local QNH (hPa to 0.1)';


--
-- Name: COLUMN obs_subdaily.qnh_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.qnh_qa IS 'Quality Code for qnh';


--
-- Name: COLUMN obs_subdaily.visibility; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.visibility IS 'Visibility in Km (Km to 0.001)';


--
-- Name: COLUMN obs_subdaily.visibility_miles; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.visibility_miles IS 'Visibility in Miles (Miles to 0.001)';


--
-- Name: COLUMN obs_subdaily.visibility_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.visibility_qa IS 'Quality Code for visibility';


--
-- Name: COLUMN obs_subdaily.rain_3h; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.rain_3h IS '3 hours cumulative (mm to 0.1)';


--
-- Name: COLUMN obs_subdaily.rain_3h_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.rain_3h_inches IS '3 hours cumulative (Inches to 0.001)';


--
-- Name: COLUMN obs_subdaily.rain_3h_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.rain_3h_qa IS 'Quality Code for rain_3h';


--
-- Name: COLUMN obs_subdaily.rain_cum; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.rain_cum IS 'Cumulative since 0900 (mm to 0.1)';


--
-- Name: COLUMN obs_subdaily.rain_cum_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.rain_cum_inches IS 'Cumulative since 0900 (Inches to 0.001)';


--
-- Name: COLUMN obs_subdaily.rain_cum_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.rain_cum_qa IS 'Quality Code for rain_cum';


--
-- Name: COLUMN obs_subdaily.wind_dir; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_dir IS '10 min Avg Wind direction (degrees 0-360)';


--
-- Name: COLUMN obs_subdaily.wind_dir_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_dir_qa IS 'Quality Code for wind_dir';


--
-- Name: COLUMN obs_subdaily.wind_dir_std_dev; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_dir_std_dev IS '10 min Avg Wind direction standard deviation';


--
-- Name: COLUMN obs_subdaily.wind_dir_std_dev_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_dir_std_dev_qa IS 'Quality Code for wind_dir_std_dev';


--
-- Name: COLUMN obs_subdaily.wind_speed; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_speed IS '10 min Avg Wind Speed (M/S to 0.1)';


--
-- Name: COLUMN obs_subdaily.wind_speed_knots; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_speed_knots IS '10 min Avg Wind Speed (Knots to 0.1)';


--
-- Name: COLUMN obs_subdaily.wind_speed_mph; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_speed_mph IS '10 min Avg Wind Speed (MPH to 0.1)';


--
-- Name: COLUMN obs_subdaily.wind_speed_bft; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_speed_bft IS '10 min Avg Beaufort code for wind speed';


--
-- Name: COLUMN obs_subdaily.wind_speed_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_speed_qa IS 'Quality Code for wind_speed';


--
-- Name: COLUMN obs_subdaily.pres_weather_code; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.pres_weather_code IS 'WMO Code 4677 for present weather.';


--
-- Name: COLUMN obs_subdaily.pres_weather_bft; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.pres_weather_bft IS 'Beaufort Code for present weather';


--
-- Name: COLUMN obs_subdaily.pres_weather_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.pres_weather_qa IS 'Quality Code for pres_weather';


--
-- Name: COLUMN obs_subdaily.past_weather_code; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.past_weather_code IS 'WMO Code 4561';


--
-- Name: COLUMN obs_subdaily.past_weather_bft; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.past_weather_bft IS 'Beaufort Code for past weather';


--
-- Name: COLUMN obs_subdaily.past_weather_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.past_weather_qa IS 'Quality Code for past_weather';


--
-- Name: COLUMN obs_subdaily.tot_cloud_oktas; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.tot_cloud_oktas IS 'Total amount of sky covered by cloud (0-9)';


--
-- Name: COLUMN obs_subdaily.tot_cloud_tenths; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.tot_cloud_tenths IS 'Total amount of sky covered by cloud (0-10)';


--
-- Name: COLUMN obs_subdaily.tot_cloud_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.tot_cloud_qa IS 'Quality Code for tot_cloud';


--
-- Name: COLUMN obs_subdaily.tot_low_cloud_oktas; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.tot_low_cloud_oktas IS 'Total amount of sky covered by Low cloud (0-9)';


--
-- Name: COLUMN obs_subdaily.tot_low_cloud_tenths; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.tot_low_cloud_tenths IS 'Total amount of sky covered by Low cloud (0-10)';


--
-- Name: COLUMN obs_subdaily.tot_low_cloud_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.tot_low_cloud_qa IS 'Quality Code for tot_low_cloud';


--
-- Name: COLUMN obs_subdaily.state_of_sea; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.state_of_sea IS 'State of Sea (Douglas Scale WMO 3700)';


--
-- Name: COLUMN obs_subdaily.state_of_sea_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.state_of_sea_qa IS 'Quality Code for state_of_sea';


--
-- Name: COLUMN obs_subdaily.state_of_swell; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.state_of_swell IS 'State open sea swell (Douglas Scale WMO 3700)';


--
-- Name: COLUMN obs_subdaily.state_of_swell_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.state_of_swell_qa IS 'Quality Code for state_of_swell';


--
-- Name: COLUMN obs_subdaily.swell_direction; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.swell_direction IS 'Direction of Swell (16 Compass Points)';


--
-- Name: COLUMN obs_subdaily.swell_direction_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.swell_direction_qa IS 'Quality Code for swell_direction';


--
-- Name: COLUMN obs_subdaily.sea_level; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sea_level IS 'Sea level (M to 0.001) above tide gauge zero';


--
-- Name: COLUMN obs_subdaily.sea_level_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sea_level_qa IS 'Quality Code for sea_level';


--
-- Name: COLUMN obs_subdaily.sea_level_residual; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sea_level_residual IS '+/- Diff from predicted sea level';


--
-- Name: COLUMN obs_subdaily.sea_level_residual_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sea_level_residual_qa IS 'Quality Code for sea_level_residual';


--
-- Name: COLUMN obs_subdaily.sea_level_resid_adj; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sea_level_resid_adj IS 'Adjusted residual (adjusted for pressure)';


--
-- Name: COLUMN obs_subdaily.sea_level_resid_adj_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sea_level_resid_adj_qa IS 'Quality Code for sea_level_residual_adj';


--
-- Name: COLUMN obs_subdaily.radiation; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.radiation IS 'Radiation Mj/M to 0.1';


--
-- Name: COLUMN obs_subdaily.sunshine; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.sunshine IS 'Decimal Hours to 0.1';


--
-- Name: COLUMN obs_subdaily.wind_gust_kts; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_gust_kts IS 'Wind Gust speed Knots';


--
-- Name: COLUMN obs_subdaily.wind_gust; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_gust IS 'Wind Gust speed M/S';


--
-- Name: COLUMN obs_subdaily.wind_gust_dir; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.wind_gust_dir IS 'Wind Gust direction 0-360';


--
-- Name: COLUMN obs_subdaily.river_height; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily.river_height IS 'River height in M';


--
-- Name: ext_obs_climat; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_climat AS
 SELECT subday.station_no,
    to_date(subday.yyyy_mm, 'yyyy-mm'::text) AS lsd,
    subday.station_pres,
    subday.msl_pres,
    subday.air_temp,
    subday.dew_point,
    subday.vapour_pres,
    day.max_temp,
    day.min_temp,
    day.rain,
    day.rain_days,
    day.sunshine,
    day.max_rowcount,
    day.min_rowcount,
    day.rain_rowcount,
    day.sunshine_rowcount,
    subday.pres_daycount,
    subday.temp_daycount,
    subday.vapour_daycount,
    date_part('day'::text, (((((("substring"(subday.yyyy_mm, 1, 4) || '-'::text) || "substring"(subday.yyyy_mm, 6, 2)) || '-01'::text))::date + '1 mon'::interval) - '1 day'::interval)) AS days_in_month
   FROM (( SELECT sdd.station_no,
            "substring"(sdd.yyyy_mm_dd, 1, 7) AS yyyy_mm,
            round(avg(sdd.station_pres), 1) AS station_pres,
            round(avg(sdd.msl_pres), 1) AS msl_pres,
            round(avg(sdd.air_temp), 1) AS air_temp,
            round(avg(sdd.dew_point), 1) AS dew_point,
            round(avg(sdd.vapour_pres), 1) AS vapour_pres,
            sum(public.iif_sql((sdd.pres_count >= 4), 1, 0)) AS pres_daycount,
            sum(public.iif_sql((sdd.temp_count >= 4), 1, 0)) AS temp_daycount,
            sum(public.iif_sql((sdd.vapour_count >= 4), 1, 0)) AS vapour_daycount
           FROM ( SELECT sd.station_no,
                    to_char(sd.lsd, 'yyyy-mm_dd'::text) AS yyyy_mm_dd,
                    avg(sd.station_pres) AS station_pres,
                    avg(sd.msl_pres) AS msl_pres,
                    avg(sd.air_temp) AS air_temp,
                    avg(sd.dew_point) AS dew_point,
                    avg(exp((1.8096 + ((17.269425 * sd.dew_point) / (237.3 + sd.dew_point))))) AS vapour_pres,
                    count(sd.station_pres) AS pres_count,
                    count(sd.air_temp) AS temp_count,
                    count(sd.dew_point) AS vapour_count
                   FROM public.obs_subdaily sd
                  GROUP BY sd.station_no, (to_char(sd.lsd, 'yyyy-mm_dd'::text))) sdd
          GROUP BY sdd.station_no, ("substring"(sdd.yyyy_mm_dd, 1, 7))) subday
     JOIN ( SELECT d.station_no AS stationno,
            to_char(d.lsd, 'yyyy-mm'::text) AS yyyymm,
            round(avg(d.max_air_temp), 1) AS max_temp,
            round(avg(d.min_air_temp), 1) AS min_temp,
            round(sum(d.rain_24h), 1) AS rain,
            sum(d.rain_24h_count) AS rain_days,
            round(sum(d.sunshine_duration), 1) AS sunshine,
            count(d.max_air_temp) AS max_rowcount,
            count(d.min_air_temp) AS min_rowcount,
            count(d.rain_24h) AS rain_rowcount,
            count(d.sunshine_duration) AS sunshine_rowcount
           FROM public.obs_daily d
          GROUP BY d.station_no, (to_char(d.lsd, 'yyyy-mm'::text))) day ON ((((subday.station_no)::text = (day.stationno)::text) AND (subday.yyyy_mm = day.yyyymm))));


ALTER TABLE public.ext_obs_climat OWNER TO clidegui;

--
-- Name: ext_obs_daily; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_daily AS
 SELECT obs_daily.id,
    obs_daily.station_no,
    obs_daily.lsd,
    obs_daily.data_source,
    obs_daily.insert_datetime,
    obs_daily.change_datetime,
    obs_daily.change_user,
    obs_daily.qa_flag,
    obs_daily.aws_flag,
    obs_daily.comments,
    obs_daily.rain_24h,
    obs_daily.rain_24h_inches,
    obs_daily.rain_24h_period,
    obs_daily.rain_24h_type,
    obs_daily.rain_24h_count,
    obs_daily.rain_24h_qa,
    obs_daily.max_air_temp,
    obs_daily.max_air_temp_f,
    obs_daily.max_air_temp_period,
    obs_daily.max_air_temp_time,
    obs_daily.max_air_temp_qa,
    obs_daily.min_air_temp,
    obs_daily.min_air_temp_f,
    obs_daily.min_air_temp_period,
    obs_daily.min_air_temp_time,
    obs_daily.min_air_temp_qa,
    obs_daily.reg_max_air_temp,
    obs_daily.reg_max_air_temp_qa,
    obs_daily.reg_min_air_temp,
    obs_daily.reg_min_air_temp_qa,
    obs_daily.ground_temp,
    obs_daily.ground_temp_f,
    obs_daily.ground_temp_qa,
    obs_daily.max_gust_dir,
    obs_daily.max_gust_dir_qa,
    obs_daily.max_gust_speed,
    obs_daily.max_gust_speed_kts,
    obs_daily.max_gust_speed_bft,
    obs_daily.max_gust_speed_qa,
    obs_daily.max_gust_time,
    obs_daily.max_gust_time_qa,
    obs_daily.wind_run_lt10,
    obs_daily.wind_run_lt10_miles,
    obs_daily.wind_run_lt10_period,
    obs_daily.wind_run_lt10_qa,
    obs_daily.wind_run_gt10,
    obs_daily.wind_run_gt10_miles,
    obs_daily.wind_run_gt10_period,
    obs_daily.wind_run_gt10_qa,
    obs_daily.evaporation,
    obs_daily.evaporation_inches,
    obs_daily.evaporation_period,
    obs_daily.evaporation_qa,
    obs_daily.evap_water_max_temp,
    obs_daily.evap_water_max_temp_f,
    obs_daily.evap_water_max_temp_qa,
    obs_daily.evap_water_min_temp,
    obs_daily.evap_water_min_temp_f,
    obs_daily.evap_water_min_temp_qa,
    obs_daily.sunshine_duration,
    obs_daily.sunshine_duration_qa,
    obs_daily.river_height,
    obs_daily.river_height_in,
    obs_daily.river_height_qa,
    obs_daily.radiation,
    obs_daily.radiation_qa,
    obs_daily.thunder_flag,
    obs_daily.thunder_flag_qa,
    obs_daily.frost_flag,
    obs_daily.frost_flag_qa,
    obs_daily.dust_flag,
    obs_daily.dust_flag_qa,
    obs_daily.haze_flag,
    obs_daily.haze_flag_qa,
    obs_daily.fog_flag,
    obs_daily.fog_flag_qa,
    obs_daily.strong_wind_flag,
    obs_daily.strong_wind_flag_qa,
    obs_daily.gale_flag,
    obs_daily.gale_flag_qa,
    obs_daily.hail_flag,
    obs_daily.hail_flag_qa,
    obs_daily.snow_flag,
    obs_daily.snow_flag_qa,
    obs_daily.lightning_flag,
    obs_daily.lightning_flag_qa,
    obs_daily.shower_flag,
    obs_daily.shower_flag_qa,
    obs_daily.rain_flag,
    obs_daily.rain_flag_qa,
    obs_daily.dew_flag,
    obs_daily.dew_flag_qa
   FROM public.obs_daily
  ORDER BY obs_daily.station_no, obs_daily.lsd;


ALTER TABLE public.ext_obs_daily OWNER TO clidegui;

--
-- Name: ext_obs_daily_basics; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_daily_basics AS
 SELECT obs_daily.station_no,
    obs_daily.lsd,
    obs_daily.max_air_temp,
    obs_daily.min_air_temp,
    obs_daily.rain_24h
   FROM public.obs_daily
  ORDER BY obs_daily.station_no, obs_daily.lsd;


ALTER TABLE public.ext_obs_daily_basics OWNER TO clidegui;

--
-- Name: key_settings_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.key_settings_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.key_settings_id OWNER TO clidegui;

--
-- Name: SEQUENCE key_settings_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.key_settings_id IS 'PK sequence for key_settings';


--
-- Name: obs_monthly; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_monthly (
    id integer DEFAULT nextval('public.key_settings_id'::regclass) NOT NULL,
    station_no character varying(15) NOT NULL,
    lsd date NOT NULL,
    data_source character(2),
    insert_datetime timestamp without time zone,
    change_datetime timestamp without time zone,
    change_user character varying(20),
    qa_flag character(1),
    comments character varying(1000),
    dly_max_rain numeric(8,1),
    dly_max_rain_inches numeric(8,1),
    dly_max_rain_date character varying(120),
    dly_max_rain_qa character(2),
    max_max_air_temp numeric(7,1),
    max_max_air_temp_f numeric(7,1),
    max_max_air_temp_qa character(2),
    max_max_air_temp_date character varying(120),
    min_min_air_temp numeric(7,1),
    min_min_air_temp_f numeric(7,1),
    min_min_air_temp_qa character(2),
    min_min_air_temp_date character varying(120),
    min_min_ground_temp numeric(7,1),
    min_min_ground_temp_f numeric(7,1),
    min_min_ground_temp_qa character(2),
    min_min_ground_temp_date character varying(120),
    mn_air_temp numeric(7,1),
    mn_air_temp_f numeric(7,1),
    mn_air_temp_qa character(2),
    mn_max_air_temp numeric(7,1),
    mn_max_air_temp_f numeric(7,1),
    mn_max_air_temp_qa character(2),
    mn_min_air_temp numeric(7,1),
    mn_min_air_temp_f numeric(7,1),
    mn_min_air_temp_qa character(2),
    mn_wet_bulb_temp numeric(7,1),
    mn_wet_bulb_temp_f numeric(7,1),
    mn_wet_bulb_temp_qa character(2),
    mn_min_ground_temp numeric(7,1),
    mn_min_ground_temp_f numeric(7,1),
    mn_min_ground_temp_qa character(2),
    mn_asread_pres numeric(7,1),
    mn_asread_pres_inches numeric(8,3),
    mn_asread_pres_mmhg numeric(7,2),
    mn_asread_pres_qa character(2),
    mn_msl_pres numeric(7,1),
    mn_msl_pres_inches numeric(8,3),
    mn_msl_pres_mmhg numeric(7,2),
    mn_msl_pres_qa character(2),
    mn_station_pres numeric(7,1),
    mn_station_pres_inches numeric(8,3),
    mn_station_pres_mmhg numeric(7,2),
    mn_station_pres_qa character(2),
    mn_vapour_pres numeric(7,1),
    mn_vapour_pres_inches numeric(8,3),
    mn_vapour_pres_mmhg numeric(7,2),
    mn_vapour_pres_qa character(2),
    mn_evaporation numeric(4,1),
    mn_evaporation_inches numeric(6,3),
    mn_evaporation_qa character(2),
    mn_rel_humidity numeric(4,1),
    mn_rel_humidity_qa character(2),
    mn_sun_hours numeric(4,2),
    mn_sun_hours_qa character(2),
    mn_tot_cloud_oktas numeric(1,0),
    mn_tot_cloud_tenths numeric(2,0),
    mn_tot_cloud_qa character(2),
    tot_evaporation numeric(8,1),
    tot_evaporation_inches numeric(9,3),
    tot_evaporation_qa character(2),
    tot_rain numeric(8,1),
    tot_rain_inches numeric(9,3),
    tot_rain_qa character(2),
    tot_rain_days numeric(4,0),
    tot_rain_days_qa character(2),
    tot_rain_percent numeric(4,0),
    tot_rain_percent_qa character(2)
);


ALTER TABLE public.obs_monthly OWNER TO clidegui;

--
-- Name: TABLE obs_monthly; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_monthly IS 'Stores monthly data not available as daily or subdaily';


--
-- Name: COLUMN obs_monthly.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.id IS 'Surrogate Key';


--
-- Name: COLUMN obs_monthly.station_no; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.station_no IS 'Local Station identifier';


--
-- Name: COLUMN obs_monthly.lsd; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.lsd IS 'Local System Year and Month';


--
-- Name: COLUMN obs_monthly.data_source; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.data_source IS 'Code for data source, see codes_simple for code_type=DATA_SRC';


--
-- Name: COLUMN obs_monthly.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.insert_datetime IS 'Date/Time row is inserted';


--
-- Name: COLUMN obs_monthly.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.change_datetime IS 'Date/Time row is updated';


--
-- Name: COLUMN obs_monthly.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.change_user IS 'User who added/changed row';


--
-- Name: COLUMN obs_monthly.qa_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.qa_flag IS 'QA flag for row Y/N';


--
-- Name: COLUMN obs_monthly.comments; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.comments IS 'User comments';


--
-- Name: COLUMN obs_monthly.dly_max_rain; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.dly_max_rain IS 'Highest Daily precipitation mm';


--
-- Name: COLUMN obs_monthly.dly_max_rain_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.dly_max_rain_inches IS 'Highest Daily precipitation (inches to .001)';


--
-- Name: COLUMN obs_monthly.dly_max_rain_date; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.dly_max_rain_date IS 'Date(s) of highest rain as dd,dd,dd,...';


--
-- Name: COLUMN obs_monthly.max_max_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.max_max_air_temp IS 'Highest daily maximum air temp (C to 0.1)';


--
-- Name: COLUMN obs_monthly.max_max_air_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.max_max_air_temp_f IS 'Highest daily maximum air temp (F to 0.1)';


--
-- Name: COLUMN obs_monthly.max_max_air_temp_date; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.max_max_air_temp_date IS 'Date(s) of highest max air temp as dd,dd,dd,...';


--
-- Name: COLUMN obs_monthly.min_min_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.min_min_air_temp IS 'Lowest daily minimum air temp (C to 0.1)';


--
-- Name: COLUMN obs_monthly.min_min_air_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.min_min_air_temp_f IS 'Lowest daily minimum air temp (F to 0.1)';


--
-- Name: COLUMN obs_monthly.min_min_air_temp_date; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.min_min_air_temp_date IS 'Date(s) of lowest daily min as dd,dd,dd,...';


--
-- Name: COLUMN obs_monthly.min_min_ground_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.min_min_ground_temp IS 'Lowest minimum daily ground temp (C to 0.1)';


--
-- Name: COLUMN obs_monthly.min_min_ground_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.min_min_ground_temp_f IS 'Lowest minimum daily ground temp (F to 0.1)';


--
-- Name: COLUMN obs_monthly.min_min_ground_temp_date; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.min_min_ground_temp_date IS 'Date(s) of lowest daily ground min as dd,dd,dd,...';


--
-- Name: COLUMN obs_monthly.mn_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_air_temp IS 'Mean air temperature (C to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_air_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_air_temp_f IS 'Mean air temperature (F to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_max_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_max_air_temp IS 'Mean of maximum daily air temp (C to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_max_air_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_max_air_temp_f IS 'Mean of maximum daily air temp (F to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_min_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_min_air_temp IS 'Mean of minimum daily air temp (C to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_min_air_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_min_air_temp_f IS 'Mean of minimum daily air temp (F to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_wet_bulb_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_wet_bulb_temp IS 'Mean wet bulb temperature (C to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_wet_bulb_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_wet_bulb_temp_f IS 'Mean wet bulb temperature (F to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_min_ground_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_min_ground_temp IS 'Mean of minimum daily ground temp (C to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_min_ground_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_min_ground_temp_f IS 'Mean of minimum daily ground temp (F to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_asread_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_asread_pres IS 'Mean as read pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_asread_pres_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_asread_pres_inches IS 'Mean as read pressure (inches to 0.001)';


--
-- Name: COLUMN obs_monthly.mn_asread_pres_mmhg; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_asread_pres_mmhg IS 'Mean as read pressure (mmHg to 0.01)';


--
-- Name: COLUMN obs_monthly.mn_msl_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_msl_pres IS 'Mean MSL pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_msl_pres_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_msl_pres_inches IS 'Mean MSL pressure (inches to 0.001)';


--
-- Name: COLUMN obs_monthly.mn_msl_pres_mmhg; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_msl_pres_mmhg IS 'Mean MSL pressure (mmHg to 0.01)';


--
-- Name: COLUMN obs_monthly.mn_station_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_station_pres IS 'Mean station level pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_station_pres_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_station_pres_inches IS 'Mean station level pressure (inches to 0.001)';


--
-- Name: COLUMN obs_monthly.mn_station_pres_mmhg; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_station_pres_mmhg IS 'Mean station level pressure (mmHg to 0.01)';


--
-- Name: COLUMN obs_monthly.mn_vapour_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_vapour_pres IS 'Mean Vapour Pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_vapour_pres_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_vapour_pres_inches IS 'Mean Vapour Pressure (Inches to 0.001)';


--
-- Name: COLUMN obs_monthly.mn_vapour_pres_mmhg; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_vapour_pres_mmhg IS 'Mean Vapour Pressure (mmHg to 0.01)';


--
-- Name: COLUMN obs_monthly.mn_evaporation; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_evaporation IS 'Mean of daily evaporation (mm to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_evaporation_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_evaporation_inches IS 'Mean of daily evaporation (Inches to 0.001)';


--
-- Name: COLUMN obs_monthly.mn_rel_humidity; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_rel_humidity IS 'Mean Relative Humidity (% to 0.1)';


--
-- Name: COLUMN obs_monthly.mn_sun_hours; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_sun_hours IS 'Mean of daily bright sunshine (hours to 0.01)';


--
-- Name: COLUMN obs_monthly.mn_tot_cloud_oktas; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_tot_cloud_oktas IS 'Mean of Daily Total Cloud Amt (Octas 0-9)';


--
-- Name: COLUMN obs_monthly.mn_tot_cloud_tenths; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.mn_tot_cloud_tenths IS 'Mean of Daily Total Cloud Amt (Tenths 0-10)';


--
-- Name: COLUMN obs_monthly.tot_evaporation; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.tot_evaporation IS 'Total Monthly evaporation (mm to 0.1)';


--
-- Name: COLUMN obs_monthly.tot_evaporation_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.tot_evaporation_inches IS 'Total Monthly evaporation (Inches to 0.001)';


--
-- Name: COLUMN obs_monthly.tot_rain; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.tot_rain IS 'Total monthly precipitation  (mm to 0.1)';


--
-- Name: COLUMN obs_monthly.tot_rain_inches; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.tot_rain_inches IS 'Total monthly precipitation  (Inches to 0.001)';


--
-- Name: COLUMN obs_monthly.tot_rain_days; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.tot_rain_days IS 'Number of rain days';


--
-- Name: COLUMN obs_monthly.tot_rain_percent; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_monthly.tot_rain_percent IS 'Percentage complete (not missing) of daily records for month';


--
-- Name: ext_obs_monthly; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_monthly AS
 SELECT obs_monthly.id,
    obs_monthly.station_no,
    obs_monthly.lsd,
    obs_monthly.data_source,
    obs_monthly.insert_datetime,
    obs_monthly.change_datetime,
    obs_monthly.change_user,
    obs_monthly.qa_flag,
    obs_monthly.comments,
    obs_monthly.dly_max_rain,
    obs_monthly.dly_max_rain_inches,
    obs_monthly.dly_max_rain_date,
    obs_monthly.dly_max_rain_qa,
    obs_monthly.max_max_air_temp,
    obs_monthly.max_max_air_temp_f,
    obs_monthly.max_max_air_temp_qa,
    obs_monthly.max_max_air_temp_date,
    obs_monthly.min_min_air_temp,
    obs_monthly.min_min_air_temp_f,
    obs_monthly.min_min_air_temp_qa,
    obs_monthly.min_min_air_temp_date,
    obs_monthly.min_min_ground_temp,
    obs_monthly.min_min_ground_temp_f,
    obs_monthly.min_min_ground_temp_qa,
    obs_monthly.min_min_ground_temp_date,
    obs_monthly.mn_air_temp,
    obs_monthly.mn_air_temp_f,
    obs_monthly.mn_air_temp_qa,
    obs_monthly.mn_max_air_temp,
    obs_monthly.mn_max_air_temp_f,
    obs_monthly.mn_max_air_temp_qa,
    obs_monthly.mn_min_air_temp,
    obs_monthly.mn_min_air_temp_f,
    obs_monthly.mn_min_air_temp_qa,
    obs_monthly.mn_wet_bulb_temp,
    obs_monthly.mn_wet_bulb_temp_f,
    obs_monthly.mn_wet_bulb_temp_qa,
    obs_monthly.mn_min_ground_temp,
    obs_monthly.mn_min_ground_temp_f,
    obs_monthly.mn_min_ground_temp_qa,
    obs_monthly.mn_asread_pres,
    obs_monthly.mn_asread_pres_inches,
    obs_monthly.mn_asread_pres_mmhg,
    obs_monthly.mn_asread_pres_qa,
    obs_monthly.mn_msl_pres,
    obs_monthly.mn_msl_pres_inches,
    obs_monthly.mn_msl_pres_mmhg,
    obs_monthly.mn_msl_pres_qa,
    obs_monthly.mn_station_pres,
    obs_monthly.mn_station_pres_inches,
    obs_monthly.mn_station_pres_mmhg,
    obs_monthly.mn_station_pres_qa,
    obs_monthly.mn_vapour_pres,
    obs_monthly.mn_vapour_pres_inches,
    obs_monthly.mn_vapour_pres_mmhg,
    obs_monthly.mn_vapour_pres_qa,
    obs_monthly.mn_evaporation,
    obs_monthly.mn_evaporation_inches,
    obs_monthly.mn_evaporation_qa,
    obs_monthly.mn_rel_humidity,
    obs_monthly.mn_rel_humidity_qa,
    obs_monthly.mn_sun_hours,
    obs_monthly.mn_sun_hours_qa,
    obs_monthly.mn_tot_cloud_oktas,
    obs_monthly.mn_tot_cloud_tenths,
    obs_monthly.mn_tot_cloud_qa,
    obs_monthly.tot_evaporation,
    obs_monthly.tot_evaporation_inches,
    obs_monthly.tot_evaporation_qa,
    obs_monthly.tot_rain,
    obs_monthly.tot_rain_inches,
    obs_monthly.tot_rain_qa,
    obs_monthly.tot_rain_days,
    obs_monthly.tot_rain_days_qa,
    obs_monthly.tot_rain_percent,
    obs_monthly.tot_rain_percent_qa
   FROM public.obs_monthly;


ALTER TABLE public.ext_obs_monthly OWNER TO clidegui;

--
-- Name: ext_obs_monthly_calculated; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_monthly_calculated AS
 SELECT daily.station_no,
    daily.lsd_month AS lsd,
    daily.yyyy_mm,
    daily.max_max_air_temp,
    daily.min_min_air_temp,
    daily.min_min_ground_temp,
    daily.mn_min_ground_temp,
    daily.mn_max_air_temp,
    daily.mn_min_air_temp,
    daily.mn_air_temp,
    daily.dly_max_rain,
    daily.tot_rain,
    daily.tot_rain_days,
    (((daily.missing_count)::double precision / daily.days_in_month) * (100)::double precision) AS tot_rain_percent,
    daily.mn_evaporation,
    daily.tot_evaporation,
    daily.mn_sun_hours,
    subdaily.mn_asread_pres,
    subdaily.mn_msl_pres,
    subdaily.mn_station_pres,
    subdaily.mn_vapour_pres,
    subdaily.mn_rel_humidity,
    subdaily.mn_tot_cloud_oktas
   FROM (( SELECT obs_daily.station_no,
            to_char(obs_daily.lsd, 'yyyy-mm'::text) AS yyyy_mm,
            (date_trunc('month'::text, obs_daily.lsd))::date AS lsd_month,
            max(obs_daily.max_air_temp) AS max_max_air_temp,
            min(obs_daily.min_air_temp) AS min_min_air_temp,
            min(obs_daily.ground_temp) AS min_min_ground_temp,
            avg(obs_daily.ground_temp) AS mn_min_ground_temp,
            avg(obs_daily.max_air_temp) AS mn_max_air_temp,
            avg(obs_daily.min_air_temp) AS mn_min_air_temp,
            avg(((obs_daily.max_air_temp + obs_daily.min_air_temp) / (2)::numeric)) AS mn_air_temp,
            max(obs_daily.rain_24h) AS dly_max_rain,
            sum(obs_daily.rain_24h) AS tot_rain,
            sum(obs_daily.rain_24h_count) AS tot_rain_days,
            date_part('day'::text, (((((("substring"(to_char(obs_daily.lsd, 'yyyy-mm'::text), 1, 4) || '-'::text) || "substring"(to_char(obs_daily.lsd, 'yyyy-mm'::text), 6, 2)) || '-01'::text))::date + '1 mon'::interval) - '1 day'::interval)) AS days_in_month,
            sum(
                CASE
                    WHEN (obs_daily.rain_24h_qa = '00'::bpchar) THEN 1
                    ELSE 0
                END) AS missing_count,
            avg(obs_daily.evaporation) AS mn_evaporation,
            sum(obs_daily.evaporation) AS tot_evaporation,
            avg(obs_daily.sunshine_duration) AS mn_sun_hours
           FROM public.obs_daily
          GROUP BY obs_daily.station_no, (to_char(obs_daily.lsd, 'yyyy-mm'::text)), ((date_trunc('month'::text, obs_daily.lsd))::date)) daily
     JOIN ( SELECT obs_subdaily.station_no,
            to_char(obs_subdaily.lsd, 'yyyy-mm'::text) AS yyyy_mm,
            (date_trunc('month'::text, obs_subdaily.lsd))::date AS lsd_month,
            avg(obs_subdaily.pres_as_read) AS mn_asread_pres,
            avg(obs_subdaily.msl_pres) AS mn_msl_pres,
            avg(obs_subdaily.station_pres) AS mn_station_pres,
            avg(obs_subdaily.vapour_pres) AS mn_vapour_pres,
            avg(obs_subdaily.rel_humidity) AS mn_rel_humidity,
            avg(obs_subdaily.tot_cloud_oktas) AS mn_tot_cloud_oktas
           FROM public.obs_subdaily
          GROUP BY obs_subdaily.station_no, (to_char(obs_subdaily.lsd, 'yyyy-mm'::text)), ((date_trunc('month'::text, obs_subdaily.lsd))::date)) subdaily ON ((((daily.station_no)::text = (subdaily.station_no)::text) AND (daily.yyyy_mm = subdaily.yyyy_mm))));


ALTER TABLE public.ext_obs_monthly_calculated OWNER TO clidegui;

--
-- Name: ext_obs_monthly_combined; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_monthly_combined AS
 SELECT 'RAW'::text AS source,
    ext_obs_monthly_calculated.station_no,
    ext_obs_monthly_calculated.yyyy_mm,
    ext_obs_monthly_calculated.lsd,
    ext_obs_monthly_calculated.max_max_air_temp,
    ext_obs_monthly_calculated.min_min_air_temp,
    ext_obs_monthly_calculated.min_min_ground_temp,
    ext_obs_monthly_calculated.mn_min_ground_temp,
    ext_obs_monthly_calculated.mn_max_air_temp,
    ext_obs_monthly_calculated.mn_min_air_temp,
    ext_obs_monthly_calculated.mn_air_temp,
    ext_obs_monthly_calculated.dly_max_rain,
    ext_obs_monthly_calculated.tot_rain,
    ext_obs_monthly_calculated.tot_rain_days,
    ext_obs_monthly_calculated.tot_rain_percent,
    ext_obs_monthly_calculated.mn_evaporation,
    ext_obs_monthly_calculated.tot_evaporation,
    ext_obs_monthly_calculated.mn_sun_hours,
    ext_obs_monthly_calculated.mn_asread_pres,
    ext_obs_monthly_calculated.mn_msl_pres,
    ext_obs_monthly_calculated.mn_station_pres,
    ext_obs_monthly_calculated.mn_vapour_pres,
    ext_obs_monthly_calculated.mn_rel_humidity,
    ext_obs_monthly_calculated.mn_tot_cloud_oktas
   FROM public.ext_obs_monthly_calculated
UNION ALL
 SELECT 'KEY'::text AS source,
    obs_monthly.station_no,
    to_char((obs_monthly.lsd)::timestamp with time zone, 'yyyy-mm'::text) AS yyyy_mm,
    (date_trunc('month'::text, (obs_monthly.lsd)::timestamp with time zone))::date AS lsd,
    obs_monthly.max_max_air_temp,
    obs_monthly.min_min_air_temp,
    obs_monthly.min_min_ground_temp,
    obs_monthly.mn_min_ground_temp,
    obs_monthly.mn_max_air_temp,
    obs_monthly.mn_min_air_temp,
    obs_monthly.mn_air_temp,
    obs_monthly.dly_max_rain,
    obs_monthly.tot_rain,
    obs_monthly.tot_rain_days,
    obs_monthly.tot_rain_percent,
    obs_monthly.mn_evaporation,
    obs_monthly.tot_evaporation,
    obs_monthly.mn_sun_hours,
    obs_monthly.mn_asread_pres,
    obs_monthly.mn_msl_pres,
    obs_monthly.mn_station_pres,
    obs_monthly.mn_vapour_pres,
    obs_monthly.mn_rel_humidity,
    obs_monthly.mn_tot_cloud_oktas
   FROM public.obs_monthly
  ORDER BY 4, 2;


ALTER TABLE public.ext_obs_monthly_combined OWNER TO clidegui;

--
-- Name: ext_obs_subdaily; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_subdaily AS
 SELECT obs_subdaily.id,
    obs_subdaily.station_no,
    obs_subdaily.lsd,
    obs_subdaily.gmt,
    obs_subdaily.lct,
    obs_subdaily.data_source,
    obs_subdaily.insert_datetime,
    obs_subdaily.change_datetime,
    obs_subdaily.change_user,
    obs_subdaily.qa_flag,
    obs_subdaily.aws_flag,
    obs_subdaily.comments,
    obs_subdaily.air_temp,
    obs_subdaily.air_temp_f,
    obs_subdaily.air_temp_qa,
    obs_subdaily.sea_water_temp,
    obs_subdaily.sea_water_temp_f,
    obs_subdaily.sea_water_temp_qa,
    obs_subdaily.wet_bulb,
    obs_subdaily.wet_bulb_f,
    obs_subdaily.wet_bulb_qa,
    obs_subdaily.dew_point,
    obs_subdaily.dew_point_f,
    obs_subdaily.dew_point_qa,
    obs_subdaily.rel_humidity,
    obs_subdaily.rel_humidity_qa,
    obs_subdaily.baro_temp,
    obs_subdaily.baro_temp_f,
    obs_subdaily.baro_temp_qa,
    obs_subdaily.pres_as_read,
    obs_subdaily.pres_as_read_inches,
    obs_subdaily.pres_as_read_qa,
    obs_subdaily.station_pres,
    obs_subdaily.station_pres_inches,
    obs_subdaily.station_pres_qa,
    obs_subdaily.msl_pres,
    obs_subdaily.msl_pres_inches,
    obs_subdaily.msl_pres_qa,
    obs_subdaily.vapour_pres,
    obs_subdaily.vapour_pres_inches,
    obs_subdaily.vapour_pres_qa,
    obs_subdaily.qnh,
    obs_subdaily.qnh_qa,
    obs_subdaily.visibility,
    obs_subdaily.visibility_miles,
    obs_subdaily.visibility_code,
    obs_subdaily.visibility_qa,
    obs_subdaily.rain_3h,
    obs_subdaily.rain_3h_inches,
    obs_subdaily.rain_3h_qa,
    obs_subdaily.rain_3h_hours,
    obs_subdaily.rain_cum,
    obs_subdaily.rain_cum_inches,
    obs_subdaily.rain_cum_qa,
    obs_subdaily.wind_dir,
    obs_subdaily.wind_dir_qa,
    obs_subdaily.wind_dir_std_dev,
    obs_subdaily.wind_dir_std_dev_qa,
    obs_subdaily.wind_speed,
    obs_subdaily.wind_speed_knots,
    obs_subdaily.wind_speed_mph,
    obs_subdaily.wind_speed_bft,
    obs_subdaily.wind_speed_qa,
    obs_subdaily.pres_weather_code,
    obs_subdaily.pres_weather_bft,
    obs_subdaily.pres_weather_qa,
    obs_subdaily.past_weather_code,
    obs_subdaily.past_weather_bft,
    obs_subdaily.past_weather_qa,
    obs_subdaily.tot_cloud_oktas,
    obs_subdaily.tot_cloud_tenths,
    obs_subdaily.tot_cloud_qa,
    obs_subdaily.tot_low_cloud_oktas,
    obs_subdaily.tot_low_cloud_tenths,
    obs_subdaily.tot_low_cloud_height,
    obs_subdaily.tot_low_cloud_qa,
    obs_subdaily.state_of_sea,
    obs_subdaily.state_of_sea_qa,
    obs_subdaily.state_of_swell,
    obs_subdaily.state_of_swell_qa,
    obs_subdaily.swell_direction,
    obs_subdaily.swell_direction_qa,
    obs_subdaily.sea_level,
    obs_subdaily.sea_level_qa,
    obs_subdaily.sea_level_residual,
    obs_subdaily.sea_level_residual_qa,
    obs_subdaily.sea_level_resid_adj,
    obs_subdaily.sea_level_resid_adj_qa,
    obs_subdaily.radiation,
    obs_subdaily.radiation_qa,
    obs_subdaily.sunshine,
    obs_subdaily.sunshine_qa,
    obs_subdaily.tot_low_cloud_height_feet,
    obs_subdaily.wind_gust_kts,
    obs_subdaily.wind_gust,
    obs_subdaily.wind_gust_qa,
    obs_subdaily.wind_gust_dir,
    obs_subdaily.wind_gust_dir_qa
   FROM public.obs_subdaily
  ORDER BY obs_subdaily.station_no, obs_subdaily.lsd;


ALTER TABLE public.ext_obs_subdaily OWNER TO clidegui;

--
-- Name: obs_subdaily_cloud_layers_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_subdaily_cloud_layers_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_subdaily_cloud_layers_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_subdaily_cloud_layers_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_subdaily_cloud_layers_id IS 'PK sequence for obs_subdaily_cloud_layers';


--
-- Name: obs_subdaily_cloud_layers; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_subdaily_cloud_layers (
    id integer DEFAULT nextval('public.obs_subdaily_cloud_layers_id'::regclass) NOT NULL,
    sub_daily_id integer NOT NULL,
    data_source character(2) DEFAULT '1'::bpchar NOT NULL,
    insert_datetime timestamp without time zone DEFAULT now() NOT NULL,
    change_datetime timestamp without time zone,
    change_user character varying(20),
    qa_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    aws_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    layer_no integer NOT NULL,
    layer_type character varying(6),
    cloud_oktas smallint,
    cloud_tenths smallint,
    cloud_amt_qa character(2),
    cloud_type character varying(2),
    cloud_type_qa character(2),
    cloud_height numeric(6,0),
    cloud_height_feet numeric(7,0),
    cloud_height_qa character(2),
    cloud_dir numeric(3,0),
    cloud_dir_qa character(2)
);


ALTER TABLE public.obs_subdaily_cloud_layers OWNER TO clidegui;

--
-- Name: TABLE obs_subdaily_cloud_layers; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_subdaily_cloud_layers IS 'Sub Daily surface observations';


--
-- Name: COLUMN obs_subdaily_cloud_layers.sub_daily_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.sub_daily_id IS 'Surrogate key of parent sub daily row';


--
-- Name: COLUMN obs_subdaily_cloud_layers.layer_no; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.layer_no IS 'layer number. (1,2,3,n)';


--
-- Name: COLUMN obs_subdaily_cloud_layers.layer_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.layer_type IS 'Low, Mid, High';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_oktas; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_oktas IS 'Cloud  amount in octas (0-9)';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_tenths; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_tenths IS 'Cloud  amount in tenths (0-10)';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_amt_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_amt_qa IS 'Quality Code for clout_amt';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_type IS 'Cloud type, WMO code';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_type_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_type_qa IS 'Quality Code for cloud_type';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_height; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_height IS 'Cloud height in Meters (M to 1.0)';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_height_feet; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_height_feet IS 'Cloud height in feet (feet to 1.0)';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_height_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_height_qa IS 'Quality Code for cloud_height';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_dir; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_dir IS 'Cloud movement Direction (0-360)';


--
-- Name: COLUMN obs_subdaily_cloud_layers.cloud_dir_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_cloud_layers.cloud_dir_qa IS 'Quality Code for cloud_dir';


--
-- Name: ext_obs_subdaily_cloud_layers; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_subdaily_cloud_layers AS
 SELECT s.station_no,
    s.lsd,
    scl.layer_no,
    scl.layer_type,
    scl.cloud_oktas,
    scl.cloud_tenths,
    scl.cloud_amt_qa,
    scl.cloud_type,
    scl.cloud_type_qa,
    scl.cloud_height,
    scl.cloud_height_feet,
    scl.cloud_height_qa,
    scl.cloud_dir,
    scl.cloud_dir_qa,
    scl.data_source,
    scl.insert_datetime,
    scl.change_datetime,
    scl.change_user,
    scl.qa_flag,
    scl.aws_flag
   FROM (public.obs_subdaily s
     JOIN public.obs_subdaily_cloud_layers scl ON ((scl.sub_daily_id = s.id)))
  ORDER BY s.station_no, s.lsd, scl.layer_no;


ALTER TABLE public.ext_obs_subdaily_cloud_layers OWNER TO clidegui;

--
-- Name: obs_subdaily_soil_temps_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_subdaily_soil_temps_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_subdaily_soil_temps_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_subdaily_soil_temps_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_subdaily_soil_temps_id IS 'PK sequence for obs_subdaily_soil_temps';


--
-- Name: obs_subdaily_soil_temps; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_subdaily_soil_temps (
    id integer DEFAULT nextval('public.obs_subdaily_soil_temps_id'::regclass) NOT NULL,
    sub_daily_id integer NOT NULL,
    data_source character(2) DEFAULT '1'::bpchar NOT NULL,
    insert_datetime timestamp without time zone DEFAULT now() NOT NULL,
    change_datetime timestamp without time zone,
    change_user character varying(20),
    qa_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    aws_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    soil_depth numeric(5,0) NOT NULL,
    soil_temp numeric(7,1),
    soil_temp_f numeric(7,1),
    soil_temp_qa character(2)
);


ALTER TABLE public.obs_subdaily_soil_temps OWNER TO clidegui;

--
-- Name: TABLE obs_subdaily_soil_temps; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_subdaily_soil_temps IS 'Sub Daily surface observations';


--
-- Name: COLUMN obs_subdaily_soil_temps.sub_daily_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_soil_temps.sub_daily_id IS 'Surrogate key of parent sub daily row';


--
-- Name: COLUMN obs_subdaily_soil_temps.soil_depth; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_soil_temps.soil_depth IS 'Soil depth in cm';


--
-- Name: COLUMN obs_subdaily_soil_temps.soil_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_soil_temps.soil_temp IS 'Soil Temperature (C to 0.1)';


--
-- Name: COLUMN obs_subdaily_soil_temps.soil_temp_f; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_soil_temps.soil_temp_f IS 'Soil Temperature (F to 0.1)';


--
-- Name: COLUMN obs_subdaily_soil_temps.soil_temp_qa; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_subdaily_soil_temps.soil_temp_qa IS 'Quality Code for soil_temp';


--
-- Name: ext_obs_subdaily_soil_temps; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_subdaily_soil_temps AS
 SELECT s.station_no,
    s.lsd,
    sst.soil_depth,
    sst.soil_temp,
    sst.soil_temp_f,
    sst.soil_temp_qa,
    sst.change_user,
    sst.insert_datetime,
    sst.change_datetime,
    sst.qa_flag,
    sst.aws_flag
   FROM (public.obs_subdaily s
     JOIN public.obs_subdaily_soil_temps sst ON ((sst.sub_daily_id = s.id)))
  ORDER BY s.station_no, s.lsd, sst.soil_depth;


ALTER TABLE public.ext_obs_subdaily_soil_temps OWNER TO clidegui;

--
-- Name: obs_upper_air_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_upper_air_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_upper_air_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_upper_air_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_upper_air_id IS 'PK sequence for obs_upper_air';


--
-- Name: obs_upper_air; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_upper_air (
    id integer DEFAULT nextval('public.obs_upper_air_id'::regclass) NOT NULL,
    station_no character varying(15) NOT NULL,
    lsd timestamp without time zone NOT NULL,
    gmt timestamp without time zone,
    lct timestamp without time zone,
    data_source character(2) NOT NULL,
    insert_datetime timestamp without time zone NOT NULL,
    change_datetime timestamp without time zone,
    change_user character varying(20),
    qa_flag character(1) DEFAULT 'N'::bpchar NOT NULL,
    pressure numeric(7,1) NOT NULL,
    pressure_qa character(2),
    level_type numeric(2,0),
    geo_height numeric(8,1),
    geo_height_qa character(2),
    air_temp numeric(7,1),
    air_temp_qa character(2),
    dew_point numeric(4,1),
    dew_point_qa character(2),
    wind_direction numeric(4,0),
    wind_direction_qa character(2),
    wind_speed numeric(5,1),
    wind_speed_qa character(2)
);


ALTER TABLE public.obs_upper_air OWNER TO clidegui;

--
-- Name: TABLE obs_upper_air; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_upper_air IS 'Upper Air observations';


--
-- Name: COLUMN obs_upper_air.station_no; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.station_no IS 'Local Station identifier';


--
-- Name: COLUMN obs_upper_air.lsd; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.lsd IS 'Local System Time (No Daylight Savings)';


--
-- Name: COLUMN obs_upper_air.gmt; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.gmt IS 'GMT (UTC+0)';


--
-- Name: COLUMN obs_upper_air.lct; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.lct IS 'Local Clock Time (With Daylight Savings)';


--
-- Name: COLUMN obs_upper_air.data_source; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.data_source IS 'Code for data source (Ref Table??)';


--
-- Name: COLUMN obs_upper_air.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.insert_datetime IS 'Date/time row is inserted';


--
-- Name: COLUMN obs_upper_air.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.change_datetime IS 'Date/time row is changed';


--
-- Name: COLUMN obs_upper_air.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.change_user IS 'User who added/changed row';


--
-- Name: COLUMN obs_upper_air.qa_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.qa_flag IS 'QA flag for row (Y/N)';


--
-- Name: COLUMN obs_upper_air.pressure; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.pressure IS 'Pressure (hPa to 0.1)';


--
-- Name: COLUMN obs_upper_air.level_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.level_type IS 'Level type (0,1,n)';


--
-- Name: COLUMN obs_upper_air.geo_height; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.geo_height IS 'Meters';


--
-- Name: COLUMN obs_upper_air.air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.air_temp IS 'Temperature (C to 0.1)';


--
-- Name: COLUMN obs_upper_air.dew_point; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.dew_point IS 'Dew Point Temperature (C to 0.1)';


--
-- Name: COLUMN obs_upper_air.wind_direction; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.wind_direction IS 'Direction (0-360 degrees)';


--
-- Name: COLUMN obs_upper_air.wind_speed; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_upper_air.wind_speed IS 'Wind Speed (M/s to 0.1)';


--
-- Name: ext_obs_upper_air; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_obs_upper_air AS
 SELECT obs_upper_air.id,
    obs_upper_air.station_no,
    obs_upper_air.lsd,
    obs_upper_air.gmt,
    obs_upper_air.lct,
    obs_upper_air.data_source,
    obs_upper_air.insert_datetime,
    obs_upper_air.change_datetime,
    obs_upper_air.change_user,
    obs_upper_air.qa_flag,
    obs_upper_air.pressure,
    obs_upper_air.pressure_qa,
    obs_upper_air.level_type,
    obs_upper_air.geo_height,
    obs_upper_air.geo_height_qa,
    obs_upper_air.air_temp,
    obs_upper_air.air_temp_qa,
    obs_upper_air.dew_point,
    obs_upper_air.dew_point_qa,
    obs_upper_air.wind_direction,
    obs_upper_air.wind_direction_qa,
    obs_upper_air.wind_speed,
    obs_upper_air.wind_speed_qa
   FROM public.obs_upper_air
  ORDER BY obs_upper_air.station_no, obs_upper_air.lsd;


ALTER TABLE public.ext_obs_upper_air OWNER TO clidegui;

--
-- Name: station_audit_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_audit_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_audit_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_audit_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_audit_id IS 'PK sequence for station audit';


--
-- Name: station_audit; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_audit (
    id integer DEFAULT nextval('public.station_audit_id'::regclass) NOT NULL,
    station_id integer,
    datetime timestamp with time zone,
    event_datetime timestamp with time zone DEFAULT now(),
    audit_type_id integer NOT NULL,
    description character varying(1000),
    event_user character varying(40)
);


ALTER TABLE public.station_audit OWNER TO clidegui;

--
-- Name: TABLE station_audit; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_audit IS 'Audit trail of all changes to station Station.';


--
-- Name: COLUMN station_audit.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_audit.id IS 'Surrogate Key';


--
-- Name: COLUMN station_audit.station_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_audit.station_id IS 'Station ID of audit record';


--
-- Name: COLUMN station_audit.datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_audit.datetime IS 'Date/Time of event being recorded';


--
-- Name: COLUMN station_audit.audit_type_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_audit.audit_type_id IS 'Audit Type ID. Joins to station_audit_type';


--
-- Name: COLUMN station_audit.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_audit.description IS 'Description of audit event';


--
-- Name: COLUMN station_audit.event_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_audit.event_user IS 'User performing the auditable event';


--
-- Name: station_audit_type_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_audit_type_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_audit_type_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_audit_type_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_audit_type_id IS 'PK sequence for station audit type';


--
-- Name: station_audit_types; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_audit_types (
    id integer DEFAULT nextval('public.station_audit_type_id'::regclass) NOT NULL,
    audit_type character varying(10) NOT NULL,
    description character varying(50),
    system_type character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.station_audit_types OWNER TO clidegui;

--
-- Name: TABLE station_audit_types; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_audit_types IS 'Stores allowed values for station_audit.type_id';


--
-- Name: COLUMN station_audit_types.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_audit_types.id IS 'Surrogate Key';


--
-- Name: COLUMN station_audit_types.audit_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_audit_types.audit_type IS 'Audit type code';


--
-- Name: COLUMN station_audit_types.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_audit_types.description IS 'Description of audit type';


--
-- Name: stations_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.stations_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stations_id OWNER TO clidegui;

--
-- Name: SEQUENCE stations_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.stations_id IS 'PK sequence for stations';


--
-- Name: stations; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.stations (
    id integer DEFAULT nextval('public.stations_id'::regclass) NOT NULL,
    station_no character varying(15) NOT NULL,
    status_id integer NOT NULL,
    time_zone character varying(3) NOT NULL,
    id_aero character varying(10),
    id_imo character varying(10),
    id_marine character varying(10),
    id_wmo character varying(10),
    id_hydro character varying(10),
    id_aust character varying(10),
    id_niwa character varying(10),
    id_niwa_agent character varying(10),
    comments character varying(1000),
    country_code character varying(4),
    start_date date,
    end_date date,
    ht_aero numeric(6,1),
    ht_elev numeric(7,3),
    ht_ssb numeric(7,4),
    latitude numeric(8,4),
    longitude numeric(8,4),
    name_primary character varying(40),
    name_secondary character varying(40),
    region character varying(40),
    catchment character varying(40),
    authority character varying(50),
    lu_0_100m integer,
    lu_100m_1km integer,
    lu_1km_10km integer,
    soil_type integer,
    surface_type integer,
    critical_river_height numeric(7,3),
    location_datum character varying(20),
    location_epsg integer
);


ALTER TABLE public.stations OWNER TO clidegui;

--
-- Name: TABLE stations; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.stations IS 'Stores station data.';


--
-- Name: COLUMN stations.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.stations.id IS 'Surrogate Key';


--
-- Name: COLUMN stations.status_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.stations.status_id IS 'Station status ID joins to station_status';


--
-- Name: COLUMN stations.critical_river_height; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.stations.critical_river_height IS 'Critical River height (eg. Flood level) in M';


--
-- Name: ext_station_audit; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_station_audit AS
 SELECT s.station_no,
    s.name_primary AS station_name,
    sa.datetime,
    sa.audit_type_id,
    sat.description AS audit_type_description,
    (('"'::text || (sa.description)::text) || '"'::text) AS event_description,
    sa.event_user AS "user"
   FROM ((public.station_audit sa
     JOIN public.stations s ON ((s.id = sa.station_id)))
     JOIN public.station_audit_types sat ON ((sat.id = sa.audit_type_id)))
  ORDER BY s.station_no, sa.datetime;


ALTER TABLE public.ext_station_audit OWNER TO clidegui;

--
-- Name: station_class_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_class_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_class_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_class_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_class_id IS 'PK sequence for station class';


--
-- Name: station_class; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_class (
    id integer DEFAULT nextval('public.station_class_id'::regclass) NOT NULL,
    station_id integer NOT NULL,
    type_id integer,
    description character varying(80),
    class_start timestamp without time zone,
    class_end timestamp without time zone
);


ALTER TABLE public.station_class OWNER TO clidegui;

--
-- Name: TABLE station_class; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_class IS 'Stores contacts (people) for station';


--
-- Name: COLUMN station_class.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_class.id IS 'Surrogate Key';


--
-- Name: COLUMN station_class.station_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_class.station_id IS 'Station ID of station class';


--
-- Name: COLUMN station_class.type_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_class.type_id IS 'ID of Type for this class';


--
-- Name: COLUMN station_class.class_start; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_class.class_start IS 'Date this class started for the station.';


--
-- Name: COLUMN station_class.class_end; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_class.class_end IS 'Date this class ended for the station.';


--
-- Name: ext_station_class; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_station_class AS
 SELECT s.station_no,
    s.name_primary AS station_name,
    t.station_type AS class,
    t.description AS class_description,
    sc.class_start,
    sc.class_end,
    sc.description
   FROM ((public.stations s
     JOIN public.station_class sc ON ((sc.station_id = s.id)))
     JOIN public.station_types t ON ((sc.type_id = t.id)))
  ORDER BY s.station_no, t.station_type;


ALTER TABLE public.ext_station_class OWNER TO clidegui;

--
-- Name: station_equipment_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_equipment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_equipment_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_equipment_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_equipment_id IS 'PK sequence for station equipment';


--
-- Name: station_equipment; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_equipment (
    id integer DEFAULT nextval('public.station_equipment_id'::regclass) NOT NULL,
    station_id integer NOT NULL,
    equipment_id integer,
    serial_no character varying(50),
    asset_id character varying(50),
    height numeric(7,3),
    comments character varying(1000),
    date_start date,
    date_end date
);


ALTER TABLE public.station_equipment OWNER TO clidegui;

--
-- Name: TABLE station_equipment; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_equipment IS 'Stores equipment installed at station.';


--
-- Name: COLUMN station_equipment.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_equipment.id IS 'Surrogate Key';


--
-- Name: COLUMN station_equipment.station_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_equipment.station_id IS 'ID of station';


--
-- Name: COLUMN station_equipment.serial_no; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_equipment.serial_no IS 'Serial no of equipment';


--
-- Name: COLUMN station_equipment.asset_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_equipment.asset_id IS 'Asset code of equipment';


--
-- Name: COLUMN station_equipment.comments; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_equipment.comments IS 'Comments for equipment';


--
-- Name: COLUMN station_equipment.date_start; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_equipment.date_start IS 'Date of installation';


--
-- Name: COLUMN station_equipment.date_end; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_equipment.date_end IS 'Date of decomissioning or removal';


--
-- Name: ext_station_equipment; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_station_equipment AS
 SELECT s.station_no,
    s.name_primary AS station_name,
    e.type AS equipment_type,
    e.version AS equipment_version,
    e.comments AS equipment_comments,
    se.serial_no,
    se.asset_id,
    se.height,
    se.date_start,
    se.date_end,
    se.comments
   FROM ((public.stations s
     JOIN public.station_equipment se ON ((se.station_id = s.id)))
     JOIN public.equipment e ON ((se.equipment_id = e.id)))
  ORDER BY s.station_no, e.type;


ALTER TABLE public.ext_station_equipment OWNER TO clidegui;

--
-- Name: land_use_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.land_use_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.land_use_id OWNER TO clidegui;

--
-- Name: SEQUENCE land_use_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.land_use_id IS 'PK sequence for land use';


--
-- Name: land_use; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.land_use (
    id integer DEFAULT nextval('public.land_use_id'::regclass) NOT NULL,
    land_use_code character varying(10) NOT NULL,
    priority integer NOT NULL,
    description character varying(100)
);


ALTER TABLE public.land_use OWNER TO clidegui;

--
-- Name: TABLE land_use; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.land_use IS 'Stores allowed values for stations.soil_type_id';


--
-- Name: COLUMN land_use.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.land_use.id IS 'Surrogate Key';


--
-- Name: COLUMN land_use.land_use_code; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.land_use.land_use_code IS 'Land usage code';


--
-- Name: COLUMN land_use.priority; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.land_use.priority IS 'Land usage priority';


--
-- Name: COLUMN land_use.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.land_use.description IS 'Land use description';


--
-- Name: soil_types_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.soil_types_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.soil_types_id OWNER TO clidegui;

--
-- Name: SEQUENCE soil_types_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.soil_types_id IS 'PK sequence for soil types';


--
-- Name: soil_types; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.soil_types (
    id integer DEFAULT nextval('public.soil_types_id'::regclass) NOT NULL,
    soil_type character varying(10) NOT NULL,
    description character varying(50)
);


ALTER TABLE public.soil_types OWNER TO clidegui;

--
-- Name: TABLE soil_types; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.soil_types IS 'Stores allowed values for stations.soil_type_id';


--
-- Name: COLUMN soil_types.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.soil_types.id IS 'Surrogate Key';


--
-- Name: COLUMN soil_types.soil_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.soil_types.soil_type IS 'Soil type code';


--
-- Name: COLUMN soil_types.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.soil_types.description IS 'Soil type description';


--
-- Name: station_countries_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_countries_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_countries_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_countries_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_countries_id IS 'PK sequence for station countries';


--
-- Name: station_countries; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_countries (
    id integer DEFAULT nextval('public.station_countries_id'::regclass) NOT NULL,
    iso_code character varying(4) NOT NULL,
    description character varying(50)
);


ALTER TABLE public.station_countries OWNER TO clidegui;

--
-- Name: TABLE station_countries; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_countries IS 'Stores countries that stations can belong to.';


--
-- Name: COLUMN station_countries.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_countries.id IS 'Surrogate Key';


--
-- Name: COLUMN station_countries.iso_code; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_countries.iso_code IS 'International ISO country code 3166';


--
-- Name: COLUMN station_countries.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_countries.description IS 'Country Name';


--
-- Name: station_status_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_status_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_status_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_status_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_status_id IS 'PK sequence for station status';


--
-- Name: station_status; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_status (
    id integer DEFAULT nextval('public.station_status_id'::regclass) NOT NULL,
    status character varying(10) NOT NULL,
    description character varying(50)
);


ALTER TABLE public.station_status OWNER TO clidegui;

--
-- Name: TABLE station_status; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_status IS 'Stores allowed values for stations.status_id';


--
-- Name: COLUMN station_status.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_status.id IS 'Surrogate Key';


--
-- Name: COLUMN station_status.status; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_status.status IS 'Status Code';


--
-- Name: COLUMN station_status.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_status.description IS 'Description of status';


--
-- Name: station_timezones_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_timezones_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_timezones_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_timezones_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_timezones_id IS 'PK sequence for station time zones';


--
-- Name: station_timezones; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_timezones (
    id integer DEFAULT nextval('public.station_timezones_id'::regclass) NOT NULL,
    tm_zone character varying(3) NOT NULL,
    utc_diff numeric(4,1) NOT NULL,
    description character varying(50)
);


ALTER TABLE public.station_timezones OWNER TO clidegui;

--
-- Name: TABLE station_timezones; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_timezones IS 'Stores time zone that stations can be in.';


--
-- Name: COLUMN station_timezones.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_timezones.id IS 'Surrogate Key';


--
-- Name: COLUMN station_timezones.tm_zone; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_timezones.tm_zone IS 'Time zone code';


--
-- Name: COLUMN station_timezones.utc_diff; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_timezones.utc_diff IS 'Adjustment ADDED to get local standard time';


--
-- Name: COLUMN station_timezones.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_timezones.description IS 'Description of time zone';


--
-- Name: surface_types_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.surface_types_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surface_types_id OWNER TO clidegui;

--
-- Name: SEQUENCE surface_types_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.surface_types_id IS 'PK sequence for surface types';


--
-- Name: surface_types; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.surface_types (
    id integer DEFAULT nextval('public.surface_types_id'::regclass) NOT NULL,
    surface_type character varying(10) NOT NULL,
    description character varying(50)
);


ALTER TABLE public.surface_types OWNER TO clidegui;

--
-- Name: TABLE surface_types; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.surface_types IS 'Stores allowed values for stations.surface_type_id';


--
-- Name: COLUMN surface_types.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.surface_types.id IS 'Surrogate Key';


--
-- Name: COLUMN surface_types.surface_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.surface_types.surface_type IS 'Surface type code';


--
-- Name: COLUMN surface_types.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.surface_types.description IS 'Surface type description';


--
-- Name: ext_stations; Type: VIEW; Schema: public; Owner: clidegui
--

CREATE VIEW public.ext_stations AS
 SELECT s.id,
    s.station_no,
    s.name_primary,
    s.name_secondary,
    s.region,
    s.catchment,
    s.authority,
    ss.description AS status,
    s.start_date,
    s.end_date,
    s.ht_aero AS aero_height,
    s.ht_elev AS station_elevation,
    s.latitude,
    s.longitude,
    s.time_zone,
    tim.utc_diff AS utc_offset,
    tim.description AS timezone_description,
    s.id_aero,
    s.id_imo,
    s.id_marine,
    s.id_wmo,
    s.id_hydro,
    s.id_aust,
    s.id_niwa,
    s.id_niwa_agent,
    s.country_code,
    cou.description AS country_description,
    s.lu_0_100m,
    lu1.description AS land_use_0_100m,
    s.lu_100m_1km,
    lu2.description AS land_use_100m_1km,
    s.lu_1km_10km,
    lu3.description AS land_use_1km_10km,
    s.comments
   FROM ((((((((public.stations s
     LEFT JOIN public.surface_types sur ON ((s.surface_type = sur.id)))
     LEFT JOIN public.soil_types soi ON ((s.soil_type = soi.id)))
     LEFT JOIN public.station_status ss ON ((s.status_id = ss.id)))
     LEFT JOIN public.station_timezones tim ON (((s.time_zone)::text = (tim.tm_zone)::text)))
     LEFT JOIN public.station_countries cou ON (((s.country_code)::text = (cou.iso_code)::text)))
     LEFT JOIN public.land_use lu1 ON ((s.lu_0_100m = lu1.id)))
     LEFT JOIN public.land_use lu2 ON ((s.lu_100m_1km = lu2.id)))
     LEFT JOIN public.land_use lu3 ON ((s.lu_1km_10km = lu3.id)))
  ORDER BY s.station_no;


ALTER TABLE public.ext_stations OWNER TO clidegui;

--
-- Name: gui_users_id_seq; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.gui_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gui_users_id_seq OWNER TO clidegui;

--
-- Name: SEQUENCE gui_users_id_seq; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.gui_users_id_seq IS 'PK sequence for gui_users';


--
-- Name: gui_users; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.gui_users (
    id integer DEFAULT nextval('public.gui_users_id_seq'::regclass) NOT NULL,
    username character varying(20) NOT NULL,
    css_filename character varying(120),
    layout character(4) DEFAULT 'POP'::bpchar,
    key character varying(64),
    disabled character(1),
    disable_date timestamp with time zone,
    station_maint character(1) DEFAULT 'N'::bpchar NOT NULL,
    codes_maint character(1) DEFAULT 'N'::bpchar NOT NULL,
    user_admin character(1) DEFAULT 'N'::bpchar NOT NULL,
    file_ingest character(1) DEFAULT 'N'::bpchar NOT NULL,
    key_entry character(1) DEFAULT 'N'::bpchar NOT NULL,
    qa character(1) DEFAULT 'N'::bpchar NOT NULL,
    products character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE public.gui_users OWNER TO clidegui;

--
-- Name: TABLE gui_users; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.gui_users IS 'User data for web GUI';


--
-- Name: COLUMN gui_users.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.gui_users.id IS 'Surrogate Key';


--
-- Name: COLUMN gui_users.username; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.gui_users.username IS 'Login user id';


--
-- Name: COLUMN gui_users.css_filename; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.gui_users.css_filename IS 'Name of style sheet selected';


--
-- Name: COLUMN gui_users.layout; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.gui_users.layout IS 'Layout of page: LEFT menu, top menu, popup menu, HTML';


--
-- Name: ingest_monitor_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.ingest_monitor_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ingest_monitor_id OWNER TO clidegui;

--
-- Name: SEQUENCE ingest_monitor_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.ingest_monitor_id IS 'PK sequence for ingest_monitor';


--
-- Name: ingest_monitor; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.ingest_monitor (
    id integer DEFAULT nextval('public.ingest_monitor_id'::regclass) NOT NULL,
    username character varying(20) NOT NULL,
    ip_addr character varying(20),
    filename character varying(200),
    ingest_start timestamp without time zone DEFAULT now() NOT NULL,
    ingest_end timestamp without time zone,
    file_recs integer,
    ingested_recs integer,
    ok_count integer,
    err_count integer,
    cancel_flag character(1),
    cancel_user character varying(20),
    change_datetime timestamp without time zone
);


ALTER TABLE public.ingest_monitor OWNER TO clidegui;

--
-- Name: TABLE ingest_monitor; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.ingest_monitor IS 'Stores file ingestion stats for data ingests';


--
-- Name: COLUMN ingest_monitor.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.ingest_monitor.id IS 'Surrogate Key';


--
-- Name: COLUMN ingest_monitor.username; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.ingest_monitor.username IS 'User that started ingest';


--
-- Name: COLUMN ingest_monitor.ip_addr; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.ingest_monitor.ip_addr IS 'Client IP address where ingest was invoked from';


--
-- Name: COLUMN ingest_monitor.filename; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.ingest_monitor.filename IS 'File name of file being ingested';


--
-- Name: COLUMN ingest_monitor.ingest_start; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.ingest_monitor.ingest_start IS 'Ingest start time';


--
-- Name: COLUMN ingest_monitor.ingest_end; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.ingest_monitor.ingest_end IS 'Ingest end time';


--
-- Name: COLUMN ingest_monitor.file_recs; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.ingest_monitor.file_recs IS 'Count of all input file records';


--
-- Name: COLUMN ingest_monitor.ingested_recs; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.ingest_monitor.ingested_recs IS 'Count of all ingested input file records';


--
-- Name: key_settings; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.key_settings (
    id integer DEFAULT nextval('public.key_settings_id'::regclass) NOT NULL,
    profile character varying(20) NOT NULL,
    obs_type character varying(20),
    element character varying(120),
    default_unit character varying(20),
    disable_flag character(1),
    change_user character varying(20),
    change_datetime timestamp without time zone
);


ALTER TABLE public.key_settings OWNER TO clidegui;

--
-- Name: TABLE key_settings; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.key_settings IS 'Stores key entry settings: Default units, disable flag';


--
-- Name: COLUMN key_settings.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.key_settings.id IS 'Surrogate Key';


--
-- Name: COLUMN key_settings.profile; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.key_settings.profile IS 'profile name';


--
-- Name: COLUMN key_settings.obs_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.key_settings.obs_type IS 'obsservation type: daily, subdaily';


--
-- Name: COLUMN key_settings.element; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.key_settings.element IS 'observation element';


--
-- Name: COLUMN key_settings.default_unit; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.key_settings.default_unit IS 'Default unit in key entry forms';


--
-- Name: COLUMN key_settings.disable_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.key_settings.disable_flag IS 'Y=disable in entry forms';


--
-- Name: obs_audit_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_audit_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_audit_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_audit_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_audit_id IS 'PK sequence for obs audit';


--
-- Name: obs_audit; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_audit (
    id integer DEFAULT nextval('public.obs_audit_id'::regclass) NOT NULL,
    table_name character varying(100),
    row_id integer,
    column_name character varying(100),
    column_value character varying(4000),
    change_user character varying(20),
    datetime timestamp with time zone
);


ALTER TABLE public.obs_audit OWNER TO clidegui;

--
-- Name: TABLE obs_audit; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_audit IS 'Audit trail of all changes to station Station.';


--
-- Name: COLUMN obs_audit.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_audit.id IS 'Surrogate Key';


--
-- Name: COLUMN obs_audit.table_name; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_audit.table_name IS 'Observation table where data is changed';


--
-- Name: COLUMN obs_audit.row_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_audit.row_id IS 'Row id of changed data';


--
-- Name: COLUMN obs_audit.column_name; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_audit.column_name IS 'Column that has been changed';


--
-- Name: COLUMN obs_audit.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_audit.change_user IS 'User performing the change';


--
-- Name: COLUMN obs_audit.datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_audit.datetime IS 'Datetime of change';


--
-- Name: obs_averages_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_averages_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_averages_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_averages_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_averages_id IS 'PK sequence for obs_averages';


--
-- Name: obs_averages; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_averages (
    id integer DEFAULT nextval('public.obs_averages_id'::regclass) NOT NULL,
    insert_datetime timestamp without time zone DEFAULT now() NOT NULL,
    change_datetime timestamp without time zone,
    change_user character varying(20),
    station_no character varying(20) NOT NULL,
    month smallint NOT NULL,
    name character varying(60) NOT NULL,
    active_normal character(1),
    from_date date NOT NULL,
    to_date date NOT NULL,
    station_pres numeric(7,1),
    msl_pres numeric(7,1),
    air_temp numeric(7,1),
    max_air_temp numeric(7,1),
    min_air_temp numeric(7,1),
    vapour_pres numeric(7,1),
    rainfall numeric(7,1),
    rain_days smallint,
    sun_hours smallint,
    missing_station_pres smallint,
    missing_air_temp smallint,
    missing_max_min smallint,
    missing_vapour_pres smallint,
    missing_rainfall smallint,
    missing_sun_hours smallint,
    air_temp_stddev numeric(7,1)
);


ALTER TABLE public.obs_averages OWNER TO clidegui;

--
-- Name: TABLE obs_averages; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_averages IS 'Normals and other monthly long term averages of observations.';


--
-- Name: COLUMN obs_averages.month; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.month IS 'Month of averages';


--
-- Name: COLUMN obs_averages.name; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.name IS 'Name of this set of averages';


--
-- Name: COLUMN obs_averages.from_date; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.from_date IS 'Start date of observations in this average set';


--
-- Name: COLUMN obs_averages.to_date; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.to_date IS 'End date of observations in this average set';


--
-- Name: COLUMN obs_averages.station_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.station_pres IS 'Average Station Pressure: from obs_subdaily.station_pres';


--
-- Name: COLUMN obs_averages.msl_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.msl_pres IS 'Average MSL Pressure: from obs_subdaily.msl_pres';


--
-- Name: COLUMN obs_averages.air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.air_temp IS 'Average air temp: from obs_subdaily.air_temp';


--
-- Name: COLUMN obs_averages.max_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.max_air_temp IS 'Average max air temp: from obs_daily.max_air_temp';


--
-- Name: COLUMN obs_averages.min_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.min_air_temp IS 'Average min air temp: from obs_daily.min_air_temp';


--
-- Name: COLUMN obs_averages.vapour_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.vapour_pres IS 'Average vapour pressure: from obs_subdaily.dew_point';


--
-- Name: COLUMN obs_averages.rainfall; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.rainfall IS 'Avg Total monthly rainfall. from obs_daily.rain_24h';


--
-- Name: COLUMN obs_averages.rain_days; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.rain_days IS 'Avg Total monthly rain days. from obs_daily.rain_24h_count';


--
-- Name: COLUMN obs_averages.sun_hours; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.sun_hours IS 'Avg monthly sunshine hours. from obs_daily.sunshine_duration';


--
-- Name: COLUMN obs_averages.missing_station_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.missing_station_pres IS 'Number of years missing from the record of normal station pressure';


--
-- Name: COLUMN obs_averages.missing_air_temp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.missing_air_temp IS 'Number of years missing from the record of normal air temp';


--
-- Name: COLUMN obs_averages.missing_max_min; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.missing_max_min IS 'Number of years missing from the record of normal daily max or min air temp';


--
-- Name: COLUMN obs_averages.missing_vapour_pres; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.missing_vapour_pres IS 'Number of years missing from the record of normal daily vapour pres';


--
-- Name: COLUMN obs_averages.missing_rainfall; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.missing_rainfall IS 'Number of years missing from the record of normal daily rainfall';


--
-- Name: COLUMN obs_averages.missing_sun_hours; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.missing_sun_hours IS 'Number of years missing from the record of normal daily sunshine hours';


--
-- Name: COLUMN obs_averages.air_temp_stddev; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obs_averages.air_temp_stddev IS 'Std Deviation of air temp';


--
-- Name: obs_clicom_element_map_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_clicom_element_map_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_clicom_element_map_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_clicom_element_map_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_clicom_element_map_id IS 'PK sequence for obs_clicom_element_map';


--
-- Name: obs_clicom_element_map; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obs_clicom_element_map (
    id integer DEFAULT nextval('public.obs_clicom_element_map_id'::regclass) NOT NULL,
    clicom_element character varying(5) NOT NULL,
    cldb_table character varying(80) NOT NULL,
    cldb_column character varying(80) NOT NULL,
    associated_col character varying(80),
    associated_value character varying(100),
    column_type character varying(4) DEFAULT 'num'::character varying,
    nominal_value character varying(20)
);


ALTER TABLE public.obs_clicom_element_map OWNER TO clidegui;

--
-- Name: TABLE obs_clicom_element_map; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obs_clicom_element_map IS 'Mapping Clicom Codes to CLDB table, column';


--
-- Name: obs_monthly_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obs_monthly_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obs_monthly_id OWNER TO clidegui;

--
-- Name: SEQUENCE obs_monthly_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obs_monthly_id IS 'PK sequence for obs_monthly';


--
-- Name: obscodes_cloud_amt_conv_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obscodes_cloud_amt_conv_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obscodes_cloud_amt_conv_id OWNER TO clidegui;

--
-- Name: SEQUENCE obscodes_cloud_amt_conv_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obscodes_cloud_amt_conv_id IS 'PK sequence for obscodes_cloud_amt_conv';


--
-- Name: obscodes_cloud_amt_conv; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obscodes_cloud_amt_conv (
    id integer DEFAULT nextval('public.obscodes_cloud_amt_conv_id'::regclass) NOT NULL,
    code_0501 character(1),
    code_2700 character(1),
    code_bft character varying(10),
    tenths character varying(5),
    oktas character(1),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone NOT NULL
);


ALTER TABLE public.obscodes_cloud_amt_conv OWNER TO clidegui;

--
-- Name: TABLE obscodes_cloud_amt_conv; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obscodes_cloud_amt_conv IS 'Cloud Amount conversions';


--
-- Name: COLUMN obscodes_cloud_amt_conv.code_0501; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_amt_conv.code_0501 IS 'WMO Code 0501 code form';


--
-- Name: COLUMN obscodes_cloud_amt_conv.code_2700; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_amt_conv.code_2700 IS 'WMO Code 2700 code form';


--
-- Name: COLUMN obscodes_cloud_amt_conv.code_bft; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_amt_conv.code_bft IS 'Beaufort code';


--
-- Name: COLUMN obscodes_cloud_amt_conv.tenths; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_amt_conv.tenths IS 'Tenths (Can be multiple values comma separated)';


--
-- Name: COLUMN obscodes_cloud_amt_conv.oktas; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_amt_conv.oktas IS 'Oktas (1-9)';


--
-- Name: COLUMN obscodes_cloud_amt_conv.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_amt_conv.change_user IS 'User of last change';


--
-- Name: COLUMN obscodes_cloud_amt_conv.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_amt_conv.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN obscodes_cloud_amt_conv.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_amt_conv.insert_datetime IS 'Timestamp of insert';


--
-- Name: obscodes_cloud_conv_1677_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obscodes_cloud_conv_1677_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obscodes_cloud_conv_1677_id OWNER TO clidegui;

--
-- Name: SEQUENCE obscodes_cloud_conv_1677_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obscodes_cloud_conv_1677_id IS 'PK sequence for obscodes_cloud_conv_1677';


--
-- Name: obscodes_cloud_conv_1677; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obscodes_cloud_conv_1677 (
    id integer DEFAULT nextval('public.obscodes_cloud_conv_1677_id'::regclass) NOT NULL,
    code character varying(2),
    low_feet numeric(7,0),
    low_meters numeric(7,0),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone
);


ALTER TABLE public.obscodes_cloud_conv_1677 OWNER TO clidegui;

--
-- Name: TABLE obscodes_cloud_conv_1677; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obscodes_cloud_conv_1677 IS 'Cloud Height conversions for WMO 1677';


--
-- Name: COLUMN obscodes_cloud_conv_1677.code; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_conv_1677.code IS 'WMO 1677 code';


--
-- Name: COLUMN obscodes_cloud_conv_1677.low_feet; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_conv_1677.low_feet IS 'Lower bound in feet';


--
-- Name: COLUMN obscodes_cloud_conv_1677.low_meters; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_conv_1677.low_meters IS 'Lower bound in M';


--
-- Name: COLUMN obscodes_cloud_conv_1677.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_conv_1677.change_user IS 'User of last change';


--
-- Name: COLUMN obscodes_cloud_conv_1677.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_conv_1677.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN obscodes_cloud_conv_1677.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_conv_1677.insert_datetime IS 'Timestamp of insert';


--
-- Name: obscodes_cloud_ht_conv_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obscodes_cloud_ht_conv_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obscodes_cloud_ht_conv_id OWNER TO clidegui;

--
-- Name: SEQUENCE obscodes_cloud_ht_conv_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obscodes_cloud_ht_conv_id IS 'PK sequence for obscodes_cloud_ht_conv';


--
-- Name: obscodes_cloud_ht_conv; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obscodes_cloud_ht_conv (
    id integer DEFAULT nextval('public.obscodes_cloud_ht_conv_id'::regclass) NOT NULL,
    code character(1),
    low_feet numeric(9,0),
    high_feet numeric(9,0),
    low_meters numeric(7,0),
    high_meters numeric(7,0),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone
);


ALTER TABLE public.obscodes_cloud_ht_conv OWNER TO clidegui;

--
-- Name: TABLE obscodes_cloud_ht_conv; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obscodes_cloud_ht_conv IS 'Cloud Height conversions';


--
-- Name: COLUMN obscodes_cloud_ht_conv.code; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_ht_conv.code IS 'WMO 1600 Code';


--
-- Name: COLUMN obscodes_cloud_ht_conv.low_feet; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_ht_conv.low_feet IS 'Lower bound in feet';


--
-- Name: COLUMN obscodes_cloud_ht_conv.high_feet; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_ht_conv.high_feet IS 'Upper bound in Feet';


--
-- Name: COLUMN obscodes_cloud_ht_conv.low_meters; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_ht_conv.low_meters IS 'Lower Bound in M';


--
-- Name: COLUMN obscodes_cloud_ht_conv.high_meters; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_ht_conv.high_meters IS 'Upper Bound in M';


--
-- Name: COLUMN obscodes_cloud_ht_conv.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_ht_conv.change_user IS 'User of last change';


--
-- Name: COLUMN obscodes_cloud_ht_conv.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_ht_conv.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN obscodes_cloud_ht_conv.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_ht_conv.insert_datetime IS 'Timestamp of insert';


--
-- Name: obscodes_cloud_type_conv_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obscodes_cloud_type_conv_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obscodes_cloud_type_conv_id OWNER TO clidegui;

--
-- Name: SEQUENCE obscodes_cloud_type_conv_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obscodes_cloud_type_conv_id IS 'PK sequence for obscodes_cloud_type_conv';


--
-- Name: obscodes_cloud_type_conv; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obscodes_cloud_type_conv (
    id integer DEFAULT nextval('public.obscodes_cloud_type_conv_id'::regclass) NOT NULL,
    code_0500 character(1),
    code_figure character(1),
    wmo_table character(4),
    layer character varying(4),
    types character varying(10),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone
);


ALTER TABLE public.obscodes_cloud_type_conv OWNER TO clidegui;

--
-- Name: TABLE obscodes_cloud_type_conv; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obscodes_cloud_type_conv IS 'Cloud Type conversions';


--
-- Name: COLUMN obscodes_cloud_type_conv.code_figure; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_type_conv.code_figure IS 'WMO Code figure';


--
-- Name: COLUMN obscodes_cloud_type_conv.wmo_table; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_type_conv.wmo_table IS 'WMO Table no (0513 Low, 0515 Mid, 0509 High)';


--
-- Name: COLUMN obscodes_cloud_type_conv.layer; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_type_conv.layer IS 'Cloud Layer: Low, Mid, High';


--
-- Name: COLUMN obscodes_cloud_type_conv.types; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_type_conv.types IS 'Acceptable Cloud types';


--
-- Name: COLUMN obscodes_cloud_type_conv.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_type_conv.change_user IS 'User of last change';


--
-- Name: COLUMN obscodes_cloud_type_conv.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_type_conv.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN obscodes_cloud_type_conv.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_cloud_type_conv.insert_datetime IS 'Timestamp of insert';


--
-- Name: obscodes_visibility_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obscodes_visibility_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obscodes_visibility_id OWNER TO clidegui;

--
-- Name: SEQUENCE obscodes_visibility_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obscodes_visibility_id IS 'PK sequence for obscodes_visibility';


--
-- Name: obscodes_visibility; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obscodes_visibility (
    id integer DEFAULT nextval('public.obscodes_visibility_id'::regclass) NOT NULL,
    non_aero_scale character varying(2) NOT NULL,
    distance_km numeric(5,2),
    distance_yards numeric(7,0),
    valid_aero_codes character varying(100),
    code character(1),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone
);


ALTER TABLE public.obscodes_visibility OWNER TO clidegui;

--
-- Name: TABLE obscodes_visibility; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obscodes_visibility IS 'Visibility conversions: Aero, non-Aero, Km, yards. WMO 4300';


--
-- Name: COLUMN obscodes_visibility.non_aero_scale; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_visibility.non_aero_scale IS 'Visibility non-Aero scale';


--
-- Name: COLUMN obscodes_visibility.distance_km; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_visibility.distance_km IS 'Distance in Km';


--
-- Name: COLUMN obscodes_visibility.distance_yards; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_visibility.distance_yards IS 'Distance in Yards';


--
-- Name: COLUMN obscodes_visibility.valid_aero_codes; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_visibility.valid_aero_codes IS 'Valid Aero codes, comma sep';


--
-- Name: COLUMN obscodes_visibility.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_visibility.change_user IS 'User of last change';


--
-- Name: COLUMN obscodes_visibility.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_visibility.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN obscodes_visibility.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_visibility.insert_datetime IS 'Timestamp of insert';


--
-- Name: obscodes_wind_dir_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obscodes_wind_dir_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obscodes_wind_dir_id OWNER TO clidegui;

--
-- Name: SEQUENCE obscodes_wind_dir_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obscodes_wind_dir_id IS 'PK sequence for obscodes_wind_dir';


--
-- Name: obscodes_wind_dir; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obscodes_wind_dir (
    id integer DEFAULT nextval('public.obscodes_wind_dir_id'::regclass) NOT NULL,
    compass character varying(6) NOT NULL,
    degrees numeric(3,0),
    low_degrees numeric(5,2),
    high_degrees numeric(5,2),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone
);


ALTER TABLE public.obscodes_wind_dir OWNER TO clidegui;

--
-- Name: TABLE obscodes_wind_dir; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obscodes_wind_dir IS 'Wind Direction conversions: Compass points to degrees';


--
-- Name: COLUMN obscodes_wind_dir.compass; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_dir.compass IS 'Compass points: NNE, SE, CLM,';


--
-- Name: COLUMN obscodes_wind_dir.degrees; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_dir.degrees IS 'Degrees (0-360)';


--
-- Name: COLUMN obscodes_wind_dir.low_degrees; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_dir.low_degrees IS 'Lower bound in degrees (>)';


--
-- Name: COLUMN obscodes_wind_dir.high_degrees; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_dir.high_degrees IS 'Upper bound in degrees (<=)';


--
-- Name: COLUMN obscodes_wind_dir.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_dir.change_user IS 'User of last change';


--
-- Name: COLUMN obscodes_wind_dir.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_dir.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN obscodes_wind_dir.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_dir.insert_datetime IS 'Timestamp of insert';


--
-- Name: obscodes_wind_speed_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obscodes_wind_speed_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obscodes_wind_speed_id OWNER TO clidegui;

--
-- Name: SEQUENCE obscodes_wind_speed_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obscodes_wind_speed_id IS 'PK sequence for obscodes_wind_speed';


--
-- Name: obscodes_wind_speed; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obscodes_wind_speed (
    id integer DEFAULT nextval('public.obscodes_wind_speed_id'::regclass) NOT NULL,
    code_bft character varying(2) NOT NULL,
    ms numeric(5,2),
    low_ms numeric(5,2),
    high_ms numeric(5,2),
    low_knots numeric(5,2),
    high_knots numeric(5,2),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone
);


ALTER TABLE public.obscodes_wind_speed OWNER TO clidegui;

--
-- Name: TABLE obscodes_wind_speed; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obscodes_wind_speed IS 'Wind speed conversions: Beaufort, m/s, knots';


--
-- Name: COLUMN obscodes_wind_speed.code_bft; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_speed.code_bft IS 'Beaufort code';


--
-- Name: COLUMN obscodes_wind_speed.ms; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_speed.ms IS 'M/S';


--
-- Name: COLUMN obscodes_wind_speed.low_ms; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_speed.low_ms IS 'Lower bound in M/S';


--
-- Name: COLUMN obscodes_wind_speed.high_ms; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_speed.high_ms IS 'Upper bound in M/S';


--
-- Name: COLUMN obscodes_wind_speed.low_knots; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_speed.low_knots IS 'Lower bound in Knots';


--
-- Name: COLUMN obscodes_wind_speed.high_knots; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_speed.high_knots IS 'Upper bound in Knots';


--
-- Name: COLUMN obscodes_wind_speed.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_speed.change_user IS 'User of last change';


--
-- Name: COLUMN obscodes_wind_speed.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_speed.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN obscodes_wind_speed.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wind_speed.insert_datetime IS 'Timestamp of insert';


--
-- Name: obscodes_wx_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obscodes_wx_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obscodes_wx_id OWNER TO clidegui;

--
-- Name: SEQUENCE obscodes_wx_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obscodes_wx_id IS 'PK sequence for obscodes_wx';


--
-- Name: obscodes_wx; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obscodes_wx (
    id integer DEFAULT nextval('public.obscodes_wx_id'::regclass) NOT NULL,
    code character varying(2) NOT NULL,
    name character varying(40),
    description character varying(200),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone
);


ALTER TABLE public.obscodes_wx OWNER TO clidegui;

--
-- Name: TABLE obscodes_wx; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obscodes_wx IS 'WMO Code 4677 (WX codes)';


--
-- Name: COLUMN obscodes_wx.code; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wx.code IS 'WMO 4677 code';


--
-- Name: COLUMN obscodes_wx.name; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wx.name IS 'Name of phenomenon';


--
-- Name: COLUMN obscodes_wx.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wx.description IS 'Description of phenomenon';


--
-- Name: COLUMN obscodes_wx.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wx.change_user IS 'User of last change';


--
-- Name: COLUMN obscodes_wx.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wx.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN obscodes_wx.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obscodes_wx.insert_datetime IS 'Timestamp of insert';


--
-- Name: obsconv_factors_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.obsconv_factors_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.obsconv_factors_id OWNER TO clidegui;

--
-- Name: SEQUENCE obsconv_factors_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.obsconv_factors_id IS 'PK sequence for obsconv_factors';


--
-- Name: obsconv_factors; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.obsconv_factors (
    id integer DEFAULT nextval('public.obsconv_factors_id'::regclass) NOT NULL,
    from_type character varying(20) NOT NULL,
    to_type character varying(20) NOT NULL,
    pre_sum numeric(5,2),
    mult_factor numeric(7,4) NOT NULL,
    post_sum numeric(7,4),
    change_user character varying(10),
    change_datetime timestamp without time zone,
    insert_datetime timestamp without time zone NOT NULL
);


ALTER TABLE public.obsconv_factors OWNER TO clidegui;

--
-- Name: TABLE obsconv_factors; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.obsconv_factors IS 'WMO Code 4677 (WX codes)';


--
-- Name: COLUMN obsconv_factors.from_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obsconv_factors.from_type IS 'From unit (eg. Fahrenheit, Inches)';


--
-- Name: COLUMN obsconv_factors.to_type; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obsconv_factors.to_type IS 'To unit (eg. Celsius, mm)';


--
-- Name: COLUMN obsconv_factors.pre_sum; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obsconv_factors.pre_sum IS 'Value to add prior to multiplying conversion factor';


--
-- Name: COLUMN obsconv_factors.mult_factor; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obsconv_factors.mult_factor IS 'Conversion factor. Multiplied by From.';


--
-- Name: COLUMN obsconv_factors.post_sum; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obsconv_factors.post_sum IS 'Value to add after multiplying conversion factor.';


--
-- Name: COLUMN obsconv_factors.change_user; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obsconv_factors.change_user IS 'User of last change';


--
-- Name: COLUMN obsconv_factors.change_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obsconv_factors.change_datetime IS 'Timestamp of last change';


--
-- Name: COLUMN obsconv_factors.insert_datetime; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.obsconv_factors.insert_datetime IS 'Timestamp of insert';


--
-- Name: pivot; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.pivot (
    i integer NOT NULL
);


ALTER TABLE public.pivot OWNER TO clidegui;

--
-- Name: TABLE pivot; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.pivot IS 'Utility table of sequential integers';


--
-- Name: spatial_ref_sys; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.spatial_ref_sys (
    srid integer NOT NULL,
    auth_name character varying(256),
    auth_srid integer,
    srtext character varying(2048),
    proj4text character varying(2048)
);


ALTER TABLE public.spatial_ref_sys OWNER TO clidegui;

--
-- Name: TABLE spatial_ref_sys; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.spatial_ref_sys IS 'Spatial reference system definitions from PostGIS';


--
-- Name: station_contacts_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_contacts_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_contacts_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_contacts_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_contacts_id IS 'PK sequence for station contacts';


--
-- Name: station_contacts; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_contacts (
    id integer DEFAULT nextval('public.station_contacts_id'::regclass) NOT NULL,
    station_id integer NOT NULL,
    title character varying(50),
    name character varying(50),
    addr1 character varying(50),
    addr2 character varying(50),
    addr3 character varying(50),
    addr4 character varying(50),
    town character varying(50),
    state character varying(50),
    country character varying(50),
    postcode character varying(10),
    home_phone character varying(20),
    work_phone character varying(20),
    mob_phone character varying(20),
    email character varying(100),
    fax character varying(20),
    comments character varying(4000),
    start_date date,
    end_date date
);


ALTER TABLE public.station_contacts OWNER TO clidegui;

--
-- Name: TABLE station_contacts; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_contacts IS 'Stores contacts (people) for station';


--
-- Name: COLUMN station_contacts.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_contacts.id IS 'Surrogate Key';


--
-- Name: COLUMN station_contacts.station_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_contacts.station_id IS 'Station ID of station contact';


--
-- Name: station_files_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.station_files_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_files_id OWNER TO clidegui;

--
-- Name: SEQUENCE station_files_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.station_files_id IS 'PK sequence for station files';


--
-- Name: station_files; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.station_files (
    id integer DEFAULT nextval('public.station_files_id'::regclass) NOT NULL,
    station_id integer NOT NULL,
    title character varying(50),
    description character varying(1000),
    file_path character varying(200)
);


ALTER TABLE public.station_files OWNER TO clidegui;

--
-- Name: TABLE station_files; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.station_files IS 'Stores address of files such as images, pdfs, Word docs, etc. for station.';


--
-- Name: COLUMN station_files.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_files.id IS 'Surrogate Key';


--
-- Name: COLUMN station_files.station_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_files.station_id IS 'ID of station this row belongs to';


--
-- Name: COLUMN station_files.title; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_files.title IS 'Title of file';


--
-- Name: COLUMN station_files.description; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_files.description IS 'Description of file';


--
-- Name: COLUMN station_files.file_path; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.station_files.file_path IS 'Full path to file.';


--
-- Name: timezone_diffs_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.timezone_diffs_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.timezone_diffs_id OWNER TO clidegui;

--
-- Name: SEQUENCE timezone_diffs_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.timezone_diffs_id IS 'PK sequence for timezone diffs';


--
-- Name: timezone_diffs; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.timezone_diffs (
    id integer DEFAULT nextval('public.timezone_diffs_id'::regclass) NOT NULL,
    start_timestamp timestamp without time zone NOT NULL,
    end_timestamp timestamp without time zone NOT NULL,
    tm_zone character varying(3) NOT NULL,
    tm_diff numeric(4,1)
);


ALTER TABLE public.timezone_diffs OWNER TO clidegui;

--
-- Name: TABLE timezone_diffs; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.timezone_diffs IS 'Stores timezone differences due to daylight savings';


--
-- Name: COLUMN timezone_diffs.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.timezone_diffs.id IS 'Surrogate Key';


--
-- Name: COLUMN timezone_diffs.start_timestamp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.timezone_diffs.start_timestamp IS 'Date time difference starts';


--
-- Name: COLUMN timezone_diffs.end_timestamp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.timezone_diffs.end_timestamp IS 'Date time difference ends';


--
-- Name: COLUMN timezone_diffs.tm_zone; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.timezone_diffs.tm_zone IS 'Time zone where difference applies';


--
-- Name: COLUMN timezone_diffs.tm_diff; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.timezone_diffs.tm_diff IS 'UTC offset during this period';


--
-- Name: user_sessions_id; Type: SEQUENCE; Schema: public; Owner: clidegui
--

CREATE SEQUENCE public.user_sessions_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_sessions_id OWNER TO clidegui;

--
-- Name: SEQUENCE user_sessions_id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON SEQUENCE public.user_sessions_id IS 'PK sequence for user_sessions';


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: clidegui
--

CREATE TABLE public.user_sessions (
    id integer DEFAULT nextval('public.user_sessions_id'::regclass) NOT NULL,
    username character varying(20) NOT NULL,
    environment character varying(20) NOT NULL,
    ip_addr character varying(20),
    start_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    end_timestamp timestamp without time zone,
    logout_flag character(1),
    timeout_flag character(1),
    killed_flag character(1)
);


ALTER TABLE public.user_sessions OWNER TO clidegui;

--
-- Name: TABLE user_sessions; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON TABLE public.user_sessions IS 'Stores User session information';


--
-- Name: COLUMN user_sessions.id; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.user_sessions.id IS 'Surrogate Key';


--
-- Name: COLUMN user_sessions.username; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.user_sessions.username IS 'Login username';


--
-- Name: COLUMN user_sessions.ip_addr; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.user_sessions.ip_addr IS 'IP of client';


--
-- Name: COLUMN user_sessions.start_timestamp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.user_sessions.start_timestamp IS 'Start of session';


--
-- Name: COLUMN user_sessions.end_timestamp; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.user_sessions.end_timestamp IS 'End of session';


--
-- Name: COLUMN user_sessions.timeout_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.user_sessions.timeout_flag IS 'Session ended by timeout';


--
-- Name: COLUMN user_sessions.killed_flag; Type: COMMENT; Schema: public; Owner: clidegui
--

COMMENT ON COLUMN public.user_sessions.killed_flag IS 'Session ended by admin kill';


--
-- Data for Name: Abstractenvironmentalmonitoringfacility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Abstractenvironmentalmonitoringfacility" ("Description", "Extension", "Geospatiallocation", "Onlineresource", "Responsibleparty", "AbstractenvironmentalmonitoringfacilityID") FROM stdin;
\.


--
-- Data for Name: Altitude-or-depth; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Altitude-or-depth" ("Altitude-or-depthID") FROM stdin;
\.


--
-- Data for Name: Altitudeordepthtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Altitudeordepthtype" ("AltitudeordepthtypeID") FROM stdin;
\.


--
-- Data for Name: Application-area; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Application-area" ("Application-areaID") FROM stdin;
\.


--
-- Data for Name: Applicationareatype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Applicationareatype" ("ApplicationareatypeID") FROM stdin;
\.


--
-- Data for Name: Attribution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Attribution" ("Originator", "Originatorurl", "Source", "Title", "AttributionID") FROM stdin;
\.


--
-- Data for Name: Climate-zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Climate-zone" ("Climate-zoneID") FROM stdin;
\.


--
-- Data for Name: Climatezone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Climatezone" ("Climatezone", "Validperiod", "ClimatezoneID") FROM stdin;
\.


--
-- Data for Name: Climatezonetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Climatezonetype" ("ClimatezonetypeID") FROM stdin;
\.


--
-- Data for Name: Communication-method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Communication-method" ("Communication-methodID") FROM stdin;
\.


--
-- Data for Name: Controlchecklocationtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Controlchecklocationtype" ("ControlchecklocationtypeID") FROM stdin;
\.


--
-- Data for Name: Controlcheckreport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Controlcheckreport" ("Alternateuri", "Checklocation", "Controlcheckresult", "Periodofvalidity", "Standardname", "Standardserialnumber", "Standardtype", "Withinverificationlimit", "ControlcheckreportID") FROM stdin;
\.


--
-- Data for Name: Controlstandardtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Controlstandardtype" ("ControlstandardtypeID") FROM stdin;
\.


--
-- Data for Name: Coordinatereferencesystemtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Coordinatereferencesystemtype" ("CoordinatereferencesystemtypeID") FROM stdin;
\.


--
-- Data for Name: Coordinatesreferencesystemtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Coordinatesreferencesystemtype" ("CoordinatesreferencesystemtypeID") FROM stdin;
\.


--
-- Data for Name: Data-format; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Data-format" ("Data-formatID") FROM stdin;
\.


--
-- Data for Name: Data-use-constraints; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Data-use-constraints" ("Data-use-constraintsID") FROM stdin;
\.


--
-- Data for Name: Datacommunicationmethodtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Datacommunicationmethodtype" ("DatacommunicationmethodtypeID") FROM stdin;
\.


--
-- Data for Name: Dataformattype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Dataformattype" ("DataformattypeID") FROM stdin;
\.


--
-- Data for Name: Datageneration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Datageneration" ("Validperiod", "DatagenerationID", "DeploymentID") FROM stdin;
\.


--
-- Data for Name: Datapolicy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Datapolicy" ("Attribution", "Datapolicy", "DatapolicyID") FROM stdin;
\.


--
-- Data for Name: Datapolicytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Datapolicytype" ("DatapolicytypeID") FROM stdin;
\.


--
-- Data for Name: Deployment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Deployment" ("Applicationarea", "Communicationmethod", "Configuration", "Controlschedule", "Exposure", "Heightabovelocalreferencesurface", "Instrumentoperatingstatus", "Localreferencesurface", "Maintenanceschedule", "Representativeness", "Sourceofobservation", "Validperiod", "DeploymentID", "ProcessID") FROM stdin;
\.


--
-- Data for Name: Deployment-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Deployment-valid" ("Deployment-validID") FROM stdin;
\.


--
-- Data for Name: Description; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Description" ("Description", "Validperiod", "DescriptionID") FROM stdin;
\.


--
-- Data for Name: Equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Equipment" ("Driftperunittime", "Firmwareversion", "Manufacturer", "Model", "Observablerange", "Observingmethod", "Observingmethoddetails", "Serialnumber", "Specificationlink", "Specifiedabsoluteuncertainty", "Specifiedrelativeuncertainty", "Subequipment", "Uncertaintyevalproc", "EquipmentID", "DeploymentID", facility) FROM stdin;
\.


--
-- Data for Name: Equipment-log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Equipment-log" ("Equipment-log", "Equipment-logID") FROM stdin;
\.


--
-- Data for Name: Equipment-log-entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Equipment-log-entries" ("Equipment-log-entriesID") FROM stdin;
\.


--
-- Data for Name: Equipment-log-entries-control-location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Equipment-log-entries-control-location" ("Equipment-log-entries-control-locationID") FROM stdin;
\.


--
-- Data for Name: Equipment-log-entries-control-result; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Equipment-log-entries-control-result" ("Equipment-log-entries-control-resultID") FROM stdin;
\.


--
-- Data for Name: Equipment-log-entries-control-standard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Equipment-log-entries-control-standard" ("Equipment-log-entries-control-standardID") FROM stdin;
\.


--
-- Data for Name: Equipment-log-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Equipment-log-valid" ("Equipment-log-validID") FROM stdin;
\.


--
-- Data for Name: Equipment-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Equipment-valid" ("Equipment-validID") FROM stdin;
\.


--
-- Data for Name: EquipmentEquipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."EquipmentEquipment" ("subEquipment", "EquipmentID") FROM stdin;
\.


--
-- Data for Name: Equipmentlog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Equipmentlog" ("EquipmentlogID", equipment) FROM stdin;
\.


--
-- Data for Name: Eventreport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Eventreport" ("Typeofevent", "Validperiod", "EventreportID") FROM stdin;
\.


--
-- Data for Name: Eventtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Eventtype" ("EventtypeID") FROM stdin;
\.


--
-- Data for Name: Exposure; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Exposure" ("ExposureID") FROM stdin;
\.


--
-- Data for Name: Exposuretype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Exposuretype" ("ExposuretypeID") FROM stdin;
\.


--
-- Data for Name: Facility-log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Facility-log" ("Facility-log", "Facility-logID") FROM stdin;
\.


--
-- Data for Name: Facility-log-entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Facility-log-entries" ("Facility-log-entriesID") FROM stdin;
\.


--
-- Data for Name: Facility-log-entries-event-type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Facility-log-entries-event-type" ("Facility-log-entries-event-typeID") FROM stdin;
\.


--
-- Data for Name: Facility-log-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Facility-log-valid" ("Facility-log-validID") FROM stdin;
\.


--
-- Data for Name: Facility-type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Facility-type" ("Facility-typeID") FROM stdin;
\.


--
-- Data for Name: Facility-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Facility-valid" ("Facility-validID") FROM stdin;
\.


--
-- Data for Name: FacilitySetObservingFacility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."FacilitySetObservingFacility" (facility, "facilitySet") FROM stdin;
\.


--
-- Data for Name: Facilitylog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Facilitylog" ("FacilitylogID", facility) FROM stdin;
\.


--
-- Data for Name: Facilityset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Facilityset" ("FacilitysetID") FROM stdin;
\.


--
-- Data for Name: Frequencies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Frequencies" ("Bandwidth", "Channel", "Frequency", "Frequencyuse", "Polarization", "Purposeoffrequencyuse", "Transmissionmode", "FrequenciesID", "EquipmentID") FROM stdin;
\.


--
-- Data for Name: Frequencyusetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Frequencyusetype" ("FrequencyusetypeID") FROM stdin;
\.


--
-- Data for Name: Geopositioning-method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Geopositioning-method" ("Geopositioning-methodID") FROM stdin;
\.


--
-- Data for Name: Geopositioningmethodtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Geopositioningmethodtype" ("GeopositioningmethodtypeID") FROM stdin;
\.


--
-- Data for Name: Geospatiallocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Geospatiallocation" ("Coordinatereferencesystem", "Geolocation", "Geopositioningmethod", "Validperiod", "GeospatiallocationID") FROM stdin;
\.


--
-- Data for Name: Header; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Header" ("Filedatetime", "Recordowner", "Version", "HeaderID") FROM stdin;
\.


--
-- Data for Name: Instrument-operating-status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Instrument-operating-status" ("Instrument-operating-statusID") FROM stdin;
\.


--
-- Data for Name: Instrumentcontrolresulttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Instrumentcontrolresulttype" ("InstrumentcontrolresulttypeID") FROM stdin;
\.


--
-- Data for Name: Instrumentcontrolscheduletype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Instrumentcontrolscheduletype" ("InstrumentcontrolscheduletypeID") FROM stdin;
\.


--
-- Data for Name: Instrumentoperatingstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Instrumentoperatingstatus" ("Instrumentoperatingstatus", "Validperiod", "InstrumentoperatingstatusID") FROM stdin;
\.


--
-- Data for Name: Instrumentoperatingstatustype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Instrumentoperatingstatustype" ("InstrumentoperatingstatustypeID") FROM stdin;
\.


--
-- Data for Name: Level-of-data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Level-of-data" ("Level-of-dataID") FROM stdin;
\.


--
-- Data for Name: Levelofdatatype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Levelofdatatype" ("LevelofdatatypeID") FROM stdin;
\.


--
-- Data for Name: Local-topography; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Local-topography" ("Local-topographyID") FROM stdin;
\.


--
-- Data for Name: Localreferencesurfacetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Localreferencesurfacetype" ("LocalreferencesurfacetypeID") FROM stdin;
\.


--
-- Data for Name: Localtopographytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Localtopographytype" ("LocaltopographytypeID") FROM stdin;
\.


--
-- Data for Name: Log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Log" ("Logentry", "LogID") FROM stdin;
\.


--
-- Data for Name: Logentry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Logentry" ("Author", "Datetime", "Description", "Documentationurl", "LogentryID") FROM stdin;
\.


--
-- Data for Name: Maintenancereport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Maintenancereport" ("Maintenanceparty", "MaintenancereportID") FROM stdin;
\.


--
-- Data for Name: Measurementunittype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Measurementunittype" ("MeasurementunittypeID") FROM stdin;
\.


--
-- Data for Name: Metadata-record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Metadata-record" ("Metadata-record", "Metadata-recordID") FROM stdin;
\.


--
-- Data for Name: Observation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observation" ("Observation-segment", "ObservationID") FROM stdin;
\.


--
-- Data for Name: Observation-feature-of-interest; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observation-feature-of-interest" ("Observation-feature-of-interestID") FROM stdin;
\.


--
-- Data for Name: Observation-observed-property; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observation-observed-property" ("Observation-observed-propertyID") FROM stdin;
\.


--
-- Data for Name: Observation-process; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observation-process" ("Observation-processID") FROM stdin;
\.


--
-- Data for Name: Observation-result; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observation-result" ("Observation-resultID") FROM stdin;
\.


--
-- Data for Name: Observation-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observation-valid" ("Observation-validID") FROM stdin;
\.


--
-- Data for Name: Observedvariabletype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observedvariabletype" ("ObservedvariabletypeID") FROM stdin;
\.


--
-- Data for Name: Observing-facility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observing-facility" ("Observing-facility", "Observing-facilityID") FROM stdin;
\.


--
-- Data for Name: Observing-method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observing-method" ("Observing-methodID") FROM stdin;
\.


--
-- Data for Name: Observingcapability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observingcapability" ("Observation", "Programaffiliation", "ObservingcapabilityID", facility) FROM stdin;
\.


--
-- Data for Name: Observingfacility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observingfacility" ("Climatezone", "Dateclosed", "Dateestablished", "Facilitytype", "Population", "Programaffiliation", "Surfacecover", "Surfaceroughness", "Territory", "Timezone", "Topographybathymetry", "Wmoregion", "ObservingfacilityID") FROM stdin;
\.


--
-- Data for Name: Observingfacilitytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observingfacilitytype" ("ObservingfacilitytypeID") FROM stdin;
\.


--
-- Data for Name: Observingmethodtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Observingmethodtype" ("ObservingmethodtypeID") FROM stdin;
\.


--
-- Data for Name: Polarizationtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Polarizationtype" ("PolarizationtypeID") FROM stdin;
\.


--
-- Data for Name: Population; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Population" ("Population10km", "Population50km", "Validperiod", "PopulationID") FROM stdin;
\.


--
-- Data for Name: Process; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Process" ("Process", "ProcessID") FROM stdin;
\.


--
-- Data for Name: Process-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Process-valid" ("Process-validID") FROM stdin;
\.


--
-- Data for Name: Processing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Processing" ("Aggregationperiod", "Dataprocessing", "Processingcentre", "Softwaredetails", "Softwareurl", "ProcessingID", "DatagenerationID") FROM stdin;
\.


--
-- Data for Name: Processing-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Processing-valid" ("Processing-validID") FROM stdin;
\.


--
-- Data for Name: Program-affiliation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Program-affiliation" ("Program-affiliationID") FROM stdin;
\.


--
-- Data for Name: Programaffiliation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Programaffiliation" ("Programaffiliation", "Programspecificfacilityid", "Reportingstatus", "ProgramaffiliationID") FROM stdin;
\.


--
-- Data for Name: Programornetworkaffiliationtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Programornetworkaffiliationtype" ("ProgramornetworkaffiliationtypeID") FROM stdin;
\.


--
-- Data for Name: Purposeoffrequencyusetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Purposeoffrequencyusetype" ("PurposeoffrequencyusetypeID") FROM stdin;
\.


--
-- Data for Name: Qualityflagtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Qualityflagtype" ("QualityflagtypeID") FROM stdin;
\.


--
-- Data for Name: Record-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Record-valid" ("Record-validID") FROM stdin;
\.


--
-- Data for Name: Reference-time; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Reference-time" ("Reference-timeID") FROM stdin;
\.


--
-- Data for Name: Referencetimetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Referencetimetype" ("ReferencetimetypeID") FROM stdin;
\.


--
-- Data for Name: Relative-elevation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Relative-elevation" ("Relative-elevationID") FROM stdin;
\.


--
-- Data for Name: Relativeelevationtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Relativeelevationtype" ("RelativeelevationtypeID") FROM stdin;
\.


--
-- Data for Name: Reporting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Reporting" ("Dataformat", "Dataformatversion", "Datapolicy", "Internationalexchange", "Levelofdata", "Numberofobservationsinreportinginterval", "Numericalresolution", "Officialstatus", "Referencedatum", "Referencetimesource", "Spatialreportinginterval", "Temporalreportinginterval", "Timeliness", "Timestampmeaning", "Uom", "ReportingID", "DatagenerationID") FROM stdin;
\.


--
-- Data for Name: Reporting-status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Reporting-status" ("Reporting-statusID") FROM stdin;
\.


--
-- Data for Name: Reporting-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Reporting-valid" ("Reporting-validID") FROM stdin;
\.


--
-- Data for Name: Reportingstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Reportingstatus" ("Reportingstatus", "Validperiod", "ReportingstatusID") FROM stdin;
\.


--
-- Data for Name: Reportingstatustype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Reportingstatustype" ("ReportingstatustypeID") FROM stdin;
\.


--
-- Data for Name: Representativeness; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Representativeness" ("RepresentativenessID") FROM stdin;
\.


--
-- Data for Name: Representativenesstype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Representativenesstype" ("RepresentativenesstypeID") FROM stdin;
\.


--
-- Data for Name: Responsibleparty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Responsibleparty" ("Responsibleparty", "Validperiod", "ResponsiblepartyID") FROM stdin;
\.


--
-- Data for Name: Resultset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Resultset" ("Distributioninfo", "ResultsetID") FROM stdin;
\.


--
-- Data for Name: Sampletreatmenttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Sampletreatmenttype" ("SampletreatmenttypeID") FROM stdin;
\.


--
-- Data for Name: Sampling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Sampling" ("Samplespertimeperiod", "Sampletreatment", "Samplingprocedure", "Samplingproceduredescription", "Samplingstrategy", "Samplingtimeperiod", "Spatialsamplingresolution", "Spatialsamplingresolutiondetails", "Temporalsamplinginterval", "SamplingID", "DatagenerationID") FROM stdin;
\.


--
-- Data for Name: Sampling-strategy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Sampling-strategy" ("Sampling-strategyID") FROM stdin;
\.


--
-- Data for Name: Sampling-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Sampling-valid" ("Sampling-validID") FROM stdin;
\.


--
-- Data for Name: Samplingproceduretype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Samplingproceduretype" ("SamplingproceduretypeID") FROM stdin;
\.


--
-- Data for Name: Samplingstrategytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Samplingstrategytype" ("SamplingstrategytypeID") FROM stdin;
\.


--
-- Data for Name: Schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Schedule" ("Diurnalbasetime", "Endhour", "Endminute", "Endmonth", "Endweekday", "Starthour", "Startminute", "Startmonth", "Startweekday", "ScheduleID", "DatagenerationID") FROM stdin;
\.


--
-- Data for Name: Source-of-observation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Source-of-observation" ("Source-of-observationID") FROM stdin;
\.


--
-- Data for Name: Sourceofobservationtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Sourceofobservationtype" ("SourceofobservationtypeID") FROM stdin;
\.


--
-- Data for Name: Surface-cover; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Surface-cover" ("Surface-coverID") FROM stdin;
\.


--
-- Data for Name: Surface-cover-classification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Surface-cover-classification" ("Surface-cover-classificationID") FROM stdin;
\.


--
-- Data for Name: Surface-roughness; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Surface-roughness" ("Surface-roughnessID") FROM stdin;
\.


--
-- Data for Name: Surfacecover; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Surfacecover" ("Surfacecover", "Surfacecoverclassification", "Validperiod", "SurfacecoverID") FROM stdin;
\.


--
-- Data for Name: Surfacecoverclassificationtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Surfacecoverclassificationtype" ("SurfacecoverclassificationtypeID") FROM stdin;
\.


--
-- Data for Name: Surfacecovertype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Surfacecovertype" ("SurfacecovertypeID") FROM stdin;
\.


--
-- Data for Name: Surfaceroughness; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Surfaceroughness" ("Surfaceroughness", "Validperiod", "SurfaceroughnessID") FROM stdin;
\.


--
-- Data for Name: Surfaceroughnesstype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Surfaceroughnesstype" ("SurfaceroughnesstypeID") FROM stdin;
\.


--
-- Data for Name: Territory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Territory" ("Territoryname", "Validperiod", "TerritoryID") FROM stdin;
\.


--
-- Data for Name: Territory-name; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Territory-name" ("Territory-nameID") FROM stdin;
\.


--
-- Data for Name: Territorytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Territorytype" ("TerritorytypeID") FROM stdin;
\.


--
-- Data for Name: Time-encoding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Time-encoding" ("Time-encoding", "Time-encodingID") FROM stdin;
\.


--
-- Data for Name: Time-stamp-meaning; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Time-stamp-meaning" ("Time-stamp-meaningID") FROM stdin;
\.


--
-- Data for Name: Time-zone-explicit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Time-zone-explicit" ("Time-zone-explicitID") FROM stdin;
\.


--
-- Data for Name: Timestampmeaningtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Timestampmeaningtype" ("TimestampmeaningtypeID") FROM stdin;
\.


--
-- Data for Name: Timezone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Timezone" ("Timezone", "Validperiod", "TimezoneID") FROM stdin;
\.


--
-- Data for Name: Timezonetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Timezonetype" ("TimezonetypeID") FROM stdin;
\.


--
-- Data for Name: Topographic-context; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Topographic-context" ("Topographic-contextID") FROM stdin;
\.


--
-- Data for Name: Topographiccontexttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Topographiccontexttype" ("TopographiccontexttypeID") FROM stdin;
\.


--
-- Data for Name: Topographybathymetry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Topographybathymetry" ("Altitudeordepth", "Localtopography", "Relativeelevation", "Topographiccontext", "Validperiod", "TopographybathymetryID") FROM stdin;
\.


--
-- Data for Name: Traceabilitytype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Traceabilitytype" ("TraceabilitytypeID") FROM stdin;
\.


--
-- Data for Name: Transmissionmodetype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Transmissionmodetype" ("TransmissionmodetypeID") FROM stdin;
\.


--
-- Data for Name: Uncertaintyevalproctype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Uncertaintyevalproctype" ("UncertaintyevalproctypeID") FROM stdin;
\.


--
-- Data for Name: Unique-observed-variable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Unique-observed-variable" ("Unique-observed-variableID") FROM stdin;
\.


--
-- Data for Name: Unit-of-measure; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Unit-of-measure" ("Unit-of-measureID") FROM stdin;
\.


--
-- Data for Name: Valid-local-references; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Valid-local-references" ("Valid-local-referencesID") FROM stdin;
\.


--
-- Data for Name: Well-formed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Well-formed" ("Well-formedID") FROM stdin;
\.


--
-- Data for Name: Wigosmetadatarecord; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Wigosmetadatarecord" ("Deployment", "Equipment", "Equipmentlog", "Extension", "Facility", "Facilitylog", "Facilityset", "Headerinformation", "Observation", "WigosmetadatarecordID") FROM stdin;
\.


--
-- Data for Name: Wmo-region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Wmo-region" ("Wmo-regionID") FROM stdin;
\.


--
-- Data for Name: Wmoregiontype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Wmoregiontype" ("WmoregiontypeID") FROM stdin;
\.


--
-- Data for Name: Xml-rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Xml-rules" ("Xml-rules", "Xml-rulesID") FROM stdin;
\.


--
-- Data for Name: Xsd-valid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Xsd-valid" ("Xsd-validID") FROM stdin;
\.


--
-- Data for Name: codes_simple; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.codes_simple (id, code_type, code, description, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: datums; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.datums (datum_name, description) FROM stdin;
\.


--
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.equipment (id, type, comments, version) FROM stdin;
\.


--
-- Data for Name: gui_users; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.gui_users (id, username, css_filename, layout, key, disabled, disable_date, station_maint, codes_maint, user_admin, file_ingest, key_entry, qa, products) FROM stdin;
\.


--
-- Data for Name: ingest_monitor; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.ingest_monitor (id, username, ip_addr, filename, ingest_start, ingest_end, file_recs, ingested_recs, ok_count, err_count, cancel_flag, cancel_user, change_datetime) FROM stdin;
\.


--
-- Data for Name: key_settings; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.key_settings (id, profile, obs_type, element, default_unit, disable_flag, change_user, change_datetime) FROM stdin;
\.


--
-- Data for Name: land_use; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.land_use (id, land_use_code, priority, description) FROM stdin;
\.


--
-- Data for Name: obs_aero; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_aero (id, station_no, lsd, gmt, lct, data_source, insert_datetime, change_datetime, change_user, qa_flag, comments, message_type, wind_dir, wind_dir_qa, wind_speed, wind_speed_qa, max_gust_10m, max_gust_10m_qa, cavok_or_skc, visibility, visibility_qa, pres_wea_intensity_1, pres_wea_desc_1, pres_wea_phen_1, pres_wea_1_qa, pres_wea_intensity_2, pres_wea_desc_2, pres_wea_phen_2, pres_wea_2_qa, pres_wea_intensity_3, pres_wea_desc_3, pres_wea_phen_3, pres_wea_3_qa, cloud_amt_oktas_1, cloud_amt_code_1, cloud_amt_1_qa, cloud_type_1, cloud_type_1_qa, cloud_height_code_1, cloud_height_1_qa, cloud_amt_oktas_2, cloud_amt_code_2, cloud_amt_2_qa, cloud_type_2, cloud_type_2_qa, cloud_height_code_2, cloud_height_2_qa, cloud_amt_oktas_3, cloud_amt_code_3, cloud_amt_3_qa, cloud_type_3, cloud_type_3_qa, cloud_height_code_3, cloud_height_3_qa, cloud_amt_oktas_4, cloud_amt_code_4, cloud_amt_4_qa, cloud_type_4, cloud_type_4_qa, cloud_height_code_4, cloud_height_4_qa, cloud_amt_oktas_5, cloud_amt_code_5, cloud_amt_5_qa, cloud_type_5, cloud_type_5_qa, cloud_height_code_5, cloud_height_5_qa, cloud_amt_oktas_6, cloud_amt_code_6, cloud_amt_6_qa, cloud_type_6, cloud_type_6_qa, cloud_height_code_6, cloud_height_6_qa, ceiling_clear_flag, ceiling_clear_flag_qa, air_temp, air_temp_f, air_temp_qa, dew_point, dew_point_f, dew_point_qa, qnh, qnh_inches, qnh_qa, rec_wea_desc_1, rec_wea_phen_1, rec_wea_1_qa, rec_wea_desc_2, rec_wea_phen_2, rec_wea_2_qa, rec_wea_desc_3, rec_wea_phen_3, rec_wea_3_qa, text_msg, error_flag, remarks, remarks_qa, wind_speed_knots, max_gust_10m_knots, visibility_miles) FROM stdin;
\.


--
-- Data for Name: obs_audit; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_audit (id, table_name, row_id, column_name, column_value, change_user, datetime) FROM stdin;
\.


--
-- Data for Name: obs_averages; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_averages (id, insert_datetime, change_datetime, change_user, station_no, month, name, active_normal, from_date, to_date, station_pres, msl_pres, air_temp, max_air_temp, min_air_temp, vapour_pres, rainfall, rain_days, sun_hours, missing_station_pres, missing_air_temp, missing_max_min, missing_vapour_pres, missing_rainfall, missing_sun_hours, air_temp_stddev) FROM stdin;
\.


--
-- Data for Name: obs_aws; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_aws (id, station_no, lsd, gmt, lct, insert_datetime, change_datetime, change_user, data_source, qa_flag, measure_period, mn_wind_dir_pt, mn_wind_dir_deg, mn_wind_dir_qa, mn_wind_dir_stddev, mn_wind_dir_stddev_qa, mn_wind_speed, mn_wind_speed_qa, mn_wind_speed_stddev, mn_wind_speed_stddev_qa, mn_gust_speed, mn_gust_speed_qa, mn_gust_time, mn_gust_time_qa, mn_gust_dir_pt, mn_gust_dir_deg, mn_gust_dir_qa, inst_gust_speed, inst_gust_qa, inst_gust_time, inst_gust_time_qa, inst_gust_dir_pt, inst_gust_dir_deg, inst_gust_dir_qa, mn_temp, mn_temp_qa, mn_temp_subaveraging, mn_temp_subaveraging_period, mn_temp_subaveraging_qa, max_temp, max_temp_time, max_temp_time_qa, max_temp_qa, min_temp, min_temp_qa, min_temp_time, min_temp_time_qa, min_grass_temp, min_grass_temp_qa, min_grass_temp_time, min_grass_temp_time_qa, mn_humidity, mn_humidity_qa, max_humidity, max_humidity_qa, max_humidity_time, max_humidity_time_qa, min_humidity, min_humidity_qa, min_humidity_time, min_humidity_time_qa, mn_station_pres, mn_station_pres_qa, mn_sea_level_pres, mn_sea_level_pres_qa, max_pres, max_pres_qa, max_pres_time, max_pres_time_qa, min_pres, min_pres_qa, min_pres_time, min_pres_time_qa, tot_rain, tot_rain_qa, tot_rain_two, tot_rain_two_qa, tot_sun, tot_sun_qa, tot_insolation, tot_insolation_qa, leaf_wetness, leaf_wetness_qa, mn_uv, mn_uv_qa, mn_soil_moisture_10, mn_soil_moisture_10_qa, mn_soil_temp_10, mn_soil_temp_10_qa, mn_soil_moisture_20, mn_soil_moisture_20_qa, mn_soil_temp_20, mn_soil_temp_20_qa, mn_soil_moisture_30, mn_soil_moisture_30_qa, mn_soil_temp_30, mn_soil_temp_30_qa, mn_soil_moisture_50, mn_soil_moisture_50_qa, mn_soil_temp_50, mn_soil_temp_50_qa, mn_soil_moisture_100, mn_soil_moisture_100_qa, mn_soil_temp_100, mn_soil_temp_100_qa) FROM stdin;
\.


--
-- Data for Name: obs_clicom_element_map; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_clicom_element_map (id, clicom_element, cldb_table, cldb_column, associated_col, associated_value, column_type, nominal_value) FROM stdin;
\.


--
-- Data for Name: obs_daily; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_daily (id, station_no, lsd, data_source, insert_datetime, change_datetime, change_user, qa_flag, aws_flag, comments, rain_24h, rain_24h_inches, rain_24h_period, rain_24h_type, rain_24h_count, rain_24h_qa, max_air_temp, max_air_temp_f, max_air_temp_period, max_air_temp_time, max_air_temp_qa, min_air_temp, min_air_temp_f, min_air_temp_period, min_air_temp_time, min_air_temp_qa, reg_max_air_temp, reg_max_air_temp_qa, reg_min_air_temp, reg_min_air_temp_qa, ground_temp, ground_temp_f, ground_temp_qa, max_gust_dir, max_gust_dir_qa, max_gust_speed, max_gust_speed_kts, max_gust_speed_bft, max_gust_speed_qa, max_gust_time, max_gust_time_qa, wind_run_lt10, wind_run_lt10_miles, wind_run_lt10_period, wind_run_lt10_qa, wind_run_gt10, wind_run_gt10_miles, wind_run_gt10_period, wind_run_gt10_qa, evaporation, evaporation_inches, evaporation_period, evaporation_qa, evap_water_max_temp, evap_water_max_temp_f, evap_water_max_temp_qa, evap_water_min_temp, evap_water_min_temp_f, evap_water_min_temp_qa, sunshine_duration, sunshine_duration_qa, river_height, river_height_in, river_height_qa, radiation, radiation_qa, thunder_flag, thunder_flag_qa, frost_flag, frost_flag_qa, dust_flag, dust_flag_qa, haze_flag, haze_flag_qa, fog_flag, fog_flag_qa, strong_wind_flag, strong_wind_flag_qa, gale_flag, gale_flag_qa, hail_flag, hail_flag_qa, snow_flag, snow_flag_qa, lightning_flag, lightning_flag_qa, shower_flag, shower_flag_qa, rain_flag, rain_flag_qa, dew_flag, dew_flag_qa) FROM stdin;
\.


--
-- Data for Name: obs_monthly; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_monthly (id, station_no, lsd, data_source, insert_datetime, change_datetime, change_user, qa_flag, comments, dly_max_rain, dly_max_rain_inches, dly_max_rain_date, dly_max_rain_qa, max_max_air_temp, max_max_air_temp_f, max_max_air_temp_qa, max_max_air_temp_date, min_min_air_temp, min_min_air_temp_f, min_min_air_temp_qa, min_min_air_temp_date, min_min_ground_temp, min_min_ground_temp_f, min_min_ground_temp_qa, min_min_ground_temp_date, mn_air_temp, mn_air_temp_f, mn_air_temp_qa, mn_max_air_temp, mn_max_air_temp_f, mn_max_air_temp_qa, mn_min_air_temp, mn_min_air_temp_f, mn_min_air_temp_qa, mn_wet_bulb_temp, mn_wet_bulb_temp_f, mn_wet_bulb_temp_qa, mn_min_ground_temp, mn_min_ground_temp_f, mn_min_ground_temp_qa, mn_asread_pres, mn_asread_pres_inches, mn_asread_pres_mmhg, mn_asread_pres_qa, mn_msl_pres, mn_msl_pres_inches, mn_msl_pres_mmhg, mn_msl_pres_qa, mn_station_pres, mn_station_pres_inches, mn_station_pres_mmhg, mn_station_pres_qa, mn_vapour_pres, mn_vapour_pres_inches, mn_vapour_pres_mmhg, mn_vapour_pres_qa, mn_evaporation, mn_evaporation_inches, mn_evaporation_qa, mn_rel_humidity, mn_rel_humidity_qa, mn_sun_hours, mn_sun_hours_qa, mn_tot_cloud_oktas, mn_tot_cloud_tenths, mn_tot_cloud_qa, tot_evaporation, tot_evaporation_inches, tot_evaporation_qa, tot_rain, tot_rain_inches, tot_rain_qa, tot_rain_days, tot_rain_days_qa, tot_rain_percent, tot_rain_percent_qa) FROM stdin;
\.


--
-- Data for Name: obs_subdaily; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_subdaily (id, station_no, lsd, gmt, lct, data_source, insert_datetime, change_datetime, change_user, qa_flag, aws_flag, comments, air_temp, air_temp_f, air_temp_qa, sea_water_temp, sea_water_temp_f, sea_water_temp_qa, wet_bulb, wet_bulb_f, wet_bulb_qa, dew_point, dew_point_f, dew_point_qa, rel_humidity, rel_humidity_qa, baro_temp, baro_temp_f, baro_temp_qa, pres_as_read, pres_as_read_inches, pres_as_read_qa, station_pres, station_pres_inches, station_pres_qa, msl_pres, msl_pres_inches, msl_pres_qa, vapour_pres, vapour_pres_inches, vapour_pres_qa, qnh, qnh_qa, visibility, visibility_miles, visibility_code, visibility_qa, rain_3h, rain_3h_inches, rain_3h_qa, rain_3h_hours, rain_cum, rain_cum_inches, rain_cum_qa, wind_dir, wind_dir_qa, wind_dir_std_dev, wind_dir_std_dev_qa, wind_speed, wind_speed_knots, wind_speed_mph, wind_speed_bft, wind_speed_qa, pres_weather_code, pres_weather_bft, pres_weather_qa, past_weather_code, past_weather_bft, past_weather_qa, tot_cloud_oktas, tot_cloud_tenths, tot_cloud_qa, tot_low_cloud_oktas, tot_low_cloud_tenths, tot_low_cloud_height, tot_low_cloud_qa, state_of_sea, state_of_sea_qa, state_of_swell, state_of_swell_qa, swell_direction, swell_direction_qa, sea_level, sea_level_qa, sea_level_residual, sea_level_residual_qa, sea_level_resid_adj, sea_level_resid_adj_qa, radiation, radiation_qa, sunshine, sunshine_qa, tot_low_cloud_height_feet, wind_gust_kts, wind_gust, wind_gust_qa, wind_gust_dir, wind_gust_dir_qa, river_height, river_height_in, river_height_qa, qnh_inches) FROM stdin;
\.


--
-- Data for Name: obs_subdaily_cloud_layers; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_subdaily_cloud_layers (id, sub_daily_id, data_source, insert_datetime, change_datetime, change_user, qa_flag, aws_flag, layer_no, layer_type, cloud_oktas, cloud_tenths, cloud_amt_qa, cloud_type, cloud_type_qa, cloud_height, cloud_height_feet, cloud_height_qa, cloud_dir, cloud_dir_qa) FROM stdin;
\.


--
-- Data for Name: obs_subdaily_soil_temps; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_subdaily_soil_temps (id, sub_daily_id, data_source, insert_datetime, change_datetime, change_user, qa_flag, aws_flag, soil_depth, soil_temp, soil_temp_f, soil_temp_qa) FROM stdin;
\.


--
-- Data for Name: obs_upper_air; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obs_upper_air (id, station_no, lsd, gmt, lct, data_source, insert_datetime, change_datetime, change_user, qa_flag, pressure, pressure_qa, level_type, geo_height, geo_height_qa, air_temp, air_temp_qa, dew_point, dew_point_qa, wind_direction, wind_direction_qa, wind_speed, wind_speed_qa) FROM stdin;
\.


--
-- Data for Name: obscodes_cloud_amt_conv; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obscodes_cloud_amt_conv (id, code_0501, code_2700, code_bft, tenths, oktas, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: obscodes_cloud_conv_1677; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obscodes_cloud_conv_1677 (id, code, low_feet, low_meters, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: obscodes_cloud_ht_conv; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obscodes_cloud_ht_conv (id, code, low_feet, high_feet, low_meters, high_meters, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: obscodes_cloud_type_conv; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obscodes_cloud_type_conv (id, code_0500, code_figure, wmo_table, layer, types, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: obscodes_visibility; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obscodes_visibility (id, non_aero_scale, distance_km, distance_yards, valid_aero_codes, code, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: obscodes_wind_dir; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obscodes_wind_dir (id, compass, degrees, low_degrees, high_degrees, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: obscodes_wind_speed; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obscodes_wind_speed (id, code_bft, ms, low_ms, high_ms, low_knots, high_knots, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: obscodes_wx; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obscodes_wx (id, code, name, description, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: obsconv_factors; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.obsconv_factors (id, from_type, to_type, pre_sum, mult_factor, post_sum, change_user, change_datetime, insert_datetime) FROM stdin;
\.


--
-- Data for Name: pivot; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.pivot (i) FROM stdin;
\.


--
-- Data for Name: soil_types; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.soil_types (id, soil_type, description) FROM stdin;
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: station_audit; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_audit (id, station_id, datetime, event_datetime, audit_type_id, description, event_user) FROM stdin;
\.


--
-- Data for Name: station_audit_types; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_audit_types (id, audit_type, description, system_type) FROM stdin;
\.


--
-- Data for Name: station_class; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_class (id, station_id, type_id, description, class_start, class_end) FROM stdin;
\.


--
-- Data for Name: station_contacts; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_contacts (id, station_id, title, name, addr1, addr2, addr3, addr4, town, state, country, postcode, home_phone, work_phone, mob_phone, email, fax, comments, start_date, end_date) FROM stdin;
\.


--
-- Data for Name: station_countries; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_countries (id, iso_code, description) FROM stdin;
\.


--
-- Data for Name: station_equipment; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_equipment (id, station_id, equipment_id, serial_no, asset_id, height, comments, date_start, date_end) FROM stdin;
\.


--
-- Data for Name: station_files; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_files (id, station_id, title, description, file_path) FROM stdin;
\.


--
-- Data for Name: station_status; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_status (id, status, description) FROM stdin;
\.


--
-- Data for Name: station_timezones; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_timezones (id, tm_zone, utc_diff, description) FROM stdin;
\.


--
-- Data for Name: station_types; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.station_types (id, station_type, description) FROM stdin;
\.


--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.stations (id, station_no, status_id, time_zone, id_aero, id_imo, id_marine, id_wmo, id_hydro, id_aust, id_niwa, id_niwa_agent, comments, country_code, start_date, end_date, ht_aero, ht_elev, ht_ssb, latitude, longitude, name_primary, name_secondary, region, catchment, authority, lu_0_100m, lu_100m_1km, lu_1km_10km, soil_type, surface_type, critical_river_height, location_datum, location_epsg) FROM stdin;
\.


--
-- Data for Name: surface_types; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.surface_types (id, surface_type, description) FROM stdin;
\.


--
-- Data for Name: timezone_diffs; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.timezone_diffs (id, start_timestamp, end_timestamp, tm_zone, tm_diff) FROM stdin;
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: clidegui
--

COPY public.user_sessions (id, username, environment, ip_addr, start_timestamp, end_timestamp, logout_flag, timeout_flag, killed_flag) FROM stdin;
\.


--
-- Name: codes_simple_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.codes_simple_id', 1, false);


--
-- Name: equipment_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.equipment_id', 1, false);


--
-- Name: gui_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.gui_users_id_seq', 1, false);


--
-- Name: ingest_monitor_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.ingest_monitor_id', 1, false);


--
-- Name: key_settings_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.key_settings_id', 1, false);


--
-- Name: land_use_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.land_use_id', 1, false);


--
-- Name: obs_aero_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_aero_id', 1, false);


--
-- Name: obs_audit_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_audit_id', 1, false);


--
-- Name: obs_averages_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_averages_id', 1, false);


--
-- Name: obs_aws_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_aws_id', 1, false);


--
-- Name: obs_clicom_element_map_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_clicom_element_map_id', 1, false);


--
-- Name: obs_daily_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_daily_id', 1, false);


--
-- Name: obs_monthly_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_monthly_id', 1, false);


--
-- Name: obs_subdaily_cloud_layers_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_subdaily_cloud_layers_id', 1, false);


--
-- Name: obs_subdaily_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_subdaily_id', 1, false);


--
-- Name: obs_subdaily_soil_temps_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_subdaily_soil_temps_id', 1, false);


--
-- Name: obs_upper_air_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obs_upper_air_id', 1, false);


--
-- Name: obscodes_cloud_amt_conv_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obscodes_cloud_amt_conv_id', 1, false);


--
-- Name: obscodes_cloud_conv_1677_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obscodes_cloud_conv_1677_id', 1, false);


--
-- Name: obscodes_cloud_ht_conv_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obscodes_cloud_ht_conv_id', 1, false);


--
-- Name: obscodes_cloud_type_conv_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obscodes_cloud_type_conv_id', 1, false);


--
-- Name: obscodes_visibility_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obscodes_visibility_id', 1, false);


--
-- Name: obscodes_wind_dir_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obscodes_wind_dir_id', 1, false);


--
-- Name: obscodes_wind_speed_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obscodes_wind_speed_id', 1, false);


--
-- Name: obscodes_wx_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obscodes_wx_id', 1, false);


--
-- Name: obsconv_factors_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.obsconv_factors_id', 1, false);


--
-- Name: soil_types_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.soil_types_id', 1, false);


--
-- Name: station_audit_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_audit_id', 1, false);


--
-- Name: station_audit_type_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_audit_type_id', 1, false);


--
-- Name: station_class_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_class_id', 1, false);


--
-- Name: station_contacts_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_contacts_id', 1, false);


--
-- Name: station_countries_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_countries_id', 1, false);


--
-- Name: station_equipment_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_equipment_id', 1, false);


--
-- Name: station_files_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_files_id', 1, false);


--
-- Name: station_status_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_status_id', 1, false);


--
-- Name: station_timezones_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_timezones_id', 1, false);


--
-- Name: station_types_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.station_types_id', 1, false);


--
-- Name: stations_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.stations_id', 1, false);


--
-- Name: surface_types_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.surface_types_id', 1, false);


--
-- Name: timezone_diffs_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.timezone_diffs_id', 1, false);


--
-- Name: user_sessions_id; Type: SEQUENCE SET; Schema: public; Owner: clidegui
--

SELECT pg_catalog.setval('public.user_sessions_id', 1, false);


--
-- Name: codes_simple CODES_SIMPLE_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.codes_simple
    ADD CONSTRAINT "CODES_SIMPLE_PK" PRIMARY KEY (id);


--
-- Name: equipment EQUIPMENT_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT "EQUIPMENT_PK" PRIMARY KEY (id);


--
-- Name: ingest_monitor INGEST_MONITOR_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.ingest_monitor
    ADD CONSTRAINT "INGEST_MONITOR_PK" PRIMARY KEY (id);


--
-- Name: key_settings KEY_SETTINGS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.key_settings
    ADD CONSTRAINT "KEY_SETTINGS_PK" PRIMARY KEY (id);


--
-- Name: land_use LAND_USE_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.land_use
    ADD CONSTRAINT "LAND_USE_PK" PRIMARY KEY (id);


--
-- Name: obscodes_cloud_amt_conv OBSCODES_CLOUD_AMT_CONV_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obscodes_cloud_amt_conv
    ADD CONSTRAINT "OBSCODES_CLOUD_AMT_CONV_PK" PRIMARY KEY (id);


--
-- Name: obscodes_cloud_conv_1677 OBSCODES_CLOUD_CONV_1677_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obscodes_cloud_conv_1677
    ADD CONSTRAINT "OBSCODES_CLOUD_CONV_1677_PK" PRIMARY KEY (id);


--
-- Name: obscodes_cloud_ht_conv OBSCODES_CLOUD_HT_CONV_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obscodes_cloud_ht_conv
    ADD CONSTRAINT "OBSCODES_CLOUD_HT_CONV_PK" PRIMARY KEY (id);


--
-- Name: obscodes_cloud_type_conv OBSCODES_CLOUD_TYPE_CONV_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obscodes_cloud_type_conv
    ADD CONSTRAINT "OBSCODES_CLOUD_TYPE_CONV_PK" PRIMARY KEY (id);


--
-- Name: obscodes_visibility OBSCODES_VISIBILITY_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obscodes_visibility
    ADD CONSTRAINT "OBSCODES_VISIBILITY_PK" PRIMARY KEY (id);


--
-- Name: obscodes_wind_dir OBSCODES_WIND_DIR_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obscodes_wind_dir
    ADD CONSTRAINT "OBSCODES_WIND_DIR_PK" PRIMARY KEY (id);


--
-- Name: obscodes_wind_speed OBSCODES_WIND_SPEED_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obscodes_wind_speed
    ADD CONSTRAINT "OBSCODES_WIND_SPEED_PK" PRIMARY KEY (id);


--
-- Name: obscodes_wx OBSCODES_WX_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obscodes_wx
    ADD CONSTRAINT "OBSCODES_WX_PK" PRIMARY KEY (id);


--
-- Name: obsconv_factors OBSCONV_FACTORS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obsconv_factors
    ADD CONSTRAINT "OBSCONV_FACTORS_PK" PRIMARY KEY (id);


--
-- Name: obs_aero OBS_AERO_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_aero
    ADD CONSTRAINT "OBS_AERO_PK" PRIMARY KEY (id);


--
-- Name: obs_audit OBS_AUDIT_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_audit
    ADD CONSTRAINT "OBS_AUDIT_PK" PRIMARY KEY (id);


--
-- Name: obs_averages OBS_AVERAGES_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_averages
    ADD CONSTRAINT "OBS_AVERAGES_PK" PRIMARY KEY (id);


--
-- Name: obs_aws OBS_AWS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_aws
    ADD CONSTRAINT "OBS_AWS_PK" PRIMARY KEY (id);


--
-- Name: obs_daily OBS_DAILY_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_daily
    ADD CONSTRAINT "OBS_DAILY_PK" PRIMARY KEY (id);


--
-- Name: obs_monthly OBS_MONTHLY_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_monthly
    ADD CONSTRAINT "OBS_MONTHLY_PK" PRIMARY KEY (id);


--
-- Name: obs_monthly OBS_MONTHLY_UNIQUE; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_monthly
    ADD CONSTRAINT "OBS_MONTHLY_UNIQUE" UNIQUE (station_no, lsd);


--
-- Name: obs_subdaily_cloud_layers OBS_SUBDAILY_CLOUD_LAYERS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_subdaily_cloud_layers
    ADD CONSTRAINT "OBS_SUBDAILY_CLOUD_LAYERS_PK" PRIMARY KEY (id);


--
-- Name: obs_subdaily OBS_SUBDAILY_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_subdaily
    ADD CONSTRAINT "OBS_SUBDAILY_PK" PRIMARY KEY (id);


--
-- Name: obs_subdaily_soil_temps OBS_SUBDAILY_SOIL_TEMPS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_subdaily_soil_temps
    ADD CONSTRAINT "OBS_SUBDAILY_SOIL_TEMPS_PK" PRIMARY KEY (id);


--
-- Name: obs_upper_air OBS_UPPER_AIR_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_upper_air
    ADD CONSTRAINT "OBS_UPPER_AIR_PK" PRIMARY KEY (id);


--
-- Name: Abstractenvironmentalmonitoringfacility PK_Abstractenvironmentalmonitoringfacility; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Abstractenvironmentalmonitoringfacility"
    ADD CONSTRAINT "PK_Abstractenvironmentalmonitoringfacility" PRIMARY KEY ("AbstractenvironmentalmonitoringfacilityID");


--
-- Name: Altitude-or-depth PK_Altitude-or-depth; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Altitude-or-depth"
    ADD CONSTRAINT "PK_Altitude-or-depth" PRIMARY KEY ("Altitude-or-depthID");


--
-- Name: Altitudeordepthtype PK_Altitudeordepthtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Altitudeordepthtype"
    ADD CONSTRAINT "PK_Altitudeordepthtype" PRIMARY KEY ("AltitudeordepthtypeID");


--
-- Name: Application-area PK_Application-area; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Application-area"
    ADD CONSTRAINT "PK_Application-area" PRIMARY KEY ("Application-areaID");


--
-- Name: Applicationareatype PK_Applicationareatype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Applicationareatype"
    ADD CONSTRAINT "PK_Applicationareatype" PRIMARY KEY ("ApplicationareatypeID");


--
-- Name: Attribution PK_Attribution; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Attribution"
    ADD CONSTRAINT "PK_Attribution" PRIMARY KEY ("AttributionID");


--
-- Name: Climate-zone PK_Climate-zone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Climate-zone"
    ADD CONSTRAINT "PK_Climate-zone" PRIMARY KEY ("Climate-zoneID");


--
-- Name: Climatezone PK_Climatezone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Climatezone"
    ADD CONSTRAINT "PK_Climatezone" PRIMARY KEY ("ClimatezoneID");


--
-- Name: Climatezonetype PK_Climatezonetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Climatezonetype"
    ADD CONSTRAINT "PK_Climatezonetype" PRIMARY KEY ("ClimatezonetypeID");


--
-- Name: Communication-method PK_Communication-method; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Communication-method"
    ADD CONSTRAINT "PK_Communication-method" PRIMARY KEY ("Communication-methodID");


--
-- Name: Controlchecklocationtype PK_Controlchecklocationtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Controlchecklocationtype"
    ADD CONSTRAINT "PK_Controlchecklocationtype" PRIMARY KEY ("ControlchecklocationtypeID");


--
-- Name: Controlcheckreport PK_Controlcheckreport; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Controlcheckreport"
    ADD CONSTRAINT "PK_Controlcheckreport" PRIMARY KEY ("ControlcheckreportID");


--
-- Name: Controlstandardtype PK_Controlstandardtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Controlstandardtype"
    ADD CONSTRAINT "PK_Controlstandardtype" PRIMARY KEY ("ControlstandardtypeID");


--
-- Name: Coordinatereferencesystemtype PK_Coordinatereferencesystemtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Coordinatereferencesystemtype"
    ADD CONSTRAINT "PK_Coordinatereferencesystemtype" PRIMARY KEY ("CoordinatereferencesystemtypeID");


--
-- Name: Coordinatesreferencesystemtype PK_Coordinatesreferencesystemtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Coordinatesreferencesystemtype"
    ADD CONSTRAINT "PK_Coordinatesreferencesystemtype" PRIMARY KEY ("CoordinatesreferencesystemtypeID");


--
-- Name: Data-format PK_Data-format; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Data-format"
    ADD CONSTRAINT "PK_Data-format" PRIMARY KEY ("Data-formatID");


--
-- Name: Data-use-constraints PK_Data-use-constraints; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Data-use-constraints"
    ADD CONSTRAINT "PK_Data-use-constraints" PRIMARY KEY ("Data-use-constraintsID");


--
-- Name: Datacommunicationmethodtype PK_Datacommunicationmethodtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Datacommunicationmethodtype"
    ADD CONSTRAINT "PK_Datacommunicationmethodtype" PRIMARY KEY ("DatacommunicationmethodtypeID");


--
-- Name: Dataformattype PK_Dataformattype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dataformattype"
    ADD CONSTRAINT "PK_Dataformattype" PRIMARY KEY ("DataformattypeID");


--
-- Name: Datageneration PK_Datageneration; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Datageneration"
    ADD CONSTRAINT "PK_Datageneration" PRIMARY KEY ("DatagenerationID");


--
-- Name: Datapolicy PK_Datapolicy; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Datapolicy"
    ADD CONSTRAINT "PK_Datapolicy" PRIMARY KEY ("DatapolicyID");


--
-- Name: Datapolicytype PK_Datapolicytype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Datapolicytype"
    ADD CONSTRAINT "PK_Datapolicytype" PRIMARY KEY ("DatapolicytypeID");


--
-- Name: Deployment PK_Deployment; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deployment"
    ADD CONSTRAINT "PK_Deployment" PRIMARY KEY ("DeploymentID");


--
-- Name: Deployment-valid PK_Deployment-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deployment-valid"
    ADD CONSTRAINT "PK_Deployment-valid" PRIMARY KEY ("Deployment-validID");


--
-- Name: Description PK_Description; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Description"
    ADD CONSTRAINT "PK_Description" PRIMARY KEY ("DescriptionID");


--
-- Name: Equipment PK_Equipment; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment"
    ADD CONSTRAINT "PK_Equipment" PRIMARY KEY ("EquipmentID");


--
-- Name: Equipment-log PK_Equipment-log; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment-log"
    ADD CONSTRAINT "PK_Equipment-log" PRIMARY KEY ("Equipment-logID");


--
-- Name: Equipment-log-entries PK_Equipment-log-entries; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment-log-entries"
    ADD CONSTRAINT "PK_Equipment-log-entries" PRIMARY KEY ("Equipment-log-entriesID");


--
-- Name: Equipment-log-entries-control-location PK_Equipment-log-entries-control-location; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment-log-entries-control-location"
    ADD CONSTRAINT "PK_Equipment-log-entries-control-location" PRIMARY KEY ("Equipment-log-entries-control-locationID");


--
-- Name: Equipment-log-entries-control-result PK_Equipment-log-entries-control-result; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment-log-entries-control-result"
    ADD CONSTRAINT "PK_Equipment-log-entries-control-result" PRIMARY KEY ("Equipment-log-entries-control-resultID");


--
-- Name: Equipment-log-entries-control-standard PK_Equipment-log-entries-control-standard; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment-log-entries-control-standard"
    ADD CONSTRAINT "PK_Equipment-log-entries-control-standard" PRIMARY KEY ("Equipment-log-entries-control-standardID");


--
-- Name: Equipment-log-valid PK_Equipment-log-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment-log-valid"
    ADD CONSTRAINT "PK_Equipment-log-valid" PRIMARY KEY ("Equipment-log-validID");


--
-- Name: Equipment-valid PK_Equipment-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment-valid"
    ADD CONSTRAINT "PK_Equipment-valid" PRIMARY KEY ("Equipment-validID");


--
-- Name: Equipmentlog PK_Equipmentlog; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipmentlog"
    ADD CONSTRAINT "PK_Equipmentlog" PRIMARY KEY ("EquipmentlogID");


--
-- Name: Eventreport PK_Eventreport; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Eventreport"
    ADD CONSTRAINT "PK_Eventreport" PRIMARY KEY ("EventreportID");


--
-- Name: Eventtype PK_Eventtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Eventtype"
    ADD CONSTRAINT "PK_Eventtype" PRIMARY KEY ("EventtypeID");


--
-- Name: Exposure PK_Exposure; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Exposure"
    ADD CONSTRAINT "PK_Exposure" PRIMARY KEY ("ExposureID");


--
-- Name: Exposuretype PK_Exposuretype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Exposuretype"
    ADD CONSTRAINT "PK_Exposuretype" PRIMARY KEY ("ExposuretypeID");


--
-- Name: Facility-log PK_Facility-log; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facility-log"
    ADD CONSTRAINT "PK_Facility-log" PRIMARY KEY ("Facility-logID");


--
-- Name: Facility-log-entries PK_Facility-log-entries; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facility-log-entries"
    ADD CONSTRAINT "PK_Facility-log-entries" PRIMARY KEY ("Facility-log-entriesID");


--
-- Name: Facility-log-entries-event-type PK_Facility-log-entries-event-type; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facility-log-entries-event-type"
    ADD CONSTRAINT "PK_Facility-log-entries-event-type" PRIMARY KEY ("Facility-log-entries-event-typeID");


--
-- Name: Facility-log-valid PK_Facility-log-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facility-log-valid"
    ADD CONSTRAINT "PK_Facility-log-valid" PRIMARY KEY ("Facility-log-validID");


--
-- Name: Facility-type PK_Facility-type; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facility-type"
    ADD CONSTRAINT "PK_Facility-type" PRIMARY KEY ("Facility-typeID");


--
-- Name: Facility-valid PK_Facility-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facility-valid"
    ADD CONSTRAINT "PK_Facility-valid" PRIMARY KEY ("Facility-validID");


--
-- Name: Facilitylog PK_Facilitylog; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facilitylog"
    ADD CONSTRAINT "PK_Facilitylog" PRIMARY KEY ("FacilitylogID");


--
-- Name: Facilityset PK_Facilityset; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facilityset"
    ADD CONSTRAINT "PK_Facilityset" PRIMARY KEY ("FacilitysetID");


--
-- Name: Frequencies PK_Frequencies; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Frequencies"
    ADD CONSTRAINT "PK_Frequencies" PRIMARY KEY ("FrequenciesID");


--
-- Name: Frequencyusetype PK_Frequencyusetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Frequencyusetype"
    ADD CONSTRAINT "PK_Frequencyusetype" PRIMARY KEY ("FrequencyusetypeID");


--
-- Name: Geopositioning-method PK_Geopositioning-method; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Geopositioning-method"
    ADD CONSTRAINT "PK_Geopositioning-method" PRIMARY KEY ("Geopositioning-methodID");


--
-- Name: Geopositioningmethodtype PK_Geopositioningmethodtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Geopositioningmethodtype"
    ADD CONSTRAINT "PK_Geopositioningmethodtype" PRIMARY KEY ("GeopositioningmethodtypeID");


--
-- Name: Geospatiallocation PK_Geospatiallocation; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Geospatiallocation"
    ADD CONSTRAINT "PK_Geospatiallocation" PRIMARY KEY ("GeospatiallocationID");


--
-- Name: Header PK_Header; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Header"
    ADD CONSTRAINT "PK_Header" PRIMARY KEY ("HeaderID");


--
-- Name: Instrument-operating-status PK_Instrument-operating-status; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Instrument-operating-status"
    ADD CONSTRAINT "PK_Instrument-operating-status" PRIMARY KEY ("Instrument-operating-statusID");


--
-- Name: Instrumentcontrolresulttype PK_Instrumentcontrolresulttype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Instrumentcontrolresulttype"
    ADD CONSTRAINT "PK_Instrumentcontrolresulttype" PRIMARY KEY ("InstrumentcontrolresulttypeID");


--
-- Name: Instrumentcontrolscheduletype PK_Instrumentcontrolscheduletype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Instrumentcontrolscheduletype"
    ADD CONSTRAINT "PK_Instrumentcontrolscheduletype" PRIMARY KEY ("InstrumentcontrolscheduletypeID");


--
-- Name: Instrumentoperatingstatus PK_Instrumentoperatingstatus; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Instrumentoperatingstatus"
    ADD CONSTRAINT "PK_Instrumentoperatingstatus" PRIMARY KEY ("InstrumentoperatingstatusID");


--
-- Name: Instrumentoperatingstatustype PK_Instrumentoperatingstatustype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Instrumentoperatingstatustype"
    ADD CONSTRAINT "PK_Instrumentoperatingstatustype" PRIMARY KEY ("InstrumentoperatingstatustypeID");


--
-- Name: Level-of-data PK_Level-of-data; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Level-of-data"
    ADD CONSTRAINT "PK_Level-of-data" PRIMARY KEY ("Level-of-dataID");


--
-- Name: Levelofdatatype PK_Levelofdatatype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Levelofdatatype"
    ADD CONSTRAINT "PK_Levelofdatatype" PRIMARY KEY ("LevelofdatatypeID");


--
-- Name: Local-topography PK_Local-topography; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Local-topography"
    ADD CONSTRAINT "PK_Local-topography" PRIMARY KEY ("Local-topographyID");


--
-- Name: Localreferencesurfacetype PK_Localreferencesurfacetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Localreferencesurfacetype"
    ADD CONSTRAINT "PK_Localreferencesurfacetype" PRIMARY KEY ("LocalreferencesurfacetypeID");


--
-- Name: Localtopographytype PK_Localtopographytype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Localtopographytype"
    ADD CONSTRAINT "PK_Localtopographytype" PRIMARY KEY ("LocaltopographytypeID");


--
-- Name: Log PK_Log; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Log"
    ADD CONSTRAINT "PK_Log" PRIMARY KEY ("LogID");


--
-- Name: Logentry PK_Logentry; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Logentry"
    ADD CONSTRAINT "PK_Logentry" PRIMARY KEY ("LogentryID");


--
-- Name: Maintenancereport PK_Maintenancereport; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Maintenancereport"
    ADD CONSTRAINT "PK_Maintenancereport" PRIMARY KEY ("MaintenancereportID");


--
-- Name: Measurementunittype PK_Measurementunittype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Measurementunittype"
    ADD CONSTRAINT "PK_Measurementunittype" PRIMARY KEY ("MeasurementunittypeID");


--
-- Name: Metadata-record PK_Metadata-record; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Metadata-record"
    ADD CONSTRAINT "PK_Metadata-record" PRIMARY KEY ("Metadata-recordID");


--
-- Name: Observation PK_Observation; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observation"
    ADD CONSTRAINT "PK_Observation" PRIMARY KEY ("ObservationID");


--
-- Name: Observation-feature-of-interest PK_Observation-feature-of-interest; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observation-feature-of-interest"
    ADD CONSTRAINT "PK_Observation-feature-of-interest" PRIMARY KEY ("Observation-feature-of-interestID");


--
-- Name: Observation-observed-property PK_Observation-observed-property; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observation-observed-property"
    ADD CONSTRAINT "PK_Observation-observed-property" PRIMARY KEY ("Observation-observed-propertyID");


--
-- Name: Observation-process PK_Observation-process; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observation-process"
    ADD CONSTRAINT "PK_Observation-process" PRIMARY KEY ("Observation-processID");


--
-- Name: Observation-result PK_Observation-result; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observation-result"
    ADD CONSTRAINT "PK_Observation-result" PRIMARY KEY ("Observation-resultID");


--
-- Name: Observation-valid PK_Observation-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observation-valid"
    ADD CONSTRAINT "PK_Observation-valid" PRIMARY KEY ("Observation-validID");


--
-- Name: Observedvariabletype PK_Observedvariabletype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observedvariabletype"
    ADD CONSTRAINT "PK_Observedvariabletype" PRIMARY KEY ("ObservedvariabletypeID");


--
-- Name: Observing-facility PK_Observing-facility; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observing-facility"
    ADD CONSTRAINT "PK_Observing-facility" PRIMARY KEY ("Observing-facilityID");


--
-- Name: Observing-method PK_Observing-method; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observing-method"
    ADD CONSTRAINT "PK_Observing-method" PRIMARY KEY ("Observing-methodID");


--
-- Name: Observingcapability PK_Observingcapability; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observingcapability"
    ADD CONSTRAINT "PK_Observingcapability" PRIMARY KEY ("ObservingcapabilityID");


--
-- Name: Observingfacility PK_Observingfacility; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observingfacility"
    ADD CONSTRAINT "PK_Observingfacility" PRIMARY KEY ("ObservingfacilityID");


--
-- Name: Observingfacilitytype PK_Observingfacilitytype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observingfacilitytype"
    ADD CONSTRAINT "PK_Observingfacilitytype" PRIMARY KEY ("ObservingfacilitytypeID");


--
-- Name: Observingmethodtype PK_Observingmethodtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observingmethodtype"
    ADD CONSTRAINT "PK_Observingmethodtype" PRIMARY KEY ("ObservingmethodtypeID");


--
-- Name: Polarizationtype PK_Polarizationtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Polarizationtype"
    ADD CONSTRAINT "PK_Polarizationtype" PRIMARY KEY ("PolarizationtypeID");


--
-- Name: Population PK_Population; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Population"
    ADD CONSTRAINT "PK_Population" PRIMARY KEY ("PopulationID");


--
-- Name: Process PK_Process; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Process"
    ADD CONSTRAINT "PK_Process" PRIMARY KEY ("ProcessID");


--
-- Name: Process-valid PK_Process-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Process-valid"
    ADD CONSTRAINT "PK_Process-valid" PRIMARY KEY ("Process-validID");


--
-- Name: Processing PK_Processing; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Processing"
    ADD CONSTRAINT "PK_Processing" PRIMARY KEY ("ProcessingID");


--
-- Name: Processing-valid PK_Processing-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Processing-valid"
    ADD CONSTRAINT "PK_Processing-valid" PRIMARY KEY ("Processing-validID");


--
-- Name: Program-affiliation PK_Program-affiliation; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Program-affiliation"
    ADD CONSTRAINT "PK_Program-affiliation" PRIMARY KEY ("Program-affiliationID");


--
-- Name: Programaffiliation PK_Programaffiliation; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Programaffiliation"
    ADD CONSTRAINT "PK_Programaffiliation" PRIMARY KEY ("ProgramaffiliationID");


--
-- Name: Programornetworkaffiliationtype PK_Programornetworkaffiliationtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Programornetworkaffiliationtype"
    ADD CONSTRAINT "PK_Programornetworkaffiliationtype" PRIMARY KEY ("ProgramornetworkaffiliationtypeID");


--
-- Name: Purposeoffrequencyusetype PK_Purposeoffrequencyusetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Purposeoffrequencyusetype"
    ADD CONSTRAINT "PK_Purposeoffrequencyusetype" PRIMARY KEY ("PurposeoffrequencyusetypeID");


--
-- Name: Qualityflagtype PK_Qualityflagtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Qualityflagtype"
    ADD CONSTRAINT "PK_Qualityflagtype" PRIMARY KEY ("QualityflagtypeID");


--
-- Name: Record-valid PK_Record-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Record-valid"
    ADD CONSTRAINT "PK_Record-valid" PRIMARY KEY ("Record-validID");


--
-- Name: Reference-time PK_Reference-time; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reference-time"
    ADD CONSTRAINT "PK_Reference-time" PRIMARY KEY ("Reference-timeID");


--
-- Name: Referencetimetype PK_Referencetimetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Referencetimetype"
    ADD CONSTRAINT "PK_Referencetimetype" PRIMARY KEY ("ReferencetimetypeID");


--
-- Name: Relative-elevation PK_Relative-elevation; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Relative-elevation"
    ADD CONSTRAINT "PK_Relative-elevation" PRIMARY KEY ("Relative-elevationID");


--
-- Name: Relativeelevationtype PK_Relativeelevationtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Relativeelevationtype"
    ADD CONSTRAINT "PK_Relativeelevationtype" PRIMARY KEY ("RelativeelevationtypeID");


--
-- Name: Reporting PK_Reporting; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reporting"
    ADD CONSTRAINT "PK_Reporting" PRIMARY KEY ("ReportingID");


--
-- Name: Reporting-status PK_Reporting-status; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reporting-status"
    ADD CONSTRAINT "PK_Reporting-status" PRIMARY KEY ("Reporting-statusID");


--
-- Name: Reporting-valid PK_Reporting-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reporting-valid"
    ADD CONSTRAINT "PK_Reporting-valid" PRIMARY KEY ("Reporting-validID");


--
-- Name: Reportingstatus PK_Reportingstatus; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reportingstatus"
    ADD CONSTRAINT "PK_Reportingstatus" PRIMARY KEY ("ReportingstatusID");


--
-- Name: Reportingstatustype PK_Reportingstatustype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reportingstatustype"
    ADD CONSTRAINT "PK_Reportingstatustype" PRIMARY KEY ("ReportingstatustypeID");


--
-- Name: Representativeness PK_Representativeness; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Representativeness"
    ADD CONSTRAINT "PK_Representativeness" PRIMARY KEY ("RepresentativenessID");


--
-- Name: Representativenesstype PK_Representativenesstype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Representativenesstype"
    ADD CONSTRAINT "PK_Representativenesstype" PRIMARY KEY ("RepresentativenesstypeID");


--
-- Name: Responsibleparty PK_Responsibleparty; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Responsibleparty"
    ADD CONSTRAINT "PK_Responsibleparty" PRIMARY KEY ("ResponsiblepartyID");


--
-- Name: Resultset PK_Resultset; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Resultset"
    ADD CONSTRAINT "PK_Resultset" PRIMARY KEY ("ResultsetID");


--
-- Name: Sampletreatmenttype PK_Sampletreatmenttype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sampletreatmenttype"
    ADD CONSTRAINT "PK_Sampletreatmenttype" PRIMARY KEY ("SampletreatmenttypeID");


--
-- Name: Sampling PK_Sampling; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sampling"
    ADD CONSTRAINT "PK_Sampling" PRIMARY KEY ("SamplingID");


--
-- Name: Sampling-strategy PK_Sampling-strategy; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sampling-strategy"
    ADD CONSTRAINT "PK_Sampling-strategy" PRIMARY KEY ("Sampling-strategyID");


--
-- Name: Sampling-valid PK_Sampling-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sampling-valid"
    ADD CONSTRAINT "PK_Sampling-valid" PRIMARY KEY ("Sampling-validID");


--
-- Name: Samplingproceduretype PK_Samplingproceduretype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Samplingproceduretype"
    ADD CONSTRAINT "PK_Samplingproceduretype" PRIMARY KEY ("SamplingproceduretypeID");


--
-- Name: Samplingstrategytype PK_Samplingstrategytype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Samplingstrategytype"
    ADD CONSTRAINT "PK_Samplingstrategytype" PRIMARY KEY ("SamplingstrategytypeID");


--
-- Name: Schedule PK_Schedule; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Schedule"
    ADD CONSTRAINT "PK_Schedule" PRIMARY KEY ("ScheduleID");


--
-- Name: Source-of-observation PK_Source-of-observation; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Source-of-observation"
    ADD CONSTRAINT "PK_Source-of-observation" PRIMARY KEY ("Source-of-observationID");


--
-- Name: Sourceofobservationtype PK_Sourceofobservationtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sourceofobservationtype"
    ADD CONSTRAINT "PK_Sourceofobservationtype" PRIMARY KEY ("SourceofobservationtypeID");


--
-- Name: Surface-cover PK_Surface-cover; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surface-cover"
    ADD CONSTRAINT "PK_Surface-cover" PRIMARY KEY ("Surface-coverID");


--
-- Name: Surface-cover-classification PK_Surface-cover-classification; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surface-cover-classification"
    ADD CONSTRAINT "PK_Surface-cover-classification" PRIMARY KEY ("Surface-cover-classificationID");


--
-- Name: Surface-roughness PK_Surface-roughness; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surface-roughness"
    ADD CONSTRAINT "PK_Surface-roughness" PRIMARY KEY ("Surface-roughnessID");


--
-- Name: Surfacecover PK_Surfacecover; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surfacecover"
    ADD CONSTRAINT "PK_Surfacecover" PRIMARY KEY ("SurfacecoverID");


--
-- Name: Surfacecoverclassificationtype PK_Surfacecoverclassificationtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surfacecoverclassificationtype"
    ADD CONSTRAINT "PK_Surfacecoverclassificationtype" PRIMARY KEY ("SurfacecoverclassificationtypeID");


--
-- Name: Surfacecovertype PK_Surfacecovertype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surfacecovertype"
    ADD CONSTRAINT "PK_Surfacecovertype" PRIMARY KEY ("SurfacecovertypeID");


--
-- Name: Surfaceroughness PK_Surfaceroughness; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surfaceroughness"
    ADD CONSTRAINT "PK_Surfaceroughness" PRIMARY KEY ("SurfaceroughnessID");


--
-- Name: Surfaceroughnesstype PK_Surfaceroughnesstype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Surfaceroughnesstype"
    ADD CONSTRAINT "PK_Surfaceroughnesstype" PRIMARY KEY ("SurfaceroughnesstypeID");


--
-- Name: Territory PK_Territory; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Territory"
    ADD CONSTRAINT "PK_Territory" PRIMARY KEY ("TerritoryID");


--
-- Name: Territory-name PK_Territory-name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Territory-name"
    ADD CONSTRAINT "PK_Territory-name" PRIMARY KEY ("Territory-nameID");


--
-- Name: Territorytype PK_Territorytype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Territorytype"
    ADD CONSTRAINT "PK_Territorytype" PRIMARY KEY ("TerritorytypeID");


--
-- Name: Time-encoding PK_Time-encoding; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Time-encoding"
    ADD CONSTRAINT "PK_Time-encoding" PRIMARY KEY ("Time-encodingID");


--
-- Name: Time-stamp-meaning PK_Time-stamp-meaning; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Time-stamp-meaning"
    ADD CONSTRAINT "PK_Time-stamp-meaning" PRIMARY KEY ("Time-stamp-meaningID");


--
-- Name: Time-zone-explicit PK_Time-zone-explicit; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Time-zone-explicit"
    ADD CONSTRAINT "PK_Time-zone-explicit" PRIMARY KEY ("Time-zone-explicitID");


--
-- Name: Timestampmeaningtype PK_Timestampmeaningtype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Timestampmeaningtype"
    ADD CONSTRAINT "PK_Timestampmeaningtype" PRIMARY KEY ("TimestampmeaningtypeID");


--
-- Name: Timezone PK_Timezone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Timezone"
    ADD CONSTRAINT "PK_Timezone" PRIMARY KEY ("TimezoneID");


--
-- Name: Timezonetype PK_Timezonetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Timezonetype"
    ADD CONSTRAINT "PK_Timezonetype" PRIMARY KEY ("TimezonetypeID");


--
-- Name: Topographic-context PK_Topographic-context; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Topographic-context"
    ADD CONSTRAINT "PK_Topographic-context" PRIMARY KEY ("Topographic-contextID");


--
-- Name: Topographiccontexttype PK_Topographiccontexttype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Topographiccontexttype"
    ADD CONSTRAINT "PK_Topographiccontexttype" PRIMARY KEY ("TopographiccontexttypeID");


--
-- Name: Topographybathymetry PK_Topographybathymetry; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Topographybathymetry"
    ADD CONSTRAINT "PK_Topographybathymetry" PRIMARY KEY ("TopographybathymetryID");


--
-- Name: Traceabilitytype PK_Traceabilitytype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Traceabilitytype"
    ADD CONSTRAINT "PK_Traceabilitytype" PRIMARY KEY ("TraceabilitytypeID");


--
-- Name: Transmissionmodetype PK_Transmissionmodetype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transmissionmodetype"
    ADD CONSTRAINT "PK_Transmissionmodetype" PRIMARY KEY ("TransmissionmodetypeID");


--
-- Name: Uncertaintyevalproctype PK_Uncertaintyevalproctype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Uncertaintyevalproctype"
    ADD CONSTRAINT "PK_Uncertaintyevalproctype" PRIMARY KEY ("UncertaintyevalproctypeID");


--
-- Name: Unique-observed-variable PK_Unique-observed-variable; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Unique-observed-variable"
    ADD CONSTRAINT "PK_Unique-observed-variable" PRIMARY KEY ("Unique-observed-variableID");


--
-- Name: Unit-of-measure PK_Unit-of-measure; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Unit-of-measure"
    ADD CONSTRAINT "PK_Unit-of-measure" PRIMARY KEY ("Unit-of-measureID");


--
-- Name: Valid-local-references PK_Valid-local-references; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Valid-local-references"
    ADD CONSTRAINT "PK_Valid-local-references" PRIMARY KEY ("Valid-local-referencesID");


--
-- Name: Well-formed PK_Well-formed; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Well-formed"
    ADD CONSTRAINT "PK_Well-formed" PRIMARY KEY ("Well-formedID");


--
-- Name: Wigosmetadatarecord PK_Wigosmetadatarecord; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Wigosmetadatarecord"
    ADD CONSTRAINT "PK_Wigosmetadatarecord" PRIMARY KEY ("WigosmetadatarecordID");


--
-- Name: Wmo-region PK_Wmo-region; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Wmo-region"
    ADD CONSTRAINT "PK_Wmo-region" PRIMARY KEY ("Wmo-regionID");


--
-- Name: Wmoregiontype PK_Wmoregiontype; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Wmoregiontype"
    ADD CONSTRAINT "PK_Wmoregiontype" PRIMARY KEY ("WmoregiontypeID");


--
-- Name: Xml-rules PK_Xml-rules; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Xml-rules"
    ADD CONSTRAINT "PK_Xml-rules" PRIMARY KEY ("Xml-rulesID");


--
-- Name: Xsd-valid PK_Xsd-valid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Xsd-valid"
    ADD CONSTRAINT "PK_Xsd-valid" PRIMARY KEY ("Xsd-validID");


--
-- Name: soil_types SOIL_TYPES_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.soil_types
    ADD CONSTRAINT "SOIL_TYPES_PK" PRIMARY KEY (id);


--
-- Name: stations STATIONS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT "STATIONS_PK" PRIMARY KEY (id);


--
-- Name: station_audit STATION_AUDIT_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_audit
    ADD CONSTRAINT "STATION_AUDIT_PK" PRIMARY KEY (id);


--
-- Name: station_audit_types STATION_AUDIT_TYPES_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_audit_types
    ADD CONSTRAINT "STATION_AUDIT_TYPES_PK" PRIMARY KEY (id);


--
-- Name: station_class STATION_CLASS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_class
    ADD CONSTRAINT "STATION_CLASS_PK" PRIMARY KEY (id);


--
-- Name: station_contacts STATION_CONTACTS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_contacts
    ADD CONSTRAINT "STATION_CONTACTS_PK" PRIMARY KEY (id);


--
-- Name: station_countries STATION_COUNTRIES_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_countries
    ADD CONSTRAINT "STATION_COUNTRIES_PK" PRIMARY KEY (id);


--
-- Name: station_equipment STATION_EQUIPMENT_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_equipment
    ADD CONSTRAINT "STATION_EQUIPMENT_PK" PRIMARY KEY (id);


--
-- Name: station_files STATION_FILES_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_files
    ADD CONSTRAINT "STATION_FILES_PK" PRIMARY KEY (id);


--
-- Name: station_status STATION_STATUS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_status
    ADD CONSTRAINT "STATION_STATUS_PK" PRIMARY KEY (id);


--
-- Name: station_timezones STATION_TIMEZONES_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_timezones
    ADD CONSTRAINT "STATION_TIMEZONES_PK" PRIMARY KEY (id);


--
-- Name: station_types STATION_TYPES_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_types
    ADD CONSTRAINT "STATION_TYPES_PK" PRIMARY KEY (id);


--
-- Name: surface_types SURFACE_TYPES_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.surface_types
    ADD CONSTRAINT "SURFACE_TYPES_PK" PRIMARY KEY (id);


--
-- Name: timezone_diffs TIMEZONE_DIFFS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.timezone_diffs
    ADD CONSTRAINT "TIMEZONE_DIFFS_PK" PRIMARY KEY (id);


--
-- Name: user_sessions USER_SESSIONS_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT "USER_SESSIONS_PK" PRIMARY KEY (id);


--
-- Name: codes_simple codes_simple_code_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.codes_simple
    ADD CONSTRAINT codes_simple_code_unique UNIQUE (code_type, code);


--
-- Name: datums datums_pkey; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.datums
    ADD CONSTRAINT datums_pkey PRIMARY KEY (datum_name);


--
-- Name: gui_users gui_users_PK; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.gui_users
    ADD CONSTRAINT "gui_users_PK" PRIMARY KEY (id);


--
-- Name: gui_users gui_users_username_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.gui_users
    ADD CONSTRAINT gui_users_username_unique UNIQUE (username);


--
-- Name: key_settings key_settings_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.key_settings
    ADD CONSTRAINT key_settings_unique UNIQUE (profile, element, obs_type);


--
-- Name: land_use land_use_code_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.land_use
    ADD CONSTRAINT land_use_code_unique UNIQUE (land_use_code);


--
-- Name: obs_averages obs_average_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_averages
    ADD CONSTRAINT obs_average_unique UNIQUE (name, station_no, month);


--
-- Name: obs_clicom_element_map obs_clicom_element_map_pk; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_clicom_element_map
    ADD CONSTRAINT obs_clicom_element_map_pk PRIMARY KEY (id);


--
-- Name: pivot pivot_pkey; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.pivot
    ADD CONSTRAINT pivot_pkey PRIMARY KEY (i);


--
-- Name: spatial_ref_sys spatial_ref_sys_pkey; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.spatial_ref_sys
    ADD CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid);


--
-- Name: station_countries station_countries_iso_code_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_countries
    ADD CONSTRAINT station_countries_iso_code_unique UNIQUE (iso_code);


--
-- Name: station_timezones station_timezones_tm_zone_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_timezones
    ADD CONSTRAINT station_timezones_tm_zone_unique UNIQUE (tm_zone);


--
-- Name: stations stations_id_wmo_start_date_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_id_wmo_start_date_unique UNIQUE (id_wmo, start_date);


--
-- Name: stations stations_station_no_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_station_no_unique UNIQUE (station_no);


--
-- Name: station_audit_types type_unique; Type: CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_audit_types
    ADD CONSTRAINT type_unique UNIQUE (audit_type);


--
-- Name: fki_obs_subdaily_cloud_layers_subdaily_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_obs_subdaily_cloud_layers_subdaily_id_fkey ON public.obs_subdaily_cloud_layers USING btree (sub_daily_id);


--
-- Name: fki_obs_subdaily_soil_temps_subdaily_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_obs_subdaily_soil_temps_subdaily_id_fkey ON public.obs_subdaily_soil_temps USING btree (sub_daily_id);


--
-- Name: fki_station_audit_audit_type_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_station_audit_audit_type_id_fkey ON public.station_audit USING btree (audit_type_id);


--
-- Name: fki_station_audit_station_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_station_audit_station_id_fkey ON public.station_audit USING btree (station_id);


--
-- Name: fki_station_class_station_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_station_class_station_id_fkey ON public.station_class USING btree (station_id);


--
-- Name: fki_station_class_type_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_station_class_type_id_fkey ON public.station_class USING btree (type_id);


--
-- Name: fki_station_contacts_station_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_station_contacts_station_id_fkey ON public.station_contacts USING btree (station_id);


--
-- Name: fki_station_equipment_equipment_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_station_equipment_equipment_id_fkey ON public.station_equipment USING btree (equipment_id);


--
-- Name: fki_station_equipment_station_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_station_equipment_station_id_fkey ON public.station_equipment USING btree (station_id);


--
-- Name: fki_station_files_station_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_station_files_station_id_fkey ON public.station_files USING btree (station_id);


--
-- Name: fki_stations_country_code_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_stations_country_code_fkey ON public.stations USING btree (country_code);


--
-- Name: fki_stations_land_use_0_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_stations_land_use_0_id_fkey ON public.stations USING btree (lu_0_100m);


--
-- Name: fki_stations_land_use_100_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_stations_land_use_100_id_fkey ON public.stations USING btree (lu_100m_1km);


--
-- Name: fki_stations_land_use_1km_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_stations_land_use_1km_id_fkey ON public.stations USING btree (lu_1km_10km);


--
-- Name: fki_stations_soil_type_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_stations_soil_type_id_fkey ON public.stations USING btree (soil_type);


--
-- Name: fki_stations_status_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_stations_status_id_fkey ON public.stations USING btree (status_id);


--
-- Name: fki_stations_surface_type_id_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_stations_surface_type_id_fkey ON public.stations USING btree (surface_type);


--
-- Name: fki_stations_time_zone_fkey; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_stations_time_zone_fkey ON public.stations USING btree (time_zone);


--
-- Name: fki_timezone_diffs; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX fki_timezone_diffs ON public.timezone_diffs USING btree (tm_zone);


--
-- Name: obs_aero_insert_datetime_day_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_aero_insert_datetime_day_idx ON public.obs_aero USING btree (date_trunc('day'::text, insert_datetime));


--
-- Name: obs_aero_unique_1; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE UNIQUE INDEX obs_aero_unique_1 ON public.obs_aero USING btree (station_no, lsd) WITH (fillfactor='70');


--
-- Name: obs_audit_row_id_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_audit_row_id_idx ON public.obs_audit USING btree (row_id);


--
-- Name: obs_aws_lct_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_aws_lct_idx ON public.obs_aws USING btree (lct);


--
-- Name: obs_aws_lsd_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_aws_lsd_idx ON public.obs_aws USING btree (lsd);


--
-- Name: obs_aws_unique_1; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE UNIQUE INDEX obs_aws_unique_1 ON public.obs_aws USING btree (station_no, lsd) WITH (fillfactor='70');


--
-- Name: obs_aws_upper_station_lct_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_aws_upper_station_lct_idx ON public.obs_aws USING btree (upper((station_no)::text), lct);


--
-- Name: obs_aws_upper_station_lsd_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_aws_upper_station_lsd_idx ON public.obs_aws USING btree (upper((station_no)::text), lsd);


--
-- Name: obs_daily_insert_datetime_day_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_daily_insert_datetime_day_idx ON public.obs_daily USING btree (date_trunc('day'::text, insert_datetime));


--
-- Name: obs_daily_lsd_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_daily_lsd_idx ON public.obs_daily USING btree (lsd);


--
-- Name: obs_daily_unique_1; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE UNIQUE INDEX obs_daily_unique_1 ON public.obs_daily USING btree (station_no, lsd) WITH (fillfactor='70');


--
-- Name: obs_daily_upper_station_lsd_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_daily_upper_station_lsd_idx ON public.obs_daily USING btree (upper((station_no)::text), lsd);


--
-- Name: obs_monthly_insert_datetime_day_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_monthly_insert_datetime_day_idx ON public.obs_monthly USING btree (date_trunc('day'::text, insert_datetime));


--
-- Name: obs_monthly_lsd_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_monthly_lsd_idx ON public.obs_monthly USING btree (lsd);


--
-- Name: obs_monthly_upper_station_lsd_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_monthly_upper_station_lsd_idx ON public.obs_monthly USING btree (upper((station_no)::text), lsd);


--
-- Name: obs_subdaily_insert_datetime_day_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_subdaily_insert_datetime_day_idx ON public.obs_subdaily USING btree (date_trunc('day'::text, insert_datetime));


--
-- Name: obs_subdaily_lct_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_subdaily_lct_idx ON public.obs_subdaily USING btree (lct);


--
-- Name: obs_subdaily_lsd_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_subdaily_lsd_idx ON public.obs_subdaily USING btree (lsd);


--
-- Name: obs_subdaily_unique_1; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE UNIQUE INDEX obs_subdaily_unique_1 ON public.obs_subdaily USING btree (station_no, lsd) WITH (fillfactor='70');


--
-- Name: obs_subdaily_upper_station_lct_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_subdaily_upper_station_lct_idx ON public.obs_subdaily USING btree (upper((station_no)::text), lct);


--
-- Name: obs_subdaily_upper_station_lsd_idx; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE INDEX obs_subdaily_upper_station_lsd_idx ON public.obs_subdaily USING btree (upper((station_no)::text), lsd);


--
-- Name: obs_upper_unique_1; Type: INDEX; Schema: public; Owner: clidegui
--

CREATE UNIQUE INDEX obs_upper_unique_1 ON public.obs_upper_air USING btree (station_no, lsd, geo_height) WITH (fillfactor='70');


--
-- Name: stations stations_id_wmo_dates_trg; Type: TRIGGER; Schema: public; Owner: clidegui
--

CREATE TRIGGER stations_id_wmo_dates_trg BEFORE INSERT OR UPDATE ON public.stations FOR EACH ROW EXECUTE FUNCTION public.stations_id_wmo_dates_trg();


--
-- Name: Controlcheckreport FK_ControlCheckReport_LogEntry; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Controlcheckreport"
    ADD CONSTRAINT "FK_ControlCheckReport_LogEntry" FOREIGN KEY ("ControlcheckreportID") REFERENCES public."Logentry"("LogentryID");


--
-- Name: Datageneration FK_DataGeneration_dataGeneration; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Datageneration"
    ADD CONSTRAINT "FK_DataGeneration_dataGeneration" FOREIGN KEY ("DeploymentID") REFERENCES public."Deployment"("DeploymentID");


--
-- Name: Deployment FK_Deployment_deployment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deployment"
    ADD CONSTRAINT "FK_Deployment_deployment" FOREIGN KEY ("ProcessID") REFERENCES public."Process"("ProcessID");


--
-- Name: EquipmentEquipment FK_EquipmentEquipment_Equipment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EquipmentEquipment"
    ADD CONSTRAINT "FK_EquipmentEquipment_Equipment" FOREIGN KEY ("EquipmentID") REFERENCES public."Equipment"("EquipmentID");


--
-- Name: EquipmentEquipment FK_EquipmentEquipment_subEquipment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EquipmentEquipment"
    ADD CONSTRAINT "FK_EquipmentEquipment_subEquipment" FOREIGN KEY ("subEquipment") REFERENCES public."Equipment"("EquipmentID");


--
-- Name: Equipmentlog FK_EquipmentLog_Log; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipmentlog"
    ADD CONSTRAINT "FK_EquipmentLog_Log" FOREIGN KEY ("EquipmentlogID") REFERENCES public."Log"("LogID");


--
-- Name: Equipmentlog FK_EquipmentLog_equipmentLog; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipmentlog"
    ADD CONSTRAINT "FK_EquipmentLog_equipmentLog" FOREIGN KEY (equipment) REFERENCES public."Equipment"("EquipmentID");


--
-- Name: Equipment FK_Equipment_AbstractEnvironmentalMonitoringFacility; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment"
    ADD CONSTRAINT "FK_Equipment_AbstractEnvironmentalMonitoringFacility" FOREIGN KEY ("EquipmentID") REFERENCES public."Abstractenvironmentalmonitoringfacility"("AbstractenvironmentalmonitoringfacilityID");


--
-- Name: Equipment FK_Equipment_deployedEquipment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment"
    ADD CONSTRAINT "FK_Equipment_deployedEquipment" FOREIGN KEY ("DeploymentID") REFERENCES public."Deployment"("DeploymentID");


--
-- Name: Equipment FK_Equipment_equipment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Equipment"
    ADD CONSTRAINT "FK_Equipment_equipment" FOREIGN KEY (facility) REFERENCES public."Observingfacility"("ObservingfacilityID");


--
-- Name: Eventreport FK_EventReport_LogEntry; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Eventreport"
    ADD CONSTRAINT "FK_EventReport_LogEntry" FOREIGN KEY ("EventreportID") REFERENCES public."Logentry"("LogentryID");


--
-- Name: Facilitylog FK_FacilityLog_Log; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facilitylog"
    ADD CONSTRAINT "FK_FacilityLog_Log" FOREIGN KEY ("FacilitylogID") REFERENCES public."Log"("LogID");


--
-- Name: Facilitylog FK_FacilityLog_facilityLog; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facilitylog"
    ADD CONSTRAINT "FK_FacilityLog_facilityLog" FOREIGN KEY (facility) REFERENCES public."Observingfacility"("ObservingfacilityID");


--
-- Name: FacilitySetObservingFacility FK_FacilitySetObservingFacility_facility; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FacilitySetObservingFacility"
    ADD CONSTRAINT "FK_FacilitySetObservingFacility_facility" FOREIGN KEY (facility) REFERENCES public."Observingfacility"("ObservingfacilityID");


--
-- Name: FacilitySetObservingFacility FK_FacilitySetObservingFacility_facilitySet; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FacilitySetObservingFacility"
    ADD CONSTRAINT "FK_FacilitySetObservingFacility_facilitySet" FOREIGN KEY ("facilitySet") REFERENCES public."Facilityset"("FacilitysetID");


--
-- Name: Frequencies FK_Frequencies_Equipment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Frequencies"
    ADD CONSTRAINT "FK_Frequencies_Equipment" FOREIGN KEY ("EquipmentID") REFERENCES public."Equipment"("EquipmentID");


--
-- Name: Maintenancereport FK_MaintenanceReport_LogEntry; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Maintenancereport"
    ADD CONSTRAINT "FK_MaintenanceReport_LogEntry" FOREIGN KEY ("MaintenancereportID") REFERENCES public."Logentry"("LogentryID");


--
-- Name: Observingcapability FK_ObservingCapability_facility; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observingcapability"
    ADD CONSTRAINT "FK_ObservingCapability_facility" FOREIGN KEY (facility) REFERENCES public."Observingfacility"("ObservingfacilityID");


--
-- Name: Observingfacility FK_ObservingFacility_AbstractEnvironmentalMonitoringFacility; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Observingfacility"
    ADD CONSTRAINT "FK_ObservingFacility_AbstractEnvironmentalMonitoringFacility" FOREIGN KEY ("ObservingfacilityID") REFERENCES public."Abstractenvironmentalmonitoringfacility"("AbstractenvironmentalmonitoringfacilityID");


--
-- Name: Processing FK_Processing_processing; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Processing"
    ADD CONSTRAINT "FK_Processing_processing" FOREIGN KEY ("DatagenerationID") REFERENCES public."Datageneration"("DatagenerationID");


--
-- Name: Reporting FK_Reporting_reporting; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reporting"
    ADD CONSTRAINT "FK_Reporting_reporting" FOREIGN KEY ("DatagenerationID") REFERENCES public."Datageneration"("DatagenerationID");


--
-- Name: Sampling FK_Sampling_sampling; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sampling"
    ADD CONSTRAINT "FK_Sampling_sampling" FOREIGN KEY ("DatagenerationID") REFERENCES public."Datageneration"("DatagenerationID");


--
-- Name: Schedule FK_Schedule_schedule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Schedule"
    ADD CONSTRAINT "FK_Schedule_schedule" FOREIGN KEY ("DatagenerationID") REFERENCES public."Datageneration"("DatagenerationID");


--
-- Name: obs_aero obs_aero_station_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_aero
    ADD CONSTRAINT obs_aero_station_no_fkey FOREIGN KEY (station_no) REFERENCES public.stations(station_no);


--
-- Name: obs_aws obs_aws_station_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_aws
    ADD CONSTRAINT obs_aws_station_no_fkey FOREIGN KEY (station_no) REFERENCES public.stations(station_no);


--
-- Name: obs_daily obs_daily_station_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_daily
    ADD CONSTRAINT obs_daily_station_no_fkey FOREIGN KEY (station_no) REFERENCES public.stations(station_no);


--
-- Name: obs_subdaily_cloud_layers obs_subdaily_cloud_layers_subdaily_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_subdaily_cloud_layers
    ADD CONSTRAINT obs_subdaily_cloud_layers_subdaily_id_fkey FOREIGN KEY (sub_daily_id) REFERENCES public.obs_subdaily(id);


--
-- Name: obs_subdaily obs_subdaily_station_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_subdaily
    ADD CONSTRAINT obs_subdaily_station_no_fkey FOREIGN KEY (station_no) REFERENCES public.stations(station_no);


--
-- Name: obs_upper_air obs_upper_air_station_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.obs_upper_air
    ADD CONSTRAINT obs_upper_air_station_no_fkey FOREIGN KEY (station_no) REFERENCES public.stations(station_no);


--
-- Name: station_audit station_audit_audit_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_audit
    ADD CONSTRAINT station_audit_audit_type_id_fkey FOREIGN KEY (audit_type_id) REFERENCES public.station_audit_types(id);


--
-- Name: station_audit station_audit_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_audit
    ADD CONSTRAINT station_audit_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(id);


--
-- Name: station_class station_class_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_class
    ADD CONSTRAINT station_class_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(id);


--
-- Name: station_class station_class_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_class
    ADD CONSTRAINT station_class_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.station_types(id);


--
-- Name: station_contacts station_contacts_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_contacts
    ADD CONSTRAINT station_contacts_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(id);


--
-- Name: station_equipment station_equipment_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_equipment
    ADD CONSTRAINT station_equipment_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.equipment(id);


--
-- Name: station_equipment station_equipment_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_equipment
    ADD CONSTRAINT station_equipment_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(id);


--
-- Name: station_files station_files_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.station_files
    ADD CONSTRAINT station_files_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(id);


--
-- Name: stations stations_country_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_country_code_fkey FOREIGN KEY (country_code) REFERENCES public.station_countries(iso_code);


--
-- Name: stations stations_land_use_0_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_land_use_0_id_fkey FOREIGN KEY (lu_0_100m) REFERENCES public.land_use(id);


--
-- Name: stations stations_land_use_100_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_land_use_100_id_fkey FOREIGN KEY (lu_100m_1km) REFERENCES public.land_use(id);


--
-- Name: stations stations_land_use_1km_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_land_use_1km_id_fkey FOREIGN KEY (lu_1km_10km) REFERENCES public.land_use(id);


--
-- Name: stations stations_location_datum_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_location_datum_fkey FOREIGN KEY (location_datum) REFERENCES public.datums(datum_name) ON UPDATE CASCADE;


--
-- Name: stations stations_location_epsg_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_location_epsg_fkey FOREIGN KEY (location_epsg) REFERENCES public.spatial_ref_sys(srid) ON UPDATE CASCADE;


--
-- Name: stations stations_soil_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_soil_type_id_fkey FOREIGN KEY (soil_type) REFERENCES public.soil_types(id);


--
-- Name: stations stations_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.station_status(id);


--
-- Name: stations stations_surface_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_surface_type_id_fkey FOREIGN KEY (surface_type) REFERENCES public.surface_types(id);


--
-- Name: stations stations_time_zone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_time_zone_fkey FOREIGN KEY (time_zone) REFERENCES public.station_timezones(tm_zone);


--
-- Name: timezone_diffs timezone_diffs; Type: FK CONSTRAINT; Schema: public; Owner: clidegui
--

ALTER TABLE ONLY public.timezone_diffs
    ADD CONSTRAINT timezone_diffs FOREIGN KEY (tm_zone) REFERENCES public.station_timezones(tm_zone);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

