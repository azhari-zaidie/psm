<?php

namespace App\Http\Controllers;

use App\Models\Makro;
use App\Models\FamilyMakro;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;

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
        $familyMakro = FamilyMakro::all();

        return view('makros.create', compact('familyMakro'));
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'makro_name' => 'required',
            'family_id' => 'required',
            'makro_mark' => 'required',
            'makro_image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'makro.*.feature_name' => 'required',
            'makro.*.feature_desc' => 'required',
            'makro.*.feature_image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        $imageName = time() . '.' . $request->makro_image->extension();
        $request->file('makro_image')->move(public_path('assets/images/makro'), $imageName);

        $productDetailsString = "";

        foreach ($validatedData['makro'] as $makro) {
            $imageFeatureName = time() . $makro['feature_name'] . '.' . $makro['feature_image']->extension();
            $makro['feature_image']->move(public_path('assets/images/makro'), $imageFeatureName);

            //$feature_image = $makro['feature_image'];
            $feature_name = $makro['feature_name'];
            $feature_desc = $makro['feature_desc'];

            $productDetailsString .= json_encode(
                [
                    'feature_name' => $feature_name,
                    'feature_desc' => $feature_desc,
                    'feature_image' => $imageFeatureName,
                ]
            ) . ' | ';
        };

        $validator = Makro::create([
            'makro_name' => $request->makro_name,
            'makro_desc' => $request->makro_desc,
            'family_id' => $request->family_id,
            'status' => "Pending",
            'makro_mark' => $request->makro_mark,
            'makro_image' => $imageName,
            'makro_features' =>   rtrim($productDetailsString, ' | '),
        ]);

        return redirect()->route('makros')->with('success', 'Macros added successfully');
    }

    public function show(string $id)
    {
        $makro = Makro::findOrFail($id);

        $familyMakro = FamilyMakro::findOrFail($makro->family_id);

        $featureData = explode('|', $makro->makro_features);
        $features = [];

        foreach ($featureData as $data) {
            $feature = json_decode($data, true);
            $features[] = $feature;
        }

        return view('makros.show', compact('makro', 'features', 'familyMakro'));
    }

    public function edit(string $id)
    {
        $makro = Makro::findOrFail($id);
        $familyMakro = FamilyMakro::all();

        $featureData = explode('|', $makro->makro_features);
        $features = [];

        foreach ($featureData as $data) {
            $feature = json_decode($data, true);
            $features[] = $feature;
        }

        $statusOptions = ['Pending' => 'Pending', 'Verified' => 'Verified'];

        return view('makros.edit', compact('makro', 'familyMakro', 'features', 'statusOptions'));
    }

    public function update(Request $request, string $id)
    {
        $makro = Makro::findOrFail($id);

        $makro->makro_name = $request->makro_name;
        $makro->family_id = $request->family_id;
        $makro->makro_mark = $request->makro_mark;
        $makro->makro_name = $request->makro_name;
        $makro->status = $request->status;
        $makro->makro_desc = $request->makro_desc;

        if ($request->hasFile('makro_image')) {
            $makro_image = time() . '.' . $request->makro_image->extension();
            $request->file('makro_image')->move(public_path('assets/images/makro'), $makro_image);

            $makro->makro_image = $makro_image;
        }

        $currentFeature = $request->validate([
            'makro.*.current_feature_name' => 'required',
            'makro.*.current_feature_desc' => 'required',
            'makro.*.current_feature_image' => 'sometimes|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'makro.*.current_feature_delete' => 'sometimes'
        ]);


        $currentFeatureString = "";
        //$currentFeature = $request->input('makro', []);
        $featureData = explode('|', $makro->makro_features);

        foreach ($currentFeature['makro'] as $index => $makros) {
            $feature_name = $makros['current_feature_name'];
            $feature_desc = $makros['current_feature_desc'];

            if (isset($makros['current_feature_delete'])) {
                $existingFeature = json_decode($featureData[$index], true);
                $imageFeatureName = $existingFeature['feature_image'];

                if ($imageFeatureName) {
                    $imagePath = public_path('assets/images/makro/' . $imageFeatureName);
                    if (File::exists($imagePath)) {
                        File::delete($imagePath);
                    }
                }
                continue;
            } elseif ($request->hasFile('makro.' . $index . '.current_feature_image')) {
                $imageFeatureName = time() . $makros['current_feature_name'] . '.' . $makros['current_feature_image']->extension();
                $makros['current_feature_image']->move(public_path('assets/images/makro'), $imageFeatureName);
            } else {
                $feature = json_decode($featureData[$index], true);
                $imageFeatureName = $feature['feature_image'];
            }

            $currentFeatureString .= json_encode(
                [
                    'feature_name' => $feature_name,
                    'feature_desc' => $feature_desc,
                    'feature_image' => $imageFeatureName,
                ]
            ) . ' | ';
        };

        $newFeatureData = $request->validate([
            'newMakro.*.new_feature_name' => 'required',
            'newMakro.*.new_feature_desc' => 'required',
            'newMakro.*.new_feature_image' => 'sometimes|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        if (isset($newFeatureData['newMakro'])) {
            foreach ($newFeatureData['newMakro'] as $newFeature) {
                $newImageFeatureName = time() . $newFeature['new_feature_name'] . '.' . $newFeature['new_feature_image']->extension();
                $newFeature['new_feature_image']->move(public_path('assets/images/makro'), $newImageFeatureName);

                //$feature_image = $makro['feature_image'];
                $new_feature_name = $newFeature['new_feature_name'];
                $new_feature_desc = $newFeature['new_feature_desc'];

                $currentFeatureString .= json_encode(
                    [
                        'feature_name' => $new_feature_name,
                        'feature_desc' => $new_feature_desc,
                        'feature_image' => $newImageFeatureName,
                    ]
                ) . ' | ';
            };
        }


        $makro->makro_features = rtrim($currentFeatureString, ' | ');
        $makro->save();
        return redirect()->route('makros')->with('success', 'Macros updated Successfully');
    }

    public function destroy(string $id)
    {
        $makro = Makro::findOrFail($id);

        $makro->delete();

        return redirect()->route('makros')->with('success', 'Macros deleted Successfully');
    }
}
