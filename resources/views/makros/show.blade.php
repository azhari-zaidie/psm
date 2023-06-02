@extends('layouts.app')

@section('title', 'Show Makros')

@section('contents')

<h1 class="mb-0">Detail Makros</h1>
<hr />
<div class="row">
    <div class="col mb-3">
        <label class="form-label">Name</label>
        <input type="text" name="makro_name" class="form-control" placeholder="Title" value="{{ $makro->makro_name }}" readonly>
    </div>
    <div class="col mb-3">
        <label class="form-label">Total Mark</label>
        <input type="text" name="makro_mark" class="form-control" placeholder="Price" value="{{ $makro->makro_mark }}" readonly>
    </div>
</div>
<div class="row">
    <div class="col mb-3">
        <label class="form-label">Family Id</label>
        <input type="text" name="family_name" class="form-control" placeholder="Product Code" value="{{ $makro->family_id }}" readonly>
    </div>
    <div class="col mb-3">
        <label class="form-label">Description</label>
        <textarea class="form-control" name="makro_desc" placeholder="Descriptoin" readonly>{{ $makro->makro_desc }}</textarea>
    </div>
</div>
<div class="row">
    <div class="col mb-3">
        <label class="form-label">Created At</label>
        <input type="text" name="created_at" class="form-control" placeholder="Created At" value="{{ $makro->created_at }}" readonly>
    </div>
    <div class="col mb-3">
        <label class="form-label">Updated At</label>
        <input type="text" name="updated_at" class="form-control" placeholder="Updated At" value="{{ $makro->updated_at }}" readonly>
    </div>
</div>
@endsection