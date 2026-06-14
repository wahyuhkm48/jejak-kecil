<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class GayaBelajar extends Model
{
    protected $table = 'gaya_belajar';

    protected $fillable = [
        'nama_gaya',
        'deskripsi'
    ];

    public function anak()
    {
        return $this->hasMany(
            Anak::class,
            'id_gaya_belajar'
        );
    }
}