<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TestCase extends Model
{
    use HasFactory;
    protected $table = 'qa_touch_test_cases';

    protected $fillable = ['module_id', 'summary', 'description', 'attachment'];

    public function module()
    {
        return $this->belongsTo(Module::class);
    }

}
