<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class FamilyMakro extends Model
{
    use HasFactory, SoftDeletes;
    protected $dates = ['deleted_at'];
    protected $primaryKey = 'family_id';
    protected $fillable = [
        'family_scientific_name',
        'family_name',
        'family_desc',
        'family_image',
        'status',
        'url',
    ];

    public function makros()
    {
        return $this->hasMany(Makro::class, 'family_id', 'family_id');
    }
}
