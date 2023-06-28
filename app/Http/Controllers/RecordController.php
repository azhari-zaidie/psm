<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Record;
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

        $record_id = $request->query('record_id');
        $selectedRecord = [];
        $makros = [];
        if (isset($record_id)) {
            $selectedRecord = Record::findOrFail($record_id);

            $selected_makro = explode('|', $selectedRecord->selected_makro);

            foreach ($selected_makro as $data) {
                $makro = json_decode($data, true);
                $makros[] = $makro;
                //dd($makros);
            }
        }
        return view('records.index', compact('records', 'makros', 'selectedRecord'));
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
        $makros = [];
        $selectedRecord = Record::findOrFail($id);

        $selected_makro = explode('|', $selectedRecord->selected_makro);

        foreach ($selected_makro as $data) {
            $makro = json_decode($data, true);
            $makros[] = $makro;
            //dd($makros);
        }
        $data = [
            'records' => $selectedRecord,
            'makros' => $makros,
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
