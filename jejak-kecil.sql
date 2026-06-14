-- =============================================
-- 1. PENGGUNA
-- =============================================
CREATE TABLE pengguna (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'orang_tua') NOT NULL DEFAULT 'orang_tua',
    foto VARCHAR(255) NULL,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =============================================
-- 2. GAYA BELAJAR
-- =============================================
CREATE TABLE gaya_belajar (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama_gaya VARCHAR(255) NOT NULL,
    deskripsi TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =============================================
-- 3. ANAK
-- =============================================
CREATE TABLE anak (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pengguna BIGINT UNSIGNED NOT NULL,
    id_gaya_belajar BIGINT UNSIGNED NULL,
    nama_panggilan VARCHAR(255) NOT NULL,
    tanggal_lahir DATE NULL,
    level_anak INT DEFAULT 1,
    total_poin INT DEFAULT 0,
    avatar VARCHAR(255) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id) ON DELETE CASCADE,
    FOREIGN KEY (id_gaya_belajar) REFERENCES gaya_belajar(id) ON DELETE SET NULL
);

-- =============================================
-- 4. MODUL
-- =============================================
CREATE TABLE modul (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_gaya_belajar BIGINT UNSIGNED NULL,
    judul_modul VARCHAR(255) NOT NULL,
    deskripsi TEXT NULL,
    tingkat_kesulitan ENUM('mudah', 'sedang', 'sulit') NOT NULL DEFAULT 'mudah',
    thumbnail VARCHAR(255) NULL,
    kategori VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_gaya_belajar) REFERENCES gaya_belajar(id) ON DELETE SET NULL
);

-- =============================================
-- 5. ISI MODUL
-- =============================================
CREATE TABLE isi_modul (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_modul BIGINT UNSIGNED NOT NULL,
    tipe_konten ENUM('video', 'teks', 'gambar', 'audio') NOT NULL,
    isi_konten TEXT NOT NULL,
    urutan INT DEFAULT 1,
    judul_konten VARCHAR(255) NULL,
    deskripsi_konten TEXT NULL,
    durasi_menit INT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_modul) REFERENCES modul(id) ON DELETE CASCADE
);

-- =============================================
-- 6. KUIS
-- =============================================
CREATE TABLE kuis (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_modul BIGINT UNSIGNED NOT NULL,
    pertanyaan TEXT NOT NULL,
    gambar_pertanyaan VARCHAR(255) NULL,
    pilihan_a VARCHAR(255) NOT NULL,
    pilihan_b VARCHAR(255) NOT NULL,
    pilihan_c VARCHAR(255) NULL,
    pilihan_d VARCHAR(255) NULL,
    jawaban_benar ENUM('a', 'b', 'c', 'd') NOT NULL,
    poin INT DEFAULT 10,
    urutan INT DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_modul) REFERENCES modul(id) ON DELETE CASCADE
);

-- =============================================
-- 7. PROGRESS ANAK
-- =============================================
CREATE TABLE progress_anak (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_anak BIGINT UNSIGNED NOT NULL,
    id_modul BIGINT UNSIGNED NOT NULL,
    persentase_progress INT DEFAULT 0,
    skor INT NULL,
    status ENUM('belum_dimulai', 'sedang_dipelajari', 'selesai') DEFAULT 'belum_dimulai',
    tanggal_selesai TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_anak) REFERENCES anak(id) ON DELETE CASCADE,
    FOREIGN KEY (id_modul) REFERENCES modul(id) ON DELETE CASCADE
);

-- =============================================
-- 8. REWARD
-- =============================================
CREATE TABLE reward (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama_reward VARCHAR(255) NOT NULL,
    deskripsi TEXT NULL,
    harga_poin INT NOT NULL DEFAULT 0,
    gambar VARCHAR(255) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =============================================
-- 9. REWARD ANAK
-- =============================================
CREATE TABLE reward_anak (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_anak BIGINT UNSIGNED NOT NULL,
    id_reward BIGINT UNSIGNED NOT NULL,
    tanggal_diklaim DATETIME NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_anak) REFERENCES anak(id) ON DELETE CASCADE,
    FOREIGN KEY (id_reward) REFERENCES reward(id) ON DELETE CASCADE
);

