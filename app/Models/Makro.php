<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Makro extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $primaryKey = 'makro_id';
    protected $dates = ['deleted_at'];
    protected $fillable = [
        'makro_name',
        'makro_desc',
        'makro_image',
        'family_id',
        'makro_mark',
        'makro_features',
        'status',
        'url',
    ];

    public function familymakros()
    {
        return $this->belongsTo(FamilyMakro::class);
    }

    public function favorites()
    {
        return $this->belongsTo(Favorite::class);
    }

    public function recordItems()
    {
        return $this->hasMany(RecordItem::class);
    }

    public function makroFeatures()
    {
        return $this->hasMany(MakroFeature::class);
    }
}
