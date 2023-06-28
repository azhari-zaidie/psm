<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        //

        //
        $user = User::where('user_role', '!=', 'admin')->orderBy('created_at', 'DESC')->get();


        $user_id = $request->query('user_id');
        $selectedUser = [];
        $makros = [];
        if (isset($user_id)) {
            $selectedUser = User::findOrFail($user_id);
            //dd($selectedNews);
        }


        return view('user.index', compact('user', 'selectedUser'));
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
        $user = User::findOrFail($id);
        $user_id = $request->query('user_id');
        $validator = Validator::make($request->all(), [
            'user_name' => 'required',
            'user_email' => [
                'required',
                'email',
                Rule::unique('users')->ignore($user_id)->where(function ($query) use ($user) {
                    return $query->where('user_email', '!=', $user->user_email);
                })
            ],
            'password' => 'nullable|confirmed|min:8',
        ]);

        if ($request->filled('password')) {
            $user->password = bcrypt($request->password);
        }

        // If validation fails, redirect back with the error messages
        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        $user->user_name = $request->user_name;
        $user->user_email = $request->user_email;

        $user->save();
        return redirect()->route('users')->with('success', 'User Updated Successfully');
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

        $user = User::findOrFail($id);

        $user->delete();

        return redirect()->route('users')->with('success', 'User deleted Successfully');
    }
}
