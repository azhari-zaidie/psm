<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class RecordItems extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'record_id',
        'makro_id',
    ];

    public function makro()
    {
        return $this->belongsTo(Makro::class, 'makro_id', 'makro_id');
    }

    public function record()
    {
        return $this->belongsTo(Record::class, 'record_id', 'record_id');
    }
}
