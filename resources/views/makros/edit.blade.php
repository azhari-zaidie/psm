@extends('layouts.app')

@section('title', 'Edit Macros')

@section('contents')
<h1 class="mb-0">Edit Product</h1>
<hr />
<form action="{{ route('makros.update', $makro->makro_id) }}" method="POST">
    @csrf
    @method('PUT')
    <div class="row">
        <div class="col mb-3">
            <label class="form-label">Makro Name</label>
            <input type="text" name="makro_name" class="form-control" placeholder="Title" value="{{ $makro->makro_name }}">
        </div>
        <div class="col mb-3">
            <label class="form-label">Mark</label>
            <input type="text" name="makro_mark" class="form-control" placeholder="Price" value="{{ $makro->makro_mark }}">
        </div>
    </div>
    <div class="row">
        <div class="col mb-3">
            <label class="form-label">Family ID</label>
            <input type="text" name="family_id" class="form-control" placeholder="Product Code" value="{{ $makro->family_id }}">
        </div>
        <div class="col mb-3">
            <label class="form-label">Description</label>
            <textarea class="form-control" name="makro_desc" placeholder="Descriptoin">{{ $makro->makro_desc }}</textarea>
        </div>
    </div>
    <div class="row">
        <div class="d-grid">
            <button class="btn btn-warning">Update</button>
        </div>
    </div>
</form> @endsection