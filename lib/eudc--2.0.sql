DO LANGUAGE plpgsql $$
BEGIN
  RAISE WARNING 'Perform "SELECT disable_eudc(); DROP EXTENSION eudc;" to drop this extension.'
    USING DETAIL = 'The 4 system conversions (sjis_to_utf8, utf8_to_sjis, euc_jp_to_utf8, utf8_to_euc_jp) should be reset as default.';
END;
$$;

-- SJIS_EUDC --> UTF8
CREATE FUNCTION pg_catalog.sjis_eudc_to_utf8 
  (integer, integer, cstring, internal, integer, boolean = false)
  RETURNS RETURN_TYPE AS '$libdir/eudc', 'sjis_eudc_to_utf8' LANGUAGE C STRICT;

-- UTF8 --> SJIS_EUDC
CREATE FUNCTION pg_catalog.utf8_to_sjis_eudc 
  (integer, integer, cstring, internal, integer, boolean = false)
  RETURNS RETURN_TYPE AS '$libdir/eudc', 'utf8_to_sjis_eudc' LANGUAGE C STRICT;

-- EUC_JP_EUDC --> UTF8
CREATE FUNCTION pg_catalog.euc_jp_eudc_to_utf8 
  (integer, integer, cstring, internal, integer, boolean = false)
  RETURNS RETURN_TYPE AS '$libdir/eudc', 'euc_jp_eudc_to_utf8' LANGUAGE C STRICT;

-- UTF8 --> EUC_JP_EUDC
CREATE FUNCTION pg_catalog.utf8_to_euc_jp_eudc 
  (integer, integer, cstring, internal, integer, boolean = false)
  RETURNS RETURN_TYPE AS '$libdir/eudc', 'utf8_to_euc_jp_eudc' LANGUAGE C STRICT;

-- To show eudc function information
CREATE OR REPLACE FUNCTION pg_catalog.show_eudc(OUT "Conversion Function" varchar,
				     OUT "Source" varchar, OUT "Destination" varchar,
				     OUT "Is Default?" varchar)
  RETURNS SETOF record
  AS '$libdir/eudc', 'show_eudc' LANGUAGE C IMMUTABLE STRICT;

-- create non-default conversions
CREATE CONVERSION pg_catalog.sjis_eudc_to_utf8 FOR 'SJIS' TO 'UTF8'
  FROM sjis_eudc_to_utf8;
CREATE CONVERSION pg_catalog.utf8_to_sjis_eudc FOR 'UTF8' TO 'SJIS'
  FROM utf8_to_sjis_eudc;
CREATE CONVERSION pg_catalog.euc_jp_eudc_to_utf8 FOR 'EUC_JP' TO 'UTF8'
  FROM euc_jp_eudc_to_utf8;
CREATE CONVERSION pg_catalog.utf8_to_euc_jp_eudc FOR 'UTF8' TO 'EUC_JP'
  FROM utf8_to_euc_jp_eudc;

-- enable/disable function
CREATE OR REPLACE FUNCTION pg_catalog.enable_eudc() 
  RETURNS void SET search_path TO 'pg_catalog' AS
$$
 UPDATE pg_conversion SET condefault = 'f' WHERE conname = 'sjis_to_utf8';
 UPDATE pg_conversion SET condefault = 'f' WHERE conname = 'utf8_to_sjis';
 UPDATE pg_conversion SET condefault = 'f' WHERE conname = 'euc_jp_to_utf8';
 UPDATE pg_conversion SET condefault = 'f' WHERE conname = 'utf8_to_euc_jp';
 UPDATE pg_conversion SET condefault = 't' WHERE conname = 'sjis_eudc_to_utf8';
 UPDATE pg_conversion SET condefault = 't' WHERE conname = 'utf8_to_sjis_eudc';
 UPDATE pg_conversion SET condefault = 't' WHERE conname = 'euc_jp_eudc_to_utf8';
 UPDATE pg_conversion SET condefault = 't' WHERE conname = 'utf8_to_euc_jp_eudc';
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION pg_catalog.disable_eudc() 
  RETURNS void SET search_path TO 'pg_catalog' AS
$$
 UPDATE pg_conversion SET condefault = 'f' WHERE conname = 'sjis_eudc_to_utf8';
 UPDATE pg_conversion SET condefault = 'f' WHERE conname = 'utf8_to_sjis_eudc';
 UPDATE pg_conversion SET condefault = 'f' WHERE conname = 'euc_jp_eudc_to_utf8';
 UPDATE pg_conversion SET condefault = 'f' WHERE conname = 'utf8_to_euc_jp_eudc';
 UPDATE pg_conversion SET condefault = 't' WHERE conname = 'sjis_to_utf8';
 UPDATE pg_conversion SET condefault = 't' WHERE conname = 'utf8_to_sjis';
 UPDATE pg_conversion SET condefault = 't' WHERE conname = 'euc_jp_to_utf8';
 UPDATE pg_conversion SET condefault = 't' WHERE conname = 'utf8_to_euc_jp';
$$ LANGUAGE sql;
