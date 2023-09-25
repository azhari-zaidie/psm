<?php

namespace App\Http\Controllers;

use App\Models\MakroFeature;
use App\Models\Record;
use App\Models\RecordItems;
use Illuminate\Http\Request;

class ApiRecordController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $records = Record::all();
        //$records = Record::orderBy('created_at', 'DESC')->get();

        return response()->json([
            'success' => true,
            'recordData' => $records,
        ]);
    }


    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $request->validate([
            'selected_makro' => 'required',
            'user_id' => 'required|exists:users,user_id',
            'record_average' => 'required|numeric',
            'location' => 'required',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
        ]);

        //dd($request->all());

        $record = Record::create([
            'user_id' => $request->user_id,
            'record_average' => $request->record_average,
            'location' => $request->location,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'record_desc' => $request->record_desc,
        ]);

        $selected_makro = explode('|', $request->selected_makro);

        foreach ($selected_makro as $data) {
            $makro = json_decode($data, true);
            $makros[] = $makro;
            //dd($makro);
        }

        foreach ($makros as $itm) {
            $recordItems = RecordItems::create([
                'record_id' => $record->record_id,
                'makro_id' => $itm['makro_id'],
            ]);
        }
        //dd($makroFeature);

        return response()->json([
            'success' => true,
            'data' => $record,
            'makro' => $makro,
            'record' => $recordItems
        ]);
    }
    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $record = Record::where('user_id', $id)
            ->orderByDesc('created_at')
            ->get();

        //$makro $record->recordItems->makro;

        if (!$record) {
            return response()->json([
                'success' => false,
                'message' => 'Record not found',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'recordData' => $record,
        ]);
    }

    public function showItems($id)
    {
        $recordItems = RecordItems::where('record_id', $id)
            ->with('makro')
            ->get();

        return response()->json([
            'success' => true,
            'recordItems' => $recordItems
        ]);
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

        $record = Record::where('record_id', $id)->first();

        //dd($record);
        $recordItems = $record->recordItems;

        //dd($recordItems);

        foreach ($recordItems as $itm) {
            $itm->delete();
        }

        $record->delete();
        //$recordItems->delete();

        return response()->json([
            'success' => true,
        ]);
    }
}
