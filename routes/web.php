<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\MakroController;
use App\Http\Controllers\MakroFamilyController;
use App\Http\Controllers\NewsController;
use App\Http\Controllers\RecordController;
use App\Http\Controllers\UserController;

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
    return view('auth.login');
});

Route::controller(AuthController::class)->group(function () {
    Route::get('register', 'register')->name('register');
    Route::post('register', 'registerSave')->name('register.save');

    Route::get('login', 'login')->name('login');
    Route::post('login', 'loginAction')->name('login.action');

    Route::get('logout', 'logout')->middleware('auth')->name('logout');

    Route::get('profile', 'profile')->middleware('auth')->name('profile');
    Route::put('update', 'update')->middleware('auth')->name('update.profile');
});

Route::middleware('auth')->group(function () {
    Route::controller(DashboardController::class)->prefix('dashboard')->group(function () {
        Route::get('', 'index')->name('dashboard');
    });

    //makro route
    Route::controller(MakroController::class)->prefix('makros')->group(function () {
        Route::get('', 'index')->name('makros');
        Route::get('create', 'create')->name('makros.create');      //directed to the create page
        Route::post('store', 'store')->name('makros.store');        //store function
        Route::get('show/{id}', 'show')->name('makros.show');       //directed to the display page
        Route::get('edit/{id}', 'edit')->name('makros.edit');       //directed to the update page
        Route::put('edit/{id}', 'update')->name('makros.update');   //update function
        Route::delete('destroy/{id}', 'destroy')->name('makros.destroy');   //delete function
        Route::get('changeStatus/{id}', 'changeStatus')->name('makros.changeStatus');   //change status function
    });

    Route::controller(MakroFamilyController::class)->prefix('familymakros')->group(function () {
        Route::get('', 'index')->name('familymakros');
        Route::get('create', 'create')->name('familymakros.create');
        Route::post('store', 'store')->name('familymakros.store');
        Route::get('show/{id}', 'show')->name('familymakros.show');
        Route::get('edit/{id}', 'edit')->name('familymakros.edit');
        Route::put('edit/{id}', 'update')->name('familymakros.update');
        Route::delete('destroy/{id}', 'destroy')->name('familymakros.destroy');
        Route::get('changeStatus/{id}', 'changeStatus')->name('familymakros.changeStatus');   //change status function
    });

    Route::controller(NewsController::class)->prefix('news')->group(function () {
        Route::get('', 'index')->name('news');
        Route::put('edit/{id}', 'update')->name('news.update');
        Route::delete('destroy/{id}', 'destroy')->name('news.destroy');

        Route::get('create', 'create')->name('news.create');
        Route::post('store', 'store')->name('news.store');
    });

    Route::controller(UserController::class)->prefix('users')->group(function () {
        Route::get('', 'index')->name('users');
        Route::put('edit/{user_id}', 'update')->name('users.update');
        Route::delete('destroy/{id}', 'destroy')->name('users.destroy');
    });

    Route::controller(RecordController::class)->prefix('records')->group(function () {
        Route::get('', 'index')->name('records');
        Route::get('/singlereport/{id}', 'generateSinglePDF')->name('pdf.single');
        Route::get('/fullreport', 'generatePDF')->name('pdf.full');
        Route::delete('destroy/{id}', 'destroy')->name('records.destroy');

        Route::get('show/{id}', 'show')->name('records.show');


        Route::get('edit/{id}', 'edit')->name('records.edit');
        Route::put('edit/{id}', 'update')->name('records.update');
    });

    //Route::get('/fullreport', [RecordController::class, 'generatePDF'])->name('generatepdf');
    //Route::get('singlereport/{id}', [RecordController::class, 'generateSinglePDF'])->name('pdf.single');

    Route::get('/profile', [AuthController::class, 'profile'])->name('profile');
});
