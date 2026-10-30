SELECT * FROM salam.mahasiswas;

INSERT INTO salam.mahasiswas (nim, nama, email, ipk, semester)
VALUES ('1247050099', 'Uji Valid', 'uji.valid@gmail.com', 3.20, 3);

INSERT INTO salam.mahasiswas (nim, nama, email, ipk, semester)
VALUES ('1247050014', 'NIM Duplikat', 'lain@gmail.com', 3.00, 2);

INSERT INTO salam.mahasiswas (nim, nama, email, ipk, semester)
VALUES ('1247050100', 'Email Duplikat', 'kimi06@gmail.com', 3.00, 2);

INSERT INTO salam.mahasiswas (nim, nama, email, ipk, semester)
VALUES ('1247050101', 'IPK Ngaco', 'ipk.ngaco@gmail.com', 4.50, 2);

INSERT INTO salam.mahasiswas (nim, nama, email, ipk, semester)
VALUES ('1247050102', 'Semester Nol', 'sem.nol@gmail.com', 3.00, 0);

INSERT INTO salam.mahasiswas (id_mahasiswa, nim, nama, email, ipk, semester)
VALUES (1, '1247050103', 'PK Duplikat', 'pk.duplikat@gmail.com', 3.00, 1);

SELECT * FROM salam.mahasiswas;

SELECT conname AS nama_constraint, contype AS tipe
FROM pg_constraint
WHERE conrelid = 'salam.mahasiswas'::regclass
ORDER BY contype;
