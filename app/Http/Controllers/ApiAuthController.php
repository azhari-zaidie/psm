<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class ApiAuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->only('user_email', 'password');

        if (Auth::attempt($credentials)) {
            $user = Auth::user();


            $userData = [
                'user_id' => $user->user_id,
                'user_name' => $user->user_name,
                'user_email' => $user->user_email,
                'password' => $user->password,
                'user_role' => $user->user_role,
            ];

            return response()->json([
                'success' => true,
                'userData' => $userData,
            ], 200);
        } else {
            return response()->json([
                'success' => false,
            ], 200);
        }
    }

    public function emailValidator(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'user_email' => 'required|string|email|unique:users,user_email|max:255',
        ]);

        // Check if email already exists
        if ($validator->fails()) {
            return response()->json(['emailFound' => true, 'message' => $validator->errors()], 200);
        } else {
            return response()->json(['emailFound' => false, 'message' => $validator->errors()], 200);
        }
    }

    public function register(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'user_name' => 'required|max:255',
            'user_email' => 'required|string|email|unique:users,user_email|max:255',
            'password' => 'required|min:6',
            'user_role' => 'required',
        ]);


        $user = User::create([
            'user_name' => $request->user_name,
            'user_email' => $request->user_email,
            'password' => bcrypt($request->password),
            'user_role' => $request->user_role
        ]);

        return response()->json([
            'success' => true,
            'message' => 'User registered successfully',
        ]);
    }
}
