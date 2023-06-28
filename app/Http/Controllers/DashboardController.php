<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Makro;
use App\Models\Record;
use App\Models\FamilyMakro;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $records = Record::all();

        $recordsChart = Record::select('users.user_name', DB::raw('COUNT(records.record_id) as total_record'))
            ->join('users', 'users.user_id', '=', 'records.user_id')
            ->groupBy('users.user_name')
            ->get();

        $usersCount = User::count();
        $recordsCount = Record::count();
        $makroCount = Makro::count();
        $makroCountVerified = Makro::where('status', 'Verified')->count();
        $familyMakroCount = FamilyMakro::count();

        $labels = $recordsChart->pluck('user_name')->toArray();
        $values = $recordsChart->pluck('total_record')->toArray();

        $selectedMakroCount = [];

        //$selected_makro = json_decode($records->selected_makro);
        //dd($records->selected_makro);
        $makros = [];
        foreach ($records as $r) {
            $selected_makro = explode('|', $r->selected_makro);

            foreach ($selected_makro as $data) {
                $makro = json_decode($data, true);
                $makros[] = $makro;
                //dd($makros);
            }
        }
        //$makroId = [];
        $count = [];
        foreach ($makros as $m) {
            $makroId = $m['makro_name'];

            if (!isset($count[$makroId])) {
                $count[$makroId] = 0;
            }

            $count[$makroId]++;
            // dd($makroId);
        }

        // $labels = $recordsChart->pluck('user_name')->toArray();
        //$values = $recordsChart->pluck('total_record')->toArray();


        // foreach ($count as $makroId => $count) {
        //     echo "Count of makro_id $makroId: $count" . PHP_EOL;
        // }

        return view('dashboard', compact('usersCount', 'recordsCount', 'makroCount', 'familyMakroCount', 'makroCountVerified', 'labels', 'values', 'count'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
