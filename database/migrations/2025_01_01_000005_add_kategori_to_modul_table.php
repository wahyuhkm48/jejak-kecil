<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('modul', function (Blueprint $table) {
            // Tambah kolom kategori jika belum ada
            if (!Schema::hasColumn('modul', 'kategori')) {
                $table->string('kategori')->default('Umum')->after('thumbnail');
            }
        });
    }

    public function down(): void
    {
        Schema::table('modul', function (Blueprint $table) {
            if (Schema::hasColumn('modul', 'kategori')) {
                $table->dropColumn('kategori');
            }
        });
    }
};
