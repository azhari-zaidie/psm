<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;


class MakroFeature extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'makro_id',
        'feature_name',
        'feature_desc',
        'feature_image',
        'url',
    ];

    public function makro()
    {
        return $this->belongsTo(Makro::class, 'makro_id', 'makro_id');
    }
}
