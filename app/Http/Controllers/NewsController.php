<?php

namespace App\Http\Controllers;

use App\Models\News;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;

class NewsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        //
        $news = News::orderBy('created_at', 'DESC')->get();

        $news_id = $request->query('news_id');
        $selectedNews = [];
        $makros = [];
        if (isset($news_id)) {
            $selectedNews = News::findOrFail($news_id);
            //dd($selectedNews);
        }

        $statusOptions = ['News' => 'News', 'Learning' => 'Learning'];

        return view('news.index', compact('news', 'selectedNews', 'statusOptions'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
        $statusOptions = ['News' => 'News', 'Learning' => 'Learning'];
        return view('news.create', compact('statusOptions'));
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
            'news_title' => 'required',
            'category' => 'required',
            'news_desc' => 'required',
            'news_image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:10000',
        ]);

        $imageName = time() . '.' . $request->news_image->extension();
        $request->file('news_image')->move(public_path('assets/images/news'), $imageName);

        News::create([
            'news_title' => $request->news_title,
            'category' => $request->category,
            'news_desc' => $request->news_desc,
            'news_image' => $imageName,
        ]);

        return redirect()->route('news')->with('success', 'News added successfully');
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
        $news = News::findOrFail($id);

        if ($request->hasFile('news_image')) {
            $news_image = time() . '.' . $request->news_image->extension();
            $request->file('news_image')->move(public_path('assets/images/news'), $news_image);

            $news->news_image = $news_image;
        }
        $news->news_title = $request->news_title;
        $news->news_desc = $request->news_desc;
        $news->category = $request->category;

        $news->save();
        return redirect()->route('news')->with('success', 'News Updated Successfully');
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

        $news = News::findOrFail($id);
        $imageFeatureName = $news->news_image;
        if ($imageFeatureName) {
            $imagePath = public_path('assets/images/news/' . $imageFeatureName);
            if (File::exists($imagePath)) {
                File::delete($imagePath);
            }
        }


        $news->delete();

        return redirect()->route('news')->with('success', 'News deleted Successfully');
    }
}
