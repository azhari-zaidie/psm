<?php

namespace App\Models;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
class Record extends Model
{
    use HasFactory, SoftDeletes;

    protected $primaryKey = 'record_id';
    protected $dates = ['deleted_at'];
    protected $casts = [
        'average_mark' => 'double',
        'latitude' => 'double',
        'longitude' => 'double',
    ];
    protected $fillable = [
        'selected_makro',
        'user_id',
        'record_average',
        'location',
        'latitude',
        'longitude',
        'record_desc',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
