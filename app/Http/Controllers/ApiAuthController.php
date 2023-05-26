<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
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

    public function update(Request $request)
    {
        $user = User::where('user_email', $request->only('user_email'))->first();

        if (!$user) {
            return response()->json([
                'success' => false,
            ], 200);
        } else {
            //Auth::attempt($user);
            //$users = Auth::user();


            $user->user_name = $request->input('user_name');
            $user->save();

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
        }
    }

    public function changePassword(Request $request)
    {
        $user = User::where('user_email', $request->only('user_email'))->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User not Found',
            ], 200);
        } else {
            //Auth::attempt($user);
            //$users = Auth::user();
            $request->validate([
                'current_password' => 'required',
                'new_password' => 'required|min:6',
            ]);

            // Verify the current password
            if (!Hash::check($request->input('current_password'), $user->password)) {
                return response()->json(
                    [
                        'success' => false,
                        'message' => 'Current password is incorrect',
                    ],
                    200
                );
            } else {
                // Update the user's password
                $user->password = Hash::make($request->input('new_password'));
                $user->save();

                // $userData = [
                //     'user_id' => $user->user_id,
                //     'user_name' => $user->user_name,
                //     'user_email' => $user->user_email,
                //     'password' => $user->password,
                //     'user_role' => $user->user_role,
                // ];
                return response()->json([
                    'success' => true,
                    'message' => 'Success change password',
                ], 200);
            }
        }
    }
}
