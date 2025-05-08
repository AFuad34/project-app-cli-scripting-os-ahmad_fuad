#!/bin/bash

data_file="pemakaian_bulanan.txt"
tarif_per_kwh=1500 # Contoh tarif Rp 1500 per kWh (bisa disesuaikan)

tambah_data() {
  echo "-----------------------------------------"
  echo "TAMBAH DATA PEMAKAIAN BULANAN"
  echo "-----------------------------------------"
  read -p "Masukkan bulan (contoh: Januari): " bulan_tambah
  read -p "Masukkan jumlah pemakaian (kWh): " pemakaian_kwh

  if ! echo "$bulan_tambah,$pemakaian_kwh" >> "$data_file"; then
    echo "-----------------------------------------"
    echo "ERROR: Gagal menulis data ke file pemakaian_bulanan.txt."
    echo "Pastikan file memiliki izin menulis."
    echo "-----------------------------------------"
  else
    echo "-----------------------------------------"
    echo "Data pemakaian bulan: $bulan_tambah (${pemakaian_kwh} kWh) berhasil ditambahkan."
    echo "-----------------------------------------"
  fi
}

lihat_data() {
  echo "-----------------------------------------"
  echo "LIHAT DATA PEMAKAIAN BULANAN"
  echo "-----------------------------------------"
  if [ -f "$data_file" ]; then
    while IFS=',' read -r bulan pemakaian; do
      echo "Bulan: $bulan, Pemakaian: $pemakaian kWh"
    done < "$data_file"
  else
    echo "Belum ada data pemakaian yang ditambahkan."
  fi
  echo "-----------------------------------------"
}

hapus_data() {
  echo "-----------------------------------------"
  echo "HAPUS DATA PEMAKAIAN BULANAN"
  echo "-----------------------------------------"
  read -p "Masukkan bulan data yang ingin dihapus (contoh: Januari): " bulan_hapus

  # Menghapus baris yang diawali dengan bulan yang dimasukkan (setelah whitespace dihilangkan)
  sed -i "/^$(echo "$bulan_hapus" | tr -d '[:space:]'),/d" "$data_file"

  echo "-----------------------------------------"
  echo "Mencoba menghapus data untuk bulan $(echo "$bulan_hapus")."
  echo "Silakan lihat data untuk memastikan penghapusan."
  echo "-----------------------------------------"
}

analisis_tarif_kwh() {
  echo "-----------------------------------------"
  echo "ANALISIS TARIF PEMAKAIAN PER KWH"
  echo "-----------------------------------------"
  if [ -f "$data_file" ]; then
    echo "Masukkan bulan yang ingin dianalisis (contoh: Januari): "
    read bulan_analisis

    # Validasi input bulan tidak kosong
    if [ -z "$bulan_analisis" ]; then
      echo "PERINGATAN: Bulan tidak boleh kosong."
      return 1
    fi

    total_pemakaian=0
    IFS=$'\n' read -r -d '' lines < "$data_file"
    while IFS=',' read -r bulan pemakaian_kwh; do
      bulan_analisis_bersih=$(echo "$bulan_analisis" | tr -d '[:space:]')
      bulan_data_bersih=$(echo "$bulan" | tr -d '[:space:]')

      if [[ "$bulan_analisis_bersih" == "$bulan_data_bersih" ]]; then
        total_pemakaian=$((total_pemakaian + pemakaian_kwh))
      fi
    done < "$data_file"

    if [ "$total_pemakaian" -gt 0 ]; then
      total_tarif=$((total_pemakaian * tarif_per_kwh))
      echo "Bulan: $bulan_analisis, Total Pemakaian: $total_pemakaian kWh, Total Tarif: Rp $total_tarif"
    else
      echo "Tidak ada data pemakaian untuk bulan $bulan_analisis."
    fi
  else
    echo "Belum ada data pemakaian untuk dianalisis tarifnya."
  fi
  echo "-----------------------------------------"
}

while true; do
  echo "Pilih tindakan:"
  echo "1. Tambah data Pemakaian Bulanan (kWh)"
  echo "2. Lihat Data Pemakaian Bulanan yang telah ditambahkan"
  echo "3. Hapus Data Pemakaian Bulanan"
  echo "4. Analisis tarif pemakaian per kWh"
  echo "5. Keluar"
  read -p "Masukkan pilihan Anda: " pilihan

# LOOP
  case "$pilihan" in
    1)
      tambah_data
      ;;
    2)
      lihat_data
      ;;
    3)
      hapus_data
      ;;
    4)
      analisis_tarif_kwh
      ;;
    5)
      echo "Keluar dari program."
      break
      ;;
    *)
      echo "Pilihan tidak valid. Silakan coba lagi."
      ;;
  esac
done