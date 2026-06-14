<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class IsiModul extends Model
{
    protected $table = 'isi_modul';

    protected $fillable = [
        'id_modul',
        'tipe_konten',
        'isi_konten',
        'urutan',
        'judul_konten',
        'deskripsi_konten',
        'durasi_menit',
    ];

    public function modul(): BelongsTo
    {
        return $this->belongsTo(Modul::class, 'id_modul');
    }
}