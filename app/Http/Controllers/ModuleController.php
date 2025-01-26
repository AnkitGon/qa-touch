<?php

namespace App\Http\Controllers;

use App\Http\Resources\ModuleResource;
use App\Models\Module;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Response;

class ModuleController extends Controller
{
    public function index()
    {
        $modules = Module::with('children')->whereNull('parent_id')->orderBy('module_order')->get();

        return ModuleResource::collection($modules);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255', 
            'parent_id' => 'nullable|exists:qa_touch_modules,id', 
        ]);
        $module = new Module();
        $module->name = $validated['name'];

        if ($validated['parent_id']) {
            $module->parent_id = $validated['parent_id'];
        } else {
            $module->parent_id = null; 
        }

        $module->save();

        return new ModuleResource($module);
    }

    public function update(Request $request, $id)
    {
        $module = Module::findOrFail($id);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $module->update($validated);

        return response()->json($module, 200); 
    }
    public function destroy($id)
    {
        $module = Module::find($id);

        if ($module) {
            $module->children()->delete(); 
            $module->delete();  

            return response()->json(['message' => 'Module deleted successfully.']);
        }

        return response()->json(['message' => 'Module not found.'], 404);
    }
    public function reorder(Request $request)
    {
        $modules = $request->input('modules');
        foreach ($modules as $index => $moduleData) {
            $module = Module::find($moduleData['id']);
            $module->module_order = $index + 1;
            $module->save();
        }
        return response()->json(['message' => 'Module order updated successfully!']);
    }

}
