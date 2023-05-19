<?php

namespace App\Models;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Record extends Model
{
    use HasFactory;

    protected $primaryKey = 'record_id';

    protected $casts = [
        'average_mark' => 'double'
    ];
    protected $fillable = [
        'selected_makro',
        'user_id',
        'record_average',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
