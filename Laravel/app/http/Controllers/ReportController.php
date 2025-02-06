<?php

namespace App\Http\Controllers;

use App\Models\Pinjam;
use App\Models\Ruangan;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

public function report(Request $request)
{
    $filter = $request->get('filter');
    $query = DB::table('pinjams')
        ->select('nama_ruang', DB::raw('count(*) as total'))
        ->where('status', 'disetujui');

    if ($filter === 'bulan') {
        $query->whereMonth('created_at', date('m'))
            ->whereYear('created_at', date('Y'));
    } elseif ($filter === 'semester') {
        $currentMonth = date('m');
        $semester = ($currentMonth >= 1 && $currentMonth <= 6) ? [1, 6] : [7, 12];
        $query->whereBetween(DB::raw('MONTH(created_at)'), $semester)
            ->whereYear('created_at', date('Y'));
    } elseif ($filter === 'tahun') {
        $query->whereYear('created_at', date('Y'));
    }

    $dataRuangan = $query->groupBy('nama_ruang')->get();

    return response()->json($dataRuangan);
}
?>
