
CREATE SCHEMA IF NOT EXISTS salam;

CREATE TABLE IF NOT EXISTS salam.mahasiswas (
    id_mahasiswa SERIAL PRIMARY KEY,                              
    nim          VARCHAR(10)  NOT NULL UNIQUE,                    
    nama         VARCHAR(100) NOT NULL,
    email        VARCHAR(120) NOT NULL UNIQUE,                    
    ipk          NUMERIC(3,2) CHECK (ipk >= 0.00 AND ipk <= 4.00),
    semester     INT          CHECK (semester BETWEEN 1 AND 14),  
    prodi        VARCHAR(50)  DEFAULT 'Informatika',
    created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO salam.mahasiswas (nim, nama, email, ipk, semester) VALUES
('1247050014', 'Ria Melisa', 'melisa06@gmail.com', 3.75, 5),
('1247050012', 'Kimi Antonelli', 'kimi06@gmail.com', 3.40, 5),
('1247050063', 'George Russell', 'george06@gmail.com', 3.90, 5);

CREATE OR REPLACE VIEW salam.v_mahasiswa_berprestasi AS
SELECT nim, nama, ipk
FROM salam.mahasiswas
WHERE ipk >= 3.50;

