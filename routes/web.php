<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MakroController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::controller(AuthController::class)->group(function () {
    Route::get('register', 'register')->name('register');
    Route::post('register', 'registerSave')->name('register.save');

    Route::get('login', 'login')->name('login');
    Route::post('login', 'loginAction')->name('login.action');

    Route::get('logout', 'logout')->middleware('auth')->name('logout');
});

Route::middleware('auth')->group(function () {
    Route::get('dashboard', function () {
        return view('dashboard');
    })->name('dashboard');

    Route::controller(MakroController::class)->prefix('makros')->group(function () {
        Route::get('', 'index')->name('makros');
        Route::get('create', 'create')->name('makros.create');
        Route::post('store', 'store')->name('makros.store');
        Route::get('show/{id}', 'show')->name('makros.show');
        Route::get('edit/{id}', 'edit')->name('makros.edit');
        Route::put('edit/{id}', 'update')->name('makros.update');
        Route::delete('destroy/{id}', 'destroy')->name('makros.destroy');
    });

    Route::get('/profile', [AuthController::class, 'profile'])->name('profile');
});
