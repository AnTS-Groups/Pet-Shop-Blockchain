-----
![Gambar SS]()
![Gambar SS]()
![Gambar SS]()
![Gambar SS]()
![Gambar SS]()
![Gambar SS]()
![Gambar SS]()

## 📄 Penjelasan Detail `README.md` (Aspek Teknis)

### 1\. 🌐 Inisialisasi Web3 (`initWeb3`)

Fungsi ini adalah gerbang utama DApp ke dunia Blockchain.

  * **Modern DApp Browsers (MetaMask):** Kode pertama-tama mengecek keberadaan `window.ethereum`. Jika ada, itu berarti *user* menggunakan *dApp browser* modern (MetaMask, dll.). Kita menggunakan `window.ethereum.enable()` untuk meminta izin kepada pengguna agar DApp dapat mengakses akun mereka.
  * **Fallback (Legacy & Ganache):** Jika MetaMask tidak ditemukan, DApp akan mencoba mencari `window.web3` (untuk *browser* lama). Jika semuanya gagal, DApp akan secara otomatis terhubung ke *node* **Ganache** lokal pada `http://localhost:7545`, yang ideal untuk pengembangan.

### 2\. 📜 Inisialisasi Kontrak (`initContract`)

Ini adalah bagian yang menghubungkan *front-end* dengan *back-end* Smart Contract.

  * **Artifacts (`Adoption.json`):** Truffle menghasilkan file `Adoption.json` setelah kompilasi. File ini berisi **ABI** (Application Binary Interface) yang memberitahu JavaScript fungsi apa saja yang ada di kontrak, dan **Bytecode** kontrak yang sudah di-*deploy*.
  * **`TruffleContract()`:** Kita menggunakan pustaka `@truffle/contract` untuk "mewujudkan" kontrak di JavaScript, lalu menyetel *provider* agar kontrak tahu di jaringan mana dia harus berinteraksi (`App.contracts.Adoption.setProvider(App.web3Provider)`).

### 3\. ✅ Menandai Adopsi (`markAdopted`)

Fungsi ini adalah contoh **Membaca Data** dari Blockchain (**Call**).

  * **`getAdopters.call()`:** Kita memanggil fungsi `getAdopters` dari Smart Contract. Karena kita hanya *membaca* data dan tidak mengubah *state* blockchain, kita menggunakan `.call()`. Ini adalah transaksi gratis (tidak perlu gas).
  * **Logika UI:** Kontrak mengembalikan daftar alamat *adopter*. Jika alamat pada indeks tertentu (sesuai ID hewan) **bukan** alamat nol (`0x0...`), maka hewan tersebut sudah diadopsi, dan kita menonaktifkan tombol adopsi di UI.

### 4\. ✍️ Menangani Adopsi (`handleAdopt`)

Fungsi ini adalah contoh **Menulis Data** ke Blockchain (**Transaction**).

  * **Mendapatkan Akun:** Pertama, kita mengambil akun pengguna saat ini (`web3.eth.getAccounts`).
  * **Mengirim Transaksi:** Kita memanggil `adoptionInstance.adopt(petId, {from: account})`. Perintah ini akan:
    1.  Memicu MetaMask untuk meminta tanda tangan transaksi dari pengguna.
    2.  Mengirim transaksi ke jaringan (Ganache).
    3.  Mengubah *state* di Smart Contract (yaitu, menetapkan alamat pengadopsi untuk ID hewan tersebut).
        *Berbeda dengan `.call()`, operasi ini memerlukan biaya Gas.*

-----

**Untuk visualisasi proses interaksi ini, Anda dapat membayangkan alur seperti ini:**

-----

## 💾 File Content: `README.md`

Berikut adalah *content* lengkap yang dapat Anda simpan sebagai file `README.md` di *root* proyek Anda:

````markdown
# 🐶 Pet Shop Adoption DApp

Sebuah aplikasi terdesentralisasi (DApp) yang dibangun menggunakan Truffle untuk mengelola adopsi hewan peliharaan di jaringan Ethereum lokal (Ganache).

## 🚀 Fitur Utama

* **Pendaftaran Hewan:** Menampilkan daftar 16 hewan peliharaan yang tersedia untuk diadopsi.
* **Adopsi On-Chain:** Mengirim transaksi ke Smart Contract untuk mencatat adopsi.
* **Integrasi Web3:** Interaksi penuh dengan MetaMask/Wallet Connect melalui `app.js`.
* **Status Real-time:** Membaca status adopsi dari Blockchain dan memperbarui antarmuka pengguna (UI).

## 🛠️ Persyaratan Sistem

Pastikan Anda telah menginstal versi terbaru dari perangkat lunak berikut:

1.  **Node.js & npm:** Lingkungan runtime dan manajer paket.
2.  **Truffle:** Kerangka kerja pengembangan Smart Contract.
    ```bash
    npm install -g truffle
    ```
3.  **Ganache:** Blockchain pribadi untuk pengembangan lokal.
4.  **MetaMask:** Ekstensi browser yang terhubung ke jaringan Ganache.

## ⚙️ Setup Proyek

Ikuti langkah-langkah ini di terminal proyek Anda:

### 1. Instal Dependensi

Instal semua paket yang dibutuhkan, termasuk `lite-server` untuk menjalankan front-end.

```bash
npm install
````

### 2\. Jalankan dan Deploy Smart Contract

Pastikan Ganache telah berjalan sebelum langkah ini.

1.  **Kompilasi Kontrak:** Membuat file JSON *artifacts* (`Adoption.json`).
    ```bash
    truffle compile
    ```
2.  **Migrasi (Deploy):** Mengirim kontrak ke jaringan Ganache.
    ```bash
    truffle migrate --reset
    ```

## 💻 Menjalankan DApp

### 1\. Mulai Server Lokal

Perintah ini akan menjalankan `lite-server` dan membuka DApp di browser Anda.

```bash
npm run dev
```

### 2\. Konfigurasi MetaMask

1.  Pastikan MetaMask terhubung ke **Custom RPC/Localhost 7545**.
2.  Impor beberapa akun dari Ganache ke MetaMask untuk digunakan sebagai pengadopsi.

## 📝 Detail Implementasi (`src/js/app.js`)

Logika inti yang menghubungkan UI dan Blockchain:

### `App.initWeb3`

  * Mendeteksi `window.ethereum` (MetaMask modern).
  * Jika tidak ada, fallback ke `window.web3` atau **Ganache HTTP Provider** (`http://localhost:7545`).

### `App.initContract`

  * Memuat `Adoption.json` artifact.
  * Menginisialisasi objek kontrak menggunakan `TruffleContract()`.
  * Memanggil `App.markAdopted()` setelah kontrak diinisialisasi untuk memuat data awal.

### `App.markAdopted` (READ/CALL)

```javascript
return adoptionInstance.getAdopters.call();
```

  * Memanggil fungsi `getAdopters()` di Smart Contract untuk mengambil array alamat pengadopsi.
  * Karena ini adalah panggilan `.call()`, tidak ada biaya Gas.
  * Memperbarui UI: Jika alamat pengadopsi tidak nol (`0x0...`), tombol diubah menjadi "Success" dan dinonaktifkan.

### `App.handleAdopt` (WRITE/TRANSACTION)

```javascript
return adoptionInstance.adopt(petId, {from: account});
```

  * Mengambil akun pengguna saat ini (`web3.eth.getAccounts`).
  * Mengirim transaksi `adopt()` ke Smart Contract, menyertakan ID hewan dan alamat pengirim.
  * Ini adalah operasi **Write** yang memerlukan biaya Gas dan memicu pop-up konfirmasi di MetaMask.

-----
