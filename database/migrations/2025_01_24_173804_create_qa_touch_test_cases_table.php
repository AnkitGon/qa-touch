<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateQaTouchTestCasesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        if (!Schema::hasTable('qa_touch_test_cases')) {

            Schema::create('qa_touch_test_cases', function (Blueprint $table) {
                $table->id();
                $table->foreignId('module_id')->constrained('qa_touch_modules')->onDelete('cascade');
                $table->text('summary');
                $table->text('description')->nullable();
                $table->string('attachment')->nullable();
                $table->timestamps();
            });
        }
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('qa_touch_test_cases');
    }
}