-- =============================================
-- 10. NOTIFIKASI
-- =============================================
CREATE TABLE notifikasi (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_anak BIGINT UNSIGNED NOT NULL,
    judul VARCHAR(255) NOT NULL,
    pesan TEXT NOT NULL,
    status_dibaca TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_anak) REFERENCES anak(id) ON DELETE CASCADE
);

-- =============================================
-- 11. LOG AKTIVITAS
-- =============================================
CREATE TABLE log_aktivitas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pengguna BIGINT UNSIGNED NOT NULL,
    aktivitas VARCHAR(255) NOT NULL,
    nama_tabel VARCHAR(255) NULL,
    data_id BIGINT NULL,
    deskripsi TEXT NULL,
    dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id) ON DELETE CASCADE
);

-- =============================================
-- 12. SPESIALIS
-- =============================================
CREATE TABLE spesialis (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    gelar VARCHAR(100) NULL,
    spesialisasi VARCHAR(255) NULL,
    deskripsi TEXT NULL,
    foto VARCHAR(255) NULL,
    rating DECIMAL(3,1) DEFAULT 0.0,
    jumlah_ulasan INT DEFAULT 0,
    biaya_sesi DECIMAL(10,2) DEFAULT 0,
    tersedia TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =============================================
-- 13. KEAHLIAN SPESIALIS
-- =============================================
CREATE TABLE keahlian_spesialis (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_spesialis BIGINT UNSIGNED NOT NULL,
    keahlian VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_spesialis) REFERENCES spesialis(id) ON DELETE CASCADE
);

-- =============================================
-- 14. JADWAL KONSULTASI
-- =============================================
CREATE TABLE jadwal_konsultasi (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pengguna BIGINT UNSIGNED NOT NULL,
    id_spesialis BIGINT UNSIGNED NOT NULL,
    judul_sesi VARCHAR(255) NOT NULL,
    waktu_mulai DATETIME NOT NULL,
    waktu_selesai DATETIME NULL,
    status ENUM('akan_datang', 'selesai', 'dibatalkan') DEFAULT 'akan_datang',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id) ON DELETE CASCADE,
    FOREIGN KEY (id_spesialis) REFERENCES spesialis(id) ON DELETE CASCADE
);

-- =============================================
-- 15. PESAN KONSULTASI
-- =============================================
CREATE TABLE pesan_konsultasi (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_jadwal BIGINT UNSIGNED NOT NULL,
    pengirim ENUM('pengguna', 'spesialis') NOT NULL,
    isi_pesan TEXT NOT NULL,
    lampiran VARCHAR(255) NULL,
    nama_lampiran VARCHAR(255) NULL,
    sudah_dibaca TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_jadwal) REFERENCES jadwal_konsultasi(id) ON DELETE CASCADE
);

-- =============================================
-- 16. AVATAR SHOP
-- =============================================
CREATE TABLE avatar_shop (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama_avatar VARCHAR(255) NOT NULL,
    gambar VARCHAR(255) NOT NULL,
    harga_poin INT NOT NULL DEFAULT 0,
    warna_background VARCHAR(50) NULL,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =============================================
-- 17. TRANSAKSI POIN
-- =============================================
CREATE TABLE transaksi_poin (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_anak BIGINT UNSIGNED NOT NULL,
    id_avatar_shop BIGINT UNSIGNED NULL,
    tipe ENUM('masuk', 'keluar') NOT NULL,
    jumlah_poin INT NOT NULL,
    keterangan VARCHAR(255) NULL,
    saldo_setelah INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_anak) REFERENCES anak(id) ON DELETE CASCADE,
    FOREIGN KEY (id_avatar_shop) REFERENCES avatar_shop(id) ON DELETE SET NULL
);