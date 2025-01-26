<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Google\Client as GoogleClient;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function register(Request $request){
        $emailRule = 'required|string|email|max:255|unique:users|regex:/^[a-zA-Z0-9._%+-]+@gmail\.com$/';

        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => $emailRule,
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user = User::create([
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'password' => Hash::make($validatedData['password']),
        ]);
    

        $token = $user->createToken('GoogleLogin')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ]);

    }
    public function loginWithEmail(Request $request){
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:8',
        ]);

        $user = User::where('email', $validated['email'])->first();

        if (!$user || !Hash::check($validated['password'], $user->password)) {
            return response()->json([
                'message' => 'Invalid credentials',
            ], 401);
        }

        $token = $user->createToken('UserLogin')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ]);

    }

    public function loginWithGoogle(Request $request)
    {
        $token = $request->input('token');

        $response = Http::get('https://oauth2.googleapis.com/tokeninfo', [
            'id_token' => $token
        ]);
        
        if ($response->failed()) {
            return response()->json(['error' => 'Invalid Google token'], 400);
        }

        $googleUser = $response->json();

        if (strpos($googleUser['email'], '@gmail.com') === false) {
            return response()->json(['error' => 'Only Gmail accounts are allowed'], 400);
        }

        $user = User::firstOrCreate(
            ['email' => $googleUser['email']],
            [
                'name' => $googleUser['name'],
                'google_id' => $googleUser['sub'],
                'password' => Hash::make(Str::random(16)),
            ]
        );

        $token = $user->createToken('GoogleLogin')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ]);
    }
}
