<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Makro extends Model
{
    use HasFactory;
    protected $primaryKey = 'makro_id';
    protected $fillable = [
        'makro_name',
        'makro_desc',
        'makro_image',
        'family_id',
        'makro_mark',
        'makro_features',
    ];

    public function familymakros()
    {
        return $this->belongsTo(FamilyMakro::class);
    }

    public function favorites()
    {
        return $this->belongsTo(Favorite::class);
    }
}
