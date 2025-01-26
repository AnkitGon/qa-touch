<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Module extends Model
{
    use HasFactory;

    protected $table = 'qa_touch_modules';
    protected $fillable = ['name', 'parent_id', 'module_order'];

    public function children()
    {
        return $this->hasMany(Module::class, 'parent_id')->with('children')->orderBy('module_order');
    }

    public function parent()
    {
        return $this->belongsTo(Module::class, 'parent_id');
    }

    public function testCases()
    {
        return $this->hasMany(TestCase::class);
    }
}
