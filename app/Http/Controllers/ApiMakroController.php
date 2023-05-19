<?php

namespace App\Http\Controllers;

use App\Models\Makro;
use Illuminate\Http\Request;

class ApiMakroController extends Controller
{
    //

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $makro = Makro::all();

        return response()->json([
            'success' => true,
            'makroData' => $makro,
        ]);
    }

    public function sendImage($imagePath)
    {
        //
        return response()->file(public_path("/assets/images/makro/{$imagePath}"));
    }

    public function showDetails($makro_id)
    {
        // Retrieve the food record with the given food_id
        $makro = Makro::find($makro_id);

        // Return a response with the retrieved record
        return response()->json([
            'success' => true,
            'makroDetailsData' => $makro,
        ]);
    }


    /**
     * Display the specified resource.
     *
     * @param  int  $family_id
     * @return \Illuminate\Http\Response
     */
    public function show($family_id)
    {
        //

        // Retrieve all the Makro records with the given family_id
        $makros = Makro::where('family_id', $family_id)->get();

        // Return a response with the retrieved records
        return response()->json([
            'success' => true,
            'makroListData' => $makros,
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
        //
        $data = $request->validate([
            'makro_name' => 'required|string|max:255',
            'makro_desc' => 'required|string',
            'makro_image' => 'required|string',
            'family_id' => 'required|integer',
            'makro_mark' => 'required|numeric',
        ]);

        //$news = ;

        if (Makro::create($data)) {
            return response()->json([
                'success' => true
            ]);
        } else {
            return response()->json([
                'success' => false
            ]);
        }
    }
}
