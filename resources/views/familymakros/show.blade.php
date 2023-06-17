@extends('layouts.app')

@section('title', 'Family Macro Details')

@section('contents')
<hr />
<div class="col">
    <!-- Basic Card Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Family Macros Details</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col mb-3">
                    <label class="form-label">Family Scientific Name</label>
                    <input type="text" name="makro_name" class="form-control" placeholder="Title" value="{{ $familymakros->family_scientific_name }}" readonly>
                </div>
                <div class="col mb-3">
                    <label class="form-label">Family Name</label>
                    <input type="text" name="makro_mark" class="form-control" placeholder="Price" value="{{ $familymakros->family_name }}" readonly>
                </div>
            </div>

            <div class="row">
                <div class="col mb-3">
                    <label class="form-label">Created At</label>
                    <input type="text" name="created_at" class="form-control" placeholder="Created At" value="{{ $familymakros->created_at }}" readonly>
                    <br>
                    <label class="form-label">Status</label>
                    <input type="text" name="updated_at" class="form-control" placeholder="Updated At" value="{{ $familymakros->status }}" readonly>
                </div>

                <div class="col mb-3" align="center">
                    <br>
                    <img src="{{ asset('assets/images/familymakro/'.$familymakros->family_image) }}" alt="job image" width="200" title="job image">
                </div>


            </div>

            <div class="row">

                <div class="col mb-3">
                    <label class="form-label">Description</label>
                    <textarea class="form-control" name="makro_desc" placeholder="Description" readonly>{{ $familymakros->family_desc }}</textarea>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection