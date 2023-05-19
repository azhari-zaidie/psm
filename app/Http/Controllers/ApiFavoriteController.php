<?php

namespace App\Http\Controllers;

use App\Models\Favorite;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ApiFavoriteController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
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

        $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'makro_id' => 'required|exists:makros,makro_id',
        ]);

        $favorite = Favorite::create([
            'user_id' => $request->user_id,
            'makro_id' => $request->makro_id,
        ]);

        return response()->json([
            'success' => true,
            'data' => $favorite,
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
        //

        //$favorite = Favorite::where('user_id', $id)->get();
        //$favorite = Favorite::with('makros')->where('user_id', $id)->get();
        $favorite = DB::table('favorites')
            ->crossJoin('makros')
            ->whereRaw("favorites.user_id = '$id' AND favorites.makro_id=makros.makro_id")
            ->get();


        if (!$favorite) {
            return response()->json([
                'success' => false,
                'message' => 'Record not found',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'currentUserFavoriteData' => $favorite,
        ]);
    }

    public function validateFavorite(Request $request)
    {
        # code...
        $favorite = DB::table('favorites')
            ->whereRaw("user_id = '$request->user_id' AND makro_id='$request->makro_id'")
            ->first();


        if (!$favorite) {
            return response()->json([
                'favoriteFound' => false,
                'message' => 'Favorite not found',
            ]);
        } else {
            return response()->json([
                'favoriteFound' => true,
                'favoritedata' => $favorite,
            ]);
        }
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
    public function delete(Request $request)
    {
        //
        $favorite = DB::table('favorites')
            ->whereRaw("user_id = '$request->user_id' AND makro_id='$request->makro_id'")
            ->delete();

        //$favorite->delete();

        return response()->json([
            'success' => true,
            'message' => 'Favorite deleted successfully',
        ]);
    }
}
