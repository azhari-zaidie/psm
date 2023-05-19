<?php

namespace App\Http\Controllers;

use App\Models\FamilyMakro;
use Illuminate\Http\Request;

class ApiMakroFamilyController extends Controller
{
    //
    //

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $familyMakro = FamilyMakro::all();

        return response()->json([
            'success' => true,
            'familyMakroData' => $familyMakro,
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
            'family_name' => 'required|string|max:255',
            'family_desc' => 'required|string',
            'family_image' => 'required|string',
        ]);

        //$news = ;

        if (FamilyMakro::create($data)) {
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
