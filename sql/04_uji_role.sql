
SET ROLE backend_dev;
SELECT current_user;                                                   
SELECT * FROM salam.mahasiswas;                                     

INSERT INTO salam.mahasiswas (nim, nama, email, ipk, semester)
VALUES ('1247050201', 'Insert Backend', 'insert.be@gmail.com', 3.10, 4);   

UPDATE salam.mahasiswas SET ipk = 3.15 WHERE nim = '1247050201';      
DELETE FROM salam.mahasiswas WHERE nim = '1247050201';              

CREATE TABLE salam.tabel_terlarang (id INT);                           

DROP TABLE salam.mahasiswas;                                          
RESET ROLE;

SET ROLE bi_dev;
SELECT current_user;                                                   

SELECT * FROM salam.mahasiswas;                                        
SELECT * FROM salam.v_mahasiswa_berprestasi;                           

INSERT INTO salam.mahasiswas (nim, nama, email, ipk, semester)
VALUES ('1247050202', 'Insert BI', 'insert.bi@gmail.com', 3.00, 4);    

UPDATE salam.mahasiswas SET ipk = 4.00 WHERE nim = '1247050012';       
DELETE FROM salam.mahasiswas WHERE nim = '1247050012';                

RESET ROLE;

SET ROLE data_engineer;
SELECT current_user;                                                   
CREATE TABLE salam.tabel_eksperimen (                                  
    id SERIAL PRIMARY KEY,
    keterangan VARCHAR(50)
);

ALTER TABLE salam.tabel_eksperimen ADD COLUMN aktif BOOLEAN;           

INSERT INTO salam.tabel_eksperimen (keterangan, aktif)
VALUES ('uji data engineer', true);                                   

UPDATE salam.tabel_eksperimen SET keterangan = 'sudah diubah' WHERE id = 1;  
DELETE FROM salam.tabel_eksperimen WHERE id = 1;                       

ALTER TABLE salam.mahasiswas ADD COLUMN no_hp VARCHAR(15);             
ALTER TABLE salam.mahasiswas DROP COLUMN no_hp;                       

DROP TABLE salam.tabel_eksperimen;                                    

RESET ROLE;