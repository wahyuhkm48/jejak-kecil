<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Pengguna;
use App\Models\GayaBelajar;

class Anak extends Model
{
    protected $table = 'anak';

    protected $fillable = [
        'id_pengguna',
        'id_gaya_belajar',
        'nama_panggilan',
        'tanggal_lahir',
        'level_anak',
        'total_poin',
        'avatar'
    ];

    public function pengguna()
    {
        return $this->belongsTo(Pengguna::class, 'id_pengguna');
    }

    public function gayaBelajar()
    {
        return $this->belongsTo(
            GayaBelajar::class,
            'id_gaya_belajar'
        );
    }
}