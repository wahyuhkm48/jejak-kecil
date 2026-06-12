<?php

namespace App\Http\Controllers\Pengguna;

use App\Http\Controllers\Controller;
use App\Models\Spesialis;
use App\Models\JadwalKonsultasi;
use App\Models\PesanKonsultasi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class KonsultasiController extends Controller
{
    /**
     * Halaman index: daftar spesialis + jadwal saya
     */
    public function index(Request $request)
    {
        $pengguna = Auth::user();

        // Query spesialis dengan keahlian
        $query = Spesialis::with('keahlian')->where('tersedia', true);

        // Pencarian
        if ($request->filled('search')) {
            $cari = $request->search;
            $query->where(function ($q) use ($cari) {
                $q->where('nama', 'like', "%$cari%")
                  ->orWhere('spesialisasi', 'like', "%$cari%");
            });
        }

        $spesialisList = $query->orderBy('rating', 'desc')->get();

        // Jadwal milik pengguna ini
        $jadwalSaya = JadwalKonsultasi::with('spesialis')
            ->where('id_pengguna', $pengguna->id)
            ->orderBy('waktu_mulai', 'asc')
            ->get();

        $jadwalAkanDatang = $jadwalSaya->where('status', 'akan_datang')->first();
        $jadwalSelesai    = $jadwalSaya->where('status', 'selesai')->take(3);

        return view('pengguna.konsultasi.index', compact(
            'spesialisList',
            'jadwalAkanDatang',
            'jadwalSelesai',
            'jadwalSaya'
        ));
    }

    /**
     * Buat jadwal konsultasi baru dengan spesialis
     */
    public function buatJadwal(Request $request, $idSpesialis)
    {
        $spesialis = Spesialis::findOrFail($idSpesialis);
        $pengguna  = Auth::user();

        // Buat jadwal baru (waktu default: besok jam 10 pagi)
        $jadwal = JadwalKonsultasi::create([
            'id_pengguna' => $pengguna->id,
            'id_spesialis' => $spesialis->id,
            'judul_sesi'   => 'Konsultasi dengan ' . $spesialis->nama,
            'waktu_mulai'  => now()->addDay()->setTime(10, 0),
            'status'       => 'akan_datang',
        ]);

        // Langsung masuk ke halaman chat
        return redirect()->route('pengguna.konsultasi.chat', $jadwal->id)
            ->with('success', 'Jadwal konsultasi berhasil dibuat!');
    }

    /**
     * Halaman chat konsultasi
     */
    public function chat($idJadwal)
    {
        $pengguna = Auth::user();

        $jadwal = JadwalKonsultasi::with(['spesialis', 'pesan'])
            ->where('id_pengguna', $pengguna->id)
            ->findOrFail($idJadwal);

        // Tandai pesan spesialis sebagai sudah dibaca
        $jadwal->pesan()
            ->where('pengirim', 'spesialis')
            ->where('sudah_dibaca', false)
            ->update(['sudah_dibaca' => true]);

        return view('pengguna.konsultasi.chat', compact('jadwal'));
    }

    /**
     * Kirim pesan baru
     */
    public function kirimPesan(Request $request, $idJadwal)
    {
        $request->validate([
            'isi_pesan' => 'required|string|max:2000',
            'lampiran'  => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:5120',
        ]);

        $pengguna = Auth::user();

        $jadwal = JadwalKonsultasi::where('id_pengguna', $pengguna->id)
            ->findOrFail($idJadwal);

        $lampiranPath = null;
        $namaLampiran = null;

        if ($request->hasFile('lampiran')) {
            $file         = $request->file('lampiran');
            $namaLampiran = $file->getClientOriginalName();
            $lampiranPath = $file->store('lampiran-konsultasi', 'public');
        }

        PesanKonsultasi::create([
            'id_jadwal'     => $jadwal->id,
            'pengirim'      => 'pengguna',
            'isi_pesan'     => $request->isi_pesan,
            'lampiran'      => $lampiranPath,
            'nama_lampiran' => $namaLampiran,
            'sudah_dibaca'  => false,
        ]);

        return redirect()->route('pengguna.konsultasi.chat', $idJadwal);
    }

    /**
     * Lihat semua jadwal
     */
    public function semuaJadwal()
    {
        $pengguna = Auth::user();

        $jadwalSaya = JadwalKonsultasi::with('spesialis')
            ->where('id_pengguna', $pengguna->id)
            ->orderBy('waktu_mulai', 'desc')
            ->get();

        return view('pengguna.konsultasi.jadwal', compact('jadwalSaya'));
    }
}
