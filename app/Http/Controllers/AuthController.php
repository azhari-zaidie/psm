<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    //
    public function register()
    {
        return view('auth/register');
    }

    public function registerSave(Request $request)
    {
        Validator::make($request->all(), [
            'user_name' => 'required',
            'user_email' => 'required|email',
            'password' => 'required|confirmed',
            'user_role' => 'required',
        ])->validate();

        User::create([
            'user_name' => $request->user_name,
            'user_email' => $request->user_email,
            'password' => Hash::make($request->password),
            'user_role' => $request->user_role,
        ]);

        return redirect()->route('login');
    }

    public function login()
    {
        return view('auth/login');
    }

    public function loginAction(Request $request)
    {
        Validator::make($request->all(), [
            'user_email' => 'required|email',
            'password' => 'required',
        ])->validate();

        if (!Auth::attempt($request->only('user_email', 'password'), $request->boolean('remember'))) {
            throw ValidationException::withMessages([
                'user_email' => trans('auth.failed')
            ]);
        } else {
            $user = Auth::user();
            if ($user->user_role !== 'admin') {
                Auth::logout();
                throw ValidationException::withMessages([
                    'user_email' => trans('auth.failed')
                ]);
            }

            $request->session()->regenerate();
            return redirect()->route('dashboard');
        }

        // // Check if the authenticated user has the "admin" role
        // if (!Auth::user()->user_role !== 'admin') {
        //     // Redirect or return an error response indicating unauthorized access
        //     // For example:
        //     throw ValidationException::withMessages([
        //         'user_email' => trans('auth.unauthorized')
        //     ]);
        // }
        // $request->session()->regenerate();
    }

    public function logout(Request $request)
    {
        Auth::guard('web')->logout();

        $request->session()->invalidate();
        return redirect('/');
    }

    public function profile()
    {
        return view('profile');
    }

    public function update(Request $request)
    {
        $user = User::findOrFail($request->user_id);
        $user_id = $request->query('user_id');
        $validator = Validator::make($request->all(), [
            'user_name' => 'required',
            'user_email' => [
                'required',
                'email',
                Rule::unique('users')->ignore($user_id, 'user_id')->where(function ($query) use ($user) {
                    return $query->whereRaw('user_email != ? AND user_email != ?', [$user->user_email, $user->user_email]);
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
        return redirect()->back()->with('success', 'Profile updated successfully.');
    }
}
