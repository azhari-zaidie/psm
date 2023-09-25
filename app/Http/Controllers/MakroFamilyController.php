<?php

namespace App\Http\Controllers;

use App\Models\FamilyMakro;
use Illuminate\Http\Request;

use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;

class MakroFamilyController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $familymakros = FamilyMakro::orderBy('created_at', 'DESC')->get();
        //display family makro from database to index pages
        return view('familymakros.index', compact('familymakros'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //redirected to create form page
        return view('familymakros.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //store to database
        $validatedData = $request->validate([
            'family_scientific_name' => 'required',
            'family_name' => 'required',
            'family_desc' => 'required',
            'family_image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:10000',
        ]);

        $imageName = time() . '.' . $request->family_image->extension();
        //$request->file('family_image')->move(public_path('assets/images/familymakro'), $imageName);


        $FamilyMakro = FamilyMakro::create([
            'family_scientific_name' => $request->family_scientific_name,
            'family_name' => $request->family_name,
            'family_desc' => $request->family_desc,
            'family_image' => $imageName,
            'status' => "Pending",
        ]);

        $folderName = $FamilyMakro->family_id;
        $folderPath = 'assets/images/familymakro/' . $folderName;

        //dd(Storage::exists($folderPath));

        if (!Storage::disk('public')->exists($folderPath)) {
            Storage::disk('public')->makeDirectory($folderPath);
        }

        $familyMakroImage = $request->file('family_image');

        if ($familyMakroImage) {
            // Store the image in the folder
            $imagePath = $familyMakroImage->storeAs($folderPath, $imageName, 'public');

            $FamilyMakro->update([
                'url' => $imagePath,
            ]);
        }


        return redirect()->route('familymakros')->with('success', 'Family Macros added successfully');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //family makro display
        $familymakros = FamilyMakro::findOrFail($id);

        return view('familymakros.show', compact('familymakros'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //go to update page
        $familymakros = FamilyMakro::findOrFail($id);

        $statusOptions = ['Pending' => 'Pending', 'Verified' => 'Verified'];

        return view('familymakros.edit', compact('familymakros', 'statusOptions'));
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
        //update family macros

        $familymakros = FamilyMakro::findOrFail($id);

        $oldImageName = $familymakros->family_image;

        $folderName = $familymakros->family_id;

        $folderPathMakro = 'assets/images/familymakro/' . $folderName;

        if ($request->hasFile('family_image')) {
            //$currImage = $request->hasFile('family_image');

            $family_image = time() . '_' . $folderName . '.' . $request->family_image->extension();
            //$request->file('family_image')->move(public_path('assets/images/familymakro'), $family_image);

            $oldImageExtension = pathinfo($oldImageName, PATHINFO_EXTENSION);

            $oldImageNameWithOld = pathinfo($oldImageName, PATHINFO_FILENAME) . '_old.' . $oldImageExtension;

            $oldImagePath = $folderPathMakro . '/' . $oldImageName;
            $newImagePath = $folderPathMakro . '/' . $oldImageNameWithOld;

            //dd($oldImagePath);

            // Rename the old image file
            if (Storage::disk('public')->exists($oldImagePath)) {
                Storage::disk('public')->move($oldImagePath, $newImagePath);
                // /dd("test");
            }

            $imagePath = $request->family_image->storeAs($folderPathMakro, $family_image, 'public');


            $familymakros->family_image = $family_image;
            $familymakros->url = $imagePath;
        }
        $familymakros->family_scientific_name = $request->family_scientific_name;
        $familymakros->family_name = $request->family_name;
        $familymakros->status = $request->status;
        $familymakros->family_desc = $request->family_desc;


        $familymakros->save();

        return redirect()->route('familymakros')->with('success', 'Family Macros Updated Successfully');
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
        $familymakros = FamilyMakro::findOrFail($id);

        // $imageFeatureName = $familymakros->family_image;

        // if ($imageFeatureName) {
        //     $imagePath = public_path('assets/images/familymakro/' . $imageFeatureName);
        //     if (File::exists($imagePath)) {
        //         File::delete($imagePath);
        //     }
        // }

        $familymakros->delete();

        return redirect()->route('familymakros')->with('success', 'Family Macros deleted Successfully');
    }

    function changeStatus(string $id)
    {
        $familymakros = FamilyMakro::find($id);

        $familymakros->status = "Verified";
        $familymakros->save();

        return redirect()->route('familymakros')->with('success', 'Family Macros Status Updated Successfully');
    }
}
