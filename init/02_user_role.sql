CREATE USER backend_dev   WITH PASSWORD 'be_uts_2026';

CREATE USER bi_dev        WITH PASSWORD 'bi_uts_2026';

CREATE USER data_engineer WITH PASSWORD 'de_uts_2026';

GRANT CONNECT ON DATABASE postgres TO backend_dev, bi_dev, data_engineer;

GRANT USAGE ON SCHEMA salam TO backend_dev, bi_dev, data_engineer;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA salam TO backend_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA salam
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;

GRANT SELECT ON ALL TABLES IN SCHEMA salam TO bi_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA salam
    GRANT SELECT ON TABLES TO bi_dev;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA salam TO data_engineer;
GRANT CREATE ON SCHEMA salam TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA salam
    GRANT ALL PRIVILEGES ON TABLES TO data_engineer;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA salam TO backend_dev, data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA salam
    GRANT USAGE, SELECT ON SEQUENCES TO backend_dev, data_engineer;

ALTER TABLE salam.mahasiswas OWNER TO data_engineer;
ALTER VIEW  salam.v_mahasiswa_berprestasi OWNER TO data_engineer;
