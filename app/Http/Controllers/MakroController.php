<?php

namespace App\Http\Controllers;

use App\Models\Makro;
use App\Models\FamilyMakro;
use App\Models\MakroFeature;
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
        //dd($request->all());
        $validatedData = $request->validate([
            'makro_name' => 'required',
            'family_id' => 'required',
            'makro_mark' => 'required',
            'makro_image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:10000',
            'makro.*.feature_name' => 'required',
            'makro.*.feature_desc' => 'required',
            'makro.*.feature_image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:10000',
        ]);

        $res = str_replace(array(
            '\'', '"', '/',
            ',', ';', '<', '>', ':', '(', ')', '[', ']', '{', '}', '*', '!', '@', '#', '$', '%', '^', '&',
        ), '', $request->makro_name);

        //dd($res);

        $imageName = $res . '.' . $request->makro_image->extension();
        //$request->file('makro_image')->move(public_path('assets/images/makro'), $imageName);

        $makro = Makro::create([
            'makro_name' => $request->makro_name,
            'makro_desc' => $request->makro_desc,
            'family_id' => $request->family_id,
            'status' => "Pending",
            'makro_mark' => $request->makro_mark,
            'makro_image' => $imageName,
        ]);



        $folderName = $makro->makro_id;
        $folderPath = 'assets/images/makro/' . $folderName;

        //dd(Storage::exists($folderPath));

        if (!Storage::disk('public')->exists($folderPath)) {
            Storage::disk('public')->makeDirectory($folderPath);
        }

        $macroImage = $request->file('makro_image');

        if ($macroImage) {
            // Store the image in the folder
            $imagePath = $macroImage->storeAs($folderPath, $imageName, 'public');

            $makro->update([
                'url' => $imagePath,
            ]);
        }

        $makro_id = $makro->makro_id;


        //$productDetailsString = "";

        $folderPathFeature = $folderPath . '/features';

        if (!Storage::disk('public')->exists($folderPathFeature)) {
            Storage::disk('public')->makeDirectory($folderPathFeature);
        }

        foreach ($validatedData['makro'] as $makro) {
            $resfeature = str_replace(array(
                '\'', '"', '/',
                ',', ';', '<', '>', ':', '(', ')', '[', ']', '{', '}', '*', '!', '@', '#', '$', '%', '^', '&',
            ), '', $makro['feature_name']);
            $imageFeatureName = time() . '_' . $resfeature . '.' . $makro['feature_image']->extension();
            //$makro['feature_image']->move(public_path('assets/images/makro'), $imageFeatureName);

            $macroFeatureImage = $makro['feature_image'];

            $macroFeaturePath = $macroFeatureImage->storeAs($folderPathFeature, $imageFeatureName, 'public');


            //$feature_image = $makro['feature_image'];
            $feature_name = $makro['feature_name'];
            $feature_desc = $makro['feature_desc'];

            $feature_makro = MakroFeature::create([
                'makro_id' => $makro_id,
                'feature_name' => $feature_name,
                'feature_desc' => $feature_desc,
                'feature_image' => $imageFeatureName,
                'url' => $macroFeaturePath,
            ]);

            // $productDetailsString .= json_encode(
            //     [
            //         'feature_name' => $feature_name,
            //         'feature_desc' => $feature_desc,
            //         'feature_image' => $imageFeatureName,
            //     ]
            // ) . ' | ';
        };

        // $validator = Makro::create([
        //     'makro_name' => $request->makro_name,
        //     'makro_desc' => $request->makro_desc,
        //     'family_id' => $request->family_id,
        //     'status' => "Pending",
        //     'makro_mark' => $request->makro_mark,
        //     'makro_image' => $imageName,
        //     'makro_features' =>   rtrim($productDetailsString, ' | '),
        // ]);

        return redirect()->route('makros')->with('success', 'Macros added successfully');
    }

    public function show(string $id)
    {
        $makro = Makro::findOrFail($id);

        $familyMakro = FamilyMakro::findOrFail($makro->family_id);

        $features = MakroFeature::where('makro_id', $makro->makro_id)->get();

        // $featureData = explode('|', $makro->makro_features);
        // $features = [];

        // foreach ($featureData as $data) {
        //     $feature = json_decode($data, true);
        //     $features[] = $feature;
        // }

        return view('makros.show', compact('makro', 'features', 'familyMakro', 'features'));
    }

    public function edit(string $id)
    {
        $makro = Makro::findOrFail($id);
        $familyMakro = FamilyMakro::all();

        $features = MakroFeature::where('makro_id', $makro->makro_id)->get();

        // $featureData = explode('|', $makro->makro_features);
        // $features = [];

        // foreach ($featureData as $data) {
        //     $feature = json_decode($data, true);
        //     $features[] = $feature;
        // }

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

        $folderName = $makro->makro_id;

        $folderPathMakro = 'assets/images/makro/' . $folderName;

        if (!Storage::disk('public')->exists($folderPathMakro)) {
            Storage::disk('public')->makeDirectory($folderPathMakro);
        }

        $oldImageName = $makro->makro_image;

        if ($request->hasFile('makro_image')) {
            // If a new image is uploaded, rename the old image by adding "_old" to the name
            // $oldImageName = pathinfo($oldImageMakro, PATHINFO_FILENAME);
            $oldImageExtension = pathinfo($oldImageName, PATHINFO_EXTENSION);

            $oldImageNameWithOld = pathinfo($oldImageName, PATHINFO_FILENAME) . '_old.' . $oldImageExtension;

            $oldImagePath = $folderPathMakro . '/' . $oldImageName;
            $newImagePath = $folderPathMakro . '/' . $oldImageNameWithOld;

            //dd($newImagePath);

            // Rename the old image file
            if (Storage::disk('public')->exists($oldImagePath)) {
                Storage::disk('public')->move($oldImagePath, $newImagePath);
                //dd("test");
            }

            //dd("stuck");

            $makro_image = $makro->makro_name . '.' . $request->makro_image->extension();

            $macroImage = $request->file('makro_image');

            //$request->file('makro_image')->move(public_path('assets/images/makro'), $makro_image);
            $macroPath = $macroImage->storeAs($folderPathMakro, $makro_image, 'public');

            $makro->makro_image = $makro_image;
            $makro->url = $macroPath;
        }

        $currentFeature = $request->validate([
            'makro.*.current_feature_name' => 'required',
            'makro.*.current_feature_desc' => 'required',
            'makro.*.feature_id' => 'required',
            'makro.*.current_feature_image' => 'sometimes|image|mimes:jpeg,png,jpg,gif,svg|max:10000',
            'makro.*.current_feature_delete' => 'sometimes'
        ]);

        //dd($currentFeature);

        //$currentFeature = $request->input('makro', []);
        //$featureData = explode('|', $makro->makro_features);

        $makroFeature = MakroFeature::where('makro_id', $makro->makro_id)->get();

        $folderPathFeature = $folderPathMakro . '/features';

        if (!Storage::disk('public')->exists($folderPathFeature)) {
            Storage::disk('public')->makeDirectory($folderPathFeature);
        }

        foreach ($currentFeature['makro'] as $index => $makros) {
            $feature = MakroFeature::where('id', $makros['feature_id'])->first();
            $feature_name = $makros['current_feature_name'];
            $feature_desc = $makros['current_feature_desc'];
            $oldImageFeatureName = $feature->feature_image;

            if (isset($makros['current_feature_delete'])) {
                //$existingFeature = json_decode($featureData[$index], true);
                // $existingFeature = $feature->feature_image;
                // $imageFeatureName = $existingFeature;

                // if ($imageFeatureName) {
                //     $imagePath = public_path('assets/images/makro/' . $imageFeatureName);
                //     if (File::exists($imagePath)) {
                //         File::delete($imagePath);
                //     }
                // }

                $feature->delete();
                continue;
            } elseif ($request->hasFile('makro.' . $index . '.current_feature_image')) {
                $imageFeatureName = time() . "_" . $makros['current_feature_name'] . '.' . $makros['current_feature_image']->extension();
                //$makros['current_feature_image']->move(public_path('assets/images/makro'), $imageFeatureName);

                $featureUrl = $makros['current_feature_image']->storeAs($folderPathFeature, $imageFeatureName, 'public');

                $oldImageExtensionFeature = pathinfo($oldImageFeatureName, PATHINFO_EXTENSION);

                $oldImageNameWithOldFeature = pathinfo($oldImageFeatureName, PATHINFO_FILENAME) . '_old.' . $oldImageExtensionFeature;

                $oldImageFeaturePath = $folderPathFeature . '/' . $oldImageFeatureName;
                $newImageFeaturePath = $folderPathFeature . '/' . $oldImageNameWithOldFeature;

                //dd($newImagePath);

                // Rename the old image file
                if (Storage::disk('public')->exists($oldImageFeaturePath)) {
                    Storage::disk('public')->move($oldImageFeaturePath, $newImageFeaturePath);
                    //dd("test");
                }

                //dd("sini");
            } else {
                $existingFeature = $feature->feature_image;
                $existingUrl = $feature->url;
                $imageFeatureName = $existingFeature;
                $featureUrl = $existingUrl;
            }

            // $currentFeatureString .= json_encode(
            //     [
            //         'feature_name' => $feature_name,
            //         'feature_desc' => $feature_desc,
            //         'feature_image' => $imageFeatureName,
            //     ]
            // ) . ' | ';

            //dd($feature);

            $feature->feature_name = $feature_name;
            $feature->feature_desc = $feature_desc;
            $feature->feature_image = $imageFeatureName;
            $feature->url = $featureUrl;

            $feature->save();
        };

        $newFeatureData = $request->validate([
            'newMakro.*.new_feature_name' => 'required',
            'newMakro.*.new_feature_desc' => 'required',
            'newMakro.*.new_feature_image' => 'sometimes|image|mimes:jpeg,png,jpg,gif,svg|max:10000',
        ]);


        if (isset($newFeatureData['newMakro'])) {
            foreach ($newFeatureData['newMakro'] as $newFeature) {
                $newImageFeatureName = time() . "_" . $newFeature['new_feature_name'] . '.' . $newFeature['new_feature_image']->extension();
                //$newFeature['new_feature_image']->move(public_path('assets/images/makro'), $newImageFeatureName);


                $newFeatureUrl = $newFeature['new_feature_image']->storeAs($folderPathFeature, $newImageFeatureName, 'public');

                //$feature_image = $makro['feature_image'];
                $new_feature_name = $newFeature['new_feature_name'];
                $new_feature_desc = $newFeature['new_feature_desc'];

                // $currentFeatureString .= json_encode(
                //     [
                //         'feature_name' => $new_feature_name,
                //         'feature_desc' => $new_feature_desc,
                //         'feature_image' => $newImageFeatureName,
                //     ]
                // ) . ' | ';

                MakroFeature::create([
                    'makro_id' => $makro->makro_id,
                    'feature_name' => $new_feature_name,
                    'feature_desc' => $new_feature_desc,
                    'feature_image' => $newImageFeatureName,
                    'url' => $newFeatureUrl
                ]);
            };
        }


        //$makro->makro_features = rtrim($currentFeatureString, ' | ');
        $makro->save();
        return redirect()->route('makros')->with('success', 'Macros updated Successfully');
    }

    public function destroy(string $id)
    {
        $makro = Makro::findOrFail($id);

        // $imageFeatureName = $makro->makro_image;
        // $featureData = explode('|', $makro->makro_features);

        // foreach ($featureData as $data) {
        //     $feature = json_decode($data, true);
        //     $imagePath = public_path('assets/images/makro/' . $feature['feature_image']);
        //     if (File::exists($imagePath)) {
        //         File::delete($imagePath);
        //     }
        // }

        // if ($imageFeatureName) {
        //     $imagePath = public_path('assets/images/makro/' . $imageFeatureName);
        //     if (File::exists($imagePath)) {
        //         File::delete($imagePath);
        //     }
        // }

        $makro->delete();

        return redirect()->route('makros')->with('success', 'Macros deleted Successfully');
    }

    function changeStatus(string $id)
    {
        $makro = Makro::find($id);

        $makro->status = "Verified";
        $makro->save();

        return redirect()->route('makros')->with('success', 'Macros Status Updated Successfully');
    }
}
