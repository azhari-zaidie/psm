<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
class News extends Model
{
    use HasFactory, SoftDeletes;
    protected $dates = ['deleted_at'];
    protected $primaryKey = 'news_id';
    protected $fillable = [
        'news_title',
        'news_desc',
        'news_image',
        'news_category',
        'status',
    ];
}
