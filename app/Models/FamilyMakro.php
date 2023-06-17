<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FamilyMakro extends Model
{
    use HasFactory;
    protected $primaryKey = 'family_id';
    protected $fillable = [
        'family_scientific_name',
        'family_name',
        'family_desc',
        'family_image',
        'status',
    ];

    public function makros()
    {
        return $this->hasMany(Makro::class);
    }
}
