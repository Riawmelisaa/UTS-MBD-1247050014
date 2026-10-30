# UTS Manajemen Basis Data: Proyek 1

| | |
|---|---|
| **Nama** | Ria Melisa |
| **NIM** | 1247050014 |
| **Mata Kuliah** | Manajemen Basis Data |
| **Dosen** | Wildan Budiawan Z, S.T., M.Kom |

Proyek kontainerisasi **PostgreSQL 15** dan **pgAdmin4** menggunakan Docker Compose, lengkap dengan skema `salam`, tabel `mahasiswas` (PRIMARY KEY, UNIQUE, CHECK), dan tiga user dengan hak akses berbeda.

---

## Ringkasan Konfigurasi

| Komponen | Nilai |
|---|---|
| Image PostgreSQL | `postgres:15-alpine` |
| Image pgAdmin | `dpage/pgadmin4:8.14` |
| Nama container | `postgres_melisa`, `pgadmin_melisa` |
| Port PostgreSQL (eksternal) | `22014` (22 + 3 digit terakhir NIM) |
| Port pgAdmin (eksternal) | `44014` (44 + 3 digit terakhir NIM) |
| Kredensial | Disimpan di `.env` (tidak ikut di-push) |
| Volume | `pgdata_melisa`, `pgadmin_data_melisa` (data tetap ada saat container dimatikan) |
| Network | `net_melisa` |

---

## Struktur Folder

```
proyek_uts_basis_data/
├── docker-compose.yml        # 2 service: postgres dan pgadmin
├── .env.example              # contoh isi .env (nilai dummy)
├── .gitignore                # menyembunyikan .env
├── README.md
├── init/                     # dijalankan OTOMATIS saat database pertama kali dibuat
│   ├── 01_skema_tabel.sql    # skema salam, tabel mahasiswas, data awal, view
│   └── 02_user_role.sql      # 3 user dan hak akses (GRANT)
└── sql/                      # script pengujian, dijalankan MANUAL
    ├── 03_uji_constraint.sql # bukti PRIMARY KEY, UNIQUE, CHECK bekerja
    └── 04_uji_role.sql       # bukti hak akses tiap user bekerja
```

> Script pengujian sengaja dipisah ke folder `sql/`. Script `03` berisi query yang **memang harus error**, sehingga kalau diletakkan di `init/`, PostgreSQL akan gagal start.

---

## Cara Menjalankan

**Prasyarat:** Docker Desktop sudah terpasang dan berstatus *running*.

1. Salin `.env.example` menjadi `.env`, lalu isi nilainya sesuai ketentuan soal.
   ```bash
   copy .env.example .env
   ```
2. Jalankan container:
   ```bash
   docker compose up -d
   ```
3. Cek kedua container berjalan (`postgres_melisa` harus `healthy`):
   ```bash
   docker ps
   ```

### Isi `.env`

```
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_DB=postgres

PGADMIN_DEFAULT_EMAIL=
PGADMIN_DEFAULT_PASSWORD=
```

### Reset dari nol

Script di `init/` hanya berjalan saat volume baru dibuat. Untuk mengulang dari awal:

```bash
docker compose down -v
docker compose up -d
```

> Perintah `down -v` **menghapus semua data**. Gunakan `docker compose down` (tanpa `-v`) jika hanya ingin mematikan container.

---

## Akses Database

| Akses | Tool | Alamat | Keterangan |
|---|---|---|---|
| **Eksternal Docker** | DBeaver | `localhost:22014` | database `postgres`, user `postgres` |
| **Internal Docker** | pgAdmin4 | `http://localhost:44014` | saat mendaftarkan server: host `postgres`, port `5432` |

Perbedaan kuncinya: DBeaver masuk dari luar Docker lewat port yang di-*expose* (`22014`), sedangkan pgAdmin berada di jaringan Docker yang sama sehingga memanggil PostgreSQL lewat nama service (`postgres`) dan port internal (`5432`).

