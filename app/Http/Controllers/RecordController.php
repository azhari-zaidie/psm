<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Record;
use App\Models\Makro;
use App\Models\MakroFeature;
use App\Models\RecordItems;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Http\Request;

class RecordController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        //

        $records = Record::orderBy('created_at', 'DESC')->get();

        // $makros = [];
        // $selectedRecord = [];

        // $record_id = $request->query('record_id');
        // if (isset($record_id)) {
        //     $selectedRecord = Record::findOrFail($record_id);

        //     // $selected_makro = explode('|', $selectedRecord->selected_makro);

        //     // foreach ($selected_makro as $data) {
        //     //     $makro = json_decode($data, true);
        //     //     $makros[] = $makro;
        //     //     //dd($makros);
        //     // }

        //     $recordItem = RecordItems::where('record_id', $record_id)->get();
        //     //dd($recordItem);
        // }
        return view('records.index', compact('records'));
    }


    public function generatePDF()
    {
        $records = Record::orderBy('created_at', 'DESC')->get();

        $data = [
            'title' => 'Report - All Records',
            'records' => $records,
        ];

        $filename = 'my_pdf_' . time() . '.pdf';



        $pdf = Pdf::loadView('generatePDF.allrecord', $data)->setPaper('a4', 'landscape');
        return $pdf->stream($filename);
    }

    public function generateSinglePDF($id)
    {
        # code...
        //$recordItem = RecordItems::where('record_id', $id)->get();

        $records = Record::where('record_id', $id)->first();
        //dd($records->recordItems);
        // $makros = [];
        // $selectedRecord = Record::findOrFail($id);

        // $selected_makro = explode('|', $selectedRecord->selected_makro);

        // foreach ($selected_makro as $data) {
        //     $makro = json_decode($data, true);
        //     $makros[] = $makro;
        //     //dd($makros);
        // }
        $data = [
            'records' => $records,
            'makros' => $records->recordItems,
        ];
        //dd($makros);
        $filename = 'my_pdf_' . time() . '.pdf';
        $pdf = Pdf::loadView('generatePDF.singlerecord', $data)->setPaper('a4', 'potrait');
        return $pdf->stream($filename);

        //return view('generatePDF.allrecord', compact('records', 'makros', 'selectedRecord'));
    }


    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
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
        $record = Record::where('record_id', $id)->first();
        //dd($record);

        if ($record) {

            $water_status = "";

            if ($record->record_average >= 7.6 && $record->record_average <= 10) {
                $water_status = "Very Clean";
            } else if ($record->record_average >= 5.1 && $record->record_average <= 7.59) {
                $water_status = "Almost Clean";
            } else if ($record->record_average >= 2.6 && $record->record_average <= 5.09) {
                $water_status = "Almost Dirty";
            } else if ($record->record_average >= 1.0 && $record->record_average <= 2.59) {
                $water_status = "Dirty";
            } else if ($record->record_average >= 0 && $record->record_average <= 0.9) {
                $water_status = "Very Dirty";
            } else {
                $water_status = "Invalid Score";
            }

            $recordItems = RecordItems::where('record_id', $id)->get();

            // $makros = collect(); // Create an empty collection to store macros

            // dd($recordItems);
            // foreach ($recordItems as $recordItem) {
            //     $makros = $makros->merge($recordItem->makro);
            // }


            //dd($makros);
        }
        return view('records.show', compact('record', 'recordItems', 'water_status'));
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
        //delete
        $records = Record::findOrFail($id);

        $records->delete();

        return redirect()->route('records')->with('success', 'Records deleted Successfully');
    }
}
