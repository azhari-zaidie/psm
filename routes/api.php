<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ApiAuthController;
use App\Http\Controllers\ApiFavoriteController;
use App\Http\Controllers\ApiNewsController;
use App\Http\Controllers\ApiMakroController;
use App\Http\Controllers\ApiRecordController;
use App\Http\Controllers\ApiMakroFamilyController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


Route::post('/login', [ApiAuthController::class, 'login']);
Route::post('/register', [ApiAuthController::class, 'register']);
Route::post('/emailvalidator', [ApiAuthController::class, 'emailValidator']);
Route::post('/update', [ApiAuthController::class, 'update']);
Route::post('/changepassword', [ApiAuthController::class, 'changePassword']);

Route::get('/news', [ApiNewsController::class, 'index']);
Route::post('/news', [ApiNewsController::class, 'store']);
Route::get('/news/{imagePath}', [ApiNewsController::class, 'sendImage']);


Route::get('/familymakro', [ApiMakroFamilyController::class, 'index']);
Route::post('/familymakro', [ApiMakroFamilyController::class, 'store']);


Route::get('/makro', [ApiMakroController::class, 'index']);
Route::get('/makro/{family_id}', [ApiMakroController::class, 'show']);
Route::get('/makro/details/{makro_id}', [ApiMakroController::class, 'showDetails']);
Route::post('/makro', [ApiMakroController::class, 'store']);
Route::get('/makro/image/{imagePath}', [ApiMakroController::class, 'sendImage']);
Route::post('/makro/search', [ApiMakroController::class, 'search']);

Route::get('records', [ApiRecordController::class, 'index']);
Route::get('records/{id}', [ApiRecordController::class, 'show']);
Route::post('records', [ApiRecordController::class, 'store']);
Route::put('records/{id}', [ApiRecordController::class, 'update']);
Route::delete('records/{id}', [ApiRecordController::class, 'destroy']);


//Route::get('records', [ApiRecordController::class, 'index']);
Route::get('favorites/{id}', [ApiFavoriteController::class, 'show']);
Route::post('favorites', [ApiFavoriteController::class, 'store']);
Route::post('favorites/validate', [ApiFavoriteController::class, 'validateFavorite']);
Route::post('favorites/delete', [ApiFavoriteController::class, 'delete']);