---

## Skema dan Tabel

Skema `salam`, tabel `mahasiswas`:

| Kolom | Tipe | Constraint |
|---|---|---|
| `id_mahasiswa` | SERIAL | **PRIMARY KEY** |
| `nim` | VARCHAR(10) | NOT NULL, **UNIQUE** |
| `nama` | VARCHAR(100) | NOT NULL |
| `email` | VARCHAR(120) | NOT NULL, **UNIQUE** |
| `ipk` | NUMERIC(3,2) | **CHECK** (0.00 sampai 4.00) |
| `semester` | INT | **CHECK** (1 sampai 14) |
| `prodi` | VARCHAR(50) | DEFAULT `'Informatika'` |
| `created_at` | TIMESTAMP | DEFAULT `CURRENT_TIMESTAMP` |

Ditambah view `salam.v_mahasiswa_berprestasi` (mahasiswa dengan IPK 3.50 ke atas).

---

## User dan Hak Akses

| User | Peran | Boleh | Ditolak |
|---|---|---|---|
| `backend_dev` | CRUD semua tabel | SELECT, INSERT, UPDATE, DELETE | CREATE TABLE, DROP TABLE |
| `bi_dev` | Hanya baca | SELECT (tabel dan view) | INSERT, UPDATE, DELETE |
| `data_engineer` | DDL + CRUD | CREATE, ALTER, DROP, dan CRUD | (tidak ada) |

Password ketiga user ada di `init/02_user_role.sql`. Ketiganya bukan superuser, sehingga seluruh hak berasal dari `GRANT` (prinsip *least privilege*).

---

## Menjalankan Pengujian

Pengujian dijalankan manual setelah container *healthy*, lewat DBeaver (Ctrl+Enter per query) atau lewat terminal:

```bash
# Uji constraint (query pelanggaran harus menghasilkan error)
docker exec -i postgres_melisa psql -U postgres -a < sql/03_uji_constraint.sql

# Uji hak akses tiap user
docker exec -i postgres_melisa psql -U postgres -a < sql/04_uji_role.sql
```

Hasil yang diharapkan:

- **Constraint:** insert data valid berhasil; NIM duplikat, email duplikat, IPK 4.50, semester 0, dan ID duplikat **ditolak** dengan pesan nama constraint-nya (`mahasiswas_nim_key`, `mahasiswas_email_key`, `mahasiswas_ipk_check`, `mahasiswas_semester_check`, `mahasiswas_pkey`).
- **Hak akses:** operasi yang diizinkan berhasil, dan yang tidak diizinkan ditolak dengan `permission denied` atau `must be owner of table`.

---

## Fitur Pembeda

- Data diri sendiri sebagai baris pertama tabel `mahasiswas`.
- View `v_mahasiswa_berprestasi` untuk menyaring mahasiswa ber-IPK tinggi.
- Kolom `created_at` dan nilai default `prodi`.
- *Healthcheck* pada PostgreSQL dan `depends_on: condition: service_healthy` agar pgAdmin baru menyala setelah database siap.
- Volume terpisah untuk pgAdmin, sehingga konfigurasi server tidak hilang saat container dibuat ulang.
- Hak `USAGE` dan `SELECT` pada sequence agar INSERT ke kolom `SERIAL` berhasil, serta kepemilikan objek diberikan ke `data_engineer` agar ia dapat mengubah dan menghapus semua objek.
- Verifikasi bahwa ketiga user bukan superuser (`rolsuper = false`).
- Pengujian constraint dan hak akses terdokumentasi dalam script terpisah.

---

## Catatan Keamanan

- File `.env` **tidak** di-push (terdaftar di `.gitignore`); hanya `.env.example` dengan nilai dummy yang ada di repository.
- Username dan password PostgreSQL maupun pgAdmin **tidak** di-*hardcode* di `docker-compose.yml`. Semuanya dibaca dari `.env`.
