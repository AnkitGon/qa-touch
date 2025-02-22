<?php

use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\ModuleController;
use App\Http\Controllers\TestCaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

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


Route::post('register', [AuthController::class, 'register']);
Route::post('/login/email', [AuthController::class, 'loginWithEmail']);
Route::post('/login/google', [AuthController::class, 'loginWithGoogle']);

Route::apiResource('modules', ModuleController::class);
Route::post('modules/reorder', [ModuleController::class,'reorder']);

Route::apiResource('test-cases', TestCaseController::class);
Route::post('test-cases/{id}', [TestCaseController::class,'update']);
