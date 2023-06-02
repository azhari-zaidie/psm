<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
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
        }
        $request->session()->regenerate();

        return redirect()->route('dashboard');
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
}
