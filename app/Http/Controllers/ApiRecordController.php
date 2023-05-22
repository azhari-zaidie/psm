<?php

namespace App\Http\Controllers;

use App\Models\Record;
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

        $record = Record::create([
            'selected_makro' => $request->selected_makro,
            'user_id' => $request->user_id,
            'record_average' => $request->record_average,
            'location' => $request->location,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
        ]);

        return response()->json([
            'success' => true,
            'data' => $record,
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
        $record = Record::where('user_id', $id)->get();

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
