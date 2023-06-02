<?php

namespace App\Http\Controllers;

use App\Models\Makro;
use Illuminate\Http\Request;

class MakroController extends Controller
{
    //

    public function index()
    {
        $makros = Makro::orderBy('created_at', 'DESC')->get();
        return view('makros.index', compact('makros'));
    }

    public function create()
    {
        return view('makros.create');
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'makro_name' => 'required',
            'family_id' => 'required',
            'makro_mark' => 'required',
            'makro.*.test_name' => 'required',
            'makro.*.test_desc' => 'required',
        ]);

        $productDetails = [];
        $productDetailsString = "";

        foreach ($validatedData['makro'] as $makro) {
            $test_name = $makro['test_name'];
            $test_desc = $makro['test_desc'];

            $productDetailsString .= json_encode(
                [
                    'test_name' => $test_name,
                    'test_desc' => $test_desc,
                ]
            ) . ' | ';
        };

        $validator = Makro::create([
            'makro_name' => $request->makro_name,
            'makro_desc' => $request->makro_desc,
            'family_id' => $request->family_id,
            'makro_mark' => $request->makro_mark,
            'makro_features' =>   rtrim($productDetailsString, ' | '),
        ]);

        //$makro = new Makro();
        //Makro::create($request->all());

        return redirect()->route('makros')->with('success', 'Macros added successfully');
    }

    public function show(string $id)
    {
        $makro = Makro::findOrFail($id);

        return view('makros.show', compact('makro'));
    }

    public function edit(string $id)
    {
        $makro = Makro::findOrFail($id);

        return view('makros.edit', compact('makro'));
    }

    public function update(Request $request, string $id)
    {
        $makro = Makro::findOrFail($id);

        $makro->update($request->all());

        return redirect()->route('makros')->with('success', 'Macros updated Successfully');
    }

    public function destroy(string $id)
    {
        $makro = Makro::findOrFail($id);

        $makro->delete();

        return redirect()->route('makros')->with('success', 'Macros deleted Successfully');
    }
}
