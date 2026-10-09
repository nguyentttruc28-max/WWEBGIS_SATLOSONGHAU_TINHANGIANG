CREATE EXTENSION IF NOT EXISTS postgis;

DROP TABLE IF EXISTS incident_warning_link CASCADE;
DROP TABLE IF EXISTS severity_assessment CASCADE;
DROP TABLE IF EXISTS severity_indicator CASCADE;
DROP TABLE IF EXISTS severity_level CASCADE;
DROP TABLE IF EXISTS warning_segment CASCADE;
DROP TABLE IF EXISTS warning_level CASCADE;
DROP TABLE IF EXISTS affected_road CASCADE;
DROP TABLE IF EXISTS affected_residential CASCADE;
DROP TABLE IF EXISTS management_work CASCADE;
DROP TABLE IF EXISTS management_sources CASCADE;
DROP TABLE IF EXISTS legal_basis CASCADE;
DROP TABLE IF EXISTS satlo_incident CASCADE;
DROP TABLE IF EXISTS measurement CASCADE;
DROP TABLE IF EXISTS city_locality CASCADE;
DROP TABLE IF EXISTS river_source CASCADE;
DROP TABLE IF EXISTS reference_source CASCADE;

CREATE TABLE reference_source (
 id_reference VARCHAR(30) PRIMARY KEY, reference_name VARCHAR(500) NOT NULL, year INT, source_type VARCHAR(150), provider VARCHAR(255), reference_url TEXT
);
CREATE TABLE river_source (
 id_river VARCHAR(30) PRIMARY KEY, river_name VARCHAR(100) NOT NULL, province VARCHAR(100), data_role VARCHAR(255), status VARCHAR(100), note TEXT
);
CREATE TABLE city_locality (
 id_city VARCHAR(30) PRIMARY KEY, commune VARCHAR(150), locality VARCHAR(255), district_historical VARCHAR(150), province VARCHAR(100), admin_period VARCHAR(50)
);
CREATE TABLE measurement (
 id_measurement VARCHAR(30) PRIMARY KEY, measurement_year INT NOT NULL CHECK (measurement_year BETWEEN 2020 AND 2026), id_city VARCHAR(30) REFERENCES city_locality(id_city), id_reference VARCHAR(30) REFERENCES reference_source(id_reference), record_type VARCHAR(50)
);
CREATE TABLE satlo_incident (
 incident_code VARCHAR(30) PRIMARY KEY, observed_date DATE, id_city VARCHAR(30) REFERENCES city_locality(id_city), commune VARCHAR(150), locality VARCHAR(255), district_historical VARCHAR(150), river_section VARCHAR(255), length_m VARCHAR(50), bank_inland_m VARCHAR(50), affected_households INT, latitude_reference DECIMAL(10,7), longitude_reference DECIMAL(10,7), coordinate_status VARCHAR(150), latitude DECIMAL(10,7), longitude DECIMAL(10,7), impact_summary TEXT, id_reference VARCHAR(30) REFERENCES reference_source(id_reference), verification_status VARCHAR(100),
 severity_level VARCHAR(100),
 severity_score NUMERIC(6,2),
 classification_basis TEXT,
 classification_confidence VARCHAR(50),
 classification_evidence TEXT,
 source_warning_level VARCHAR(100),
 classification_method TEXT,
 geom geometry(Point,4326)
);
CREATE TABLE warning_level (
 id_warning_level VARCHAR(30) PRIMARY KEY, warning_level_name VARCHAR(100) NOT NULL, definition TEXT, id_reference VARCHAR(30) REFERENCES reference_source(id_reference)
);
CREATE TABLE warning_segment (
 id_warning_segment VARCHAR(30) PRIMARY KEY, warning_year INT NOT NULL, segment_name VARCHAR(255) NOT NULL, commune VARCHAR(150), district_historical VARCHAR(150), id_warning_level VARCHAR(30) REFERENCES warning_level(id_warning_level), length_m NUMERIC, id_reference VARCHAR(30) REFERENCES reference_source(id_reference)
);
CREATE TABLE incident_warning_link (
 id_link VARCHAR(30) PRIMARY KEY, incident_code VARCHAR(30) REFERENCES satlo_incident(incident_code), id_warning_segment VARCHAR(30) REFERENCES warning_segment(id_warning_segment), relation_type VARCHAR(150), note TEXT, id_reference VARCHAR(30) REFERENCES reference_source(id_reference)
);
CREATE TABLE severity_level (
 id_severity VARCHAR(30) PRIMARY KEY,
 severity_name VARCHAR(100) NOT NULL,
 score_min NUMERIC(6,2),
 score_max NUMERIC(6,2),
 description TEXT
);
CREATE TABLE severity_indicator (
 indicator_id VARCHAR(30) NOT NULL,
 indicator_name VARCHAR(255) NOT NULL,
 condition VARCHAR(255),
 score_max_or_value NUMERIC(8,2),
 role VARCHAR(255)
);
CREATE TABLE severity_assessment (
 incident_code VARCHAR(30) PRIMARY KEY REFERENCES satlo_incident(incident_code),
 severity_level VARCHAR(100),
 severity_score NUMERIC(6,2),
 evidence_summary TEXT,
 classification_basis TEXT,
 confidence VARCHAR(50),
 note TEXT
);
CREATE TABLE affected_residential (
 id_residential VARCHAR(30) PRIMARY KEY, incident_code VARCHAR(30) REFERENCES satlo_incident(incident_code), households INT, persons INT, impact_status VARCHAR(255), id_reference VARCHAR(30) REFERENCES reference_source(id_reference)
);
CREATE TABLE affected_road (
 id_road VARCHAR(30) PRIMARY KEY, incident_code VARCHAR(30) REFERENCES satlo_incident(incident_code), road_type VARCHAR(150), impact_detail TEXT, id_reference VARCHAR(30) REFERENCES reference_source(id_reference)
);
CREATE TABLE management_work (
 id_work VARCHAR(30) PRIMARY KEY, name VARCHAR(500) NOT NULL, work_type VARCHAR(150), status VARCHAR(150), locality VARCHAR(255), district_historical VARCHAR(150), id_reference VARCHAR(30) REFERENCES reference_source(id_reference)
);
CREATE TABLE management_sources (
 id_management_source VARCHAR(30) PRIMARY KEY, name VARCHAR(500), group_name VARCHAR(150), year INT, id_reference VARCHAR(30) REFERENCES reference_source(id_reference)
);
CREATE TABLE legal_basis (
 id_legal VARCHAR(30) PRIMARY KEY, document_name VARCHAR(500), topic TEXT, application_note TEXT, id_reference VARCHAR(30) REFERENCES reference_source(id_reference)
);
CREATE INDEX idx_incident_geom ON satlo_incident USING GIST (geom);
CREATE INDEX idx_incident_year ON satlo_incident(observed_date);
CREATE INDEX idx_warning_segment_year ON warning_segment(warning_year);
CREATE INDEX idx_incident_warning_incident ON incident_warning_link(incident_code);
CREATE INDEX idx_incident_severity ON satlo_incident(severity_level);
CREATE INDEX idx_severity_assessment_level ON severity_assessment(severity_level);
