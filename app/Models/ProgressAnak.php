<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProgressAnak extends Model
{
    protected $table = 'progress_anak';

    protected $fillable = [
        'id_anak',
        'id_modul',
        'persentase_progress',
        'skor',
        'status',
        'tanggal_selesai',
    ];

    protected $casts = [
        'tanggal_selesai' => 'datetime',
    ];

    public function anak(): BelongsTo
    {
        return $this->belongsTo(Anak::class, 'id_anak');
    }

    public function modul(): BelongsTo
    {
        return $this->belongsTo(Modul::class, 'id_modul');
    }

    /**
     * Label status yang ramah untuk tampilan
     */
    public function getLabelStatusAttribute(): string
    {
        return match ($this->status) {
            'belum_dimulai'    => 'Belum Dimulai',
            'sedang_dipelajari' => 'Sedang Dipelajari',
            'selesai'          => 'Hampir Selesai',
            default            => 'Belum Dimulai',
        };
    }
}