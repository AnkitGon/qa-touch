<?php

namespace App\Http\Controllers;

use App\Http\Resources\ModuleResource;
use App\Http\Resources\TestCaseResource;
use App\Models\Module;
use App\Models\TestCase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class TestCaseController extends Controller
{
    public function index()
    {
        $modules = Module::orderBy('module_order')->get();

        return ModuleResource::collection($modules);
    }
    public function show($moduleId)
    {
        $testCases = TestCase::where('module_id', $moduleId)->get();
        return response()->json($testCases);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'module_id' => 'required|exists:qa_touch_modules,id',
            'summary' => 'required|string',
            'description' => 'nullable|string',
            'attachment' => 'nullable|file|mimes:jpg,png,pdf,docx',
        ]);

        if ($request->hasFile('attachment')) {
            $path = $request->file('attachment')->store('attachments');
        }

        $testCase = TestCase::create([
            'module_id' => $validated['module_id'],
            'summary' => $validated['summary'],
            'description' => $validated['description'] ?? '',
            'attachment' => $path ?? null,
        ]);

        return response()->json($testCase, 201);
    }

    public function update($id, Request $request)
    {
        $validated = $request->validate([
            'module_id' => 'required|exists:qa_touch_modules,id',
            'summary' => 'required|string|max:255',
            'description' => 'nullable|string',
            'attachment' => 'nullable|file|mimes:jpeg,png,jpg,pdf,docx|max:2048',
        ]);

        $testCase = TestCase::find($id);
        if (!$testCase) {
            return response()->json(['message' => 'Test case not found'], 404);
        }

        $testCase->module_id = $validated['module_id'];
        $testCase->summary = $validated['summary'];
        $testCase->description = $validated['description'] ?? '';

        if ($request->hasFile('attachment')) {
            $attachmentPath = $request->file('attachment')->store('attachments', 'public');
            $testCase->attachment = $attachmentPath;
        }

        $testCase->save();

        return response()->json($testCase, 200);
    }

    public function destroy($id)
    {
        $testCase = TestCase::find($id);
        if (!$testCase) {
            return response()->json(['message' => 'Test case not found'], 404);
        }

        if ($testCase->attachment && Storage::disk('public')->exists($testCase->attachment)) {
            Storage::disk('public')->delete($testCase->attachment);
        }
        $testCase->delete();

        return response()->json(['message' => 'Test case deleted successfully'], 200);
    }
}
