@extends('layouts.app')

@section('title', 'Macros Details')

@section('contents')
<hr />
<div class="col">
    <!-- Basic Card Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Macros Details</h6>
        </div>
        <div class="card-body">


            <div class="row">
                <div class="col mb-3">
                    <label class="form-label">Name</label>
                    <input type="text" name="makro_name" class="form-control" placeholder="Title" value="{{ $makro->makro_name }}" readonly>
                </div>
                <div class="col mb-3">
                    <label class="form-label">Total Mark</label>
                    <input type="text" name="makro_mark" class="form-control" placeholder="Price" value="{{ $makro->makro_mark }}" readonly>
                </div>

                <div class="col mb-3">
                    <label class="form-label">Family Id</label>
                    <input type="text" name="family_name" class="form-control" placeholder="Product Code" value="{{ $familyMakro->family_name }}" readonly>
                </div>

            </div>

            <div class="row">

            </div>

            <div class="row">
                <div class="col mb-3">
                    <label class="form-label">Created At</label>
                    <input type="text" name="created_at" class="form-control" placeholder="Created At" value="{{ $makro->created_at }}" readonly>
                    <br>
                    <label class="form-label">Status</label>
                    <input type="text" name="updated_at" class="form-control" placeholder="Updated At" value="{{ $makro->status }}" readonly>
                </div>

                <div class="col mb-3" align="center">
                    <br>
                    <img src="{{ asset('assets/images/makro/'.$makro->makro_image) }}" alt="job image" width="200" title="job image">
                </div>


            </div>

            <div class="row">

                <div class="col mb-3">
                    <label class="form-label">Description</label>
                    <textarea class="form-control" name="makro_desc" placeholder="Descriptoin" readonly>{{ $makro->makro_desc }}</textarea>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="col">
    <div class="card shadow mb-4">
        <!-- Card Header - Accordion -->
        <a href="#collapseCardExample" class="d-block card-header py-3" data-toggle="collapse" role="button" aria-expanded="true" aria-controls="collapseCardExample">
            <h6 class="m-0 font-weight-bold text-primary">Macros Features</h6>
        </a>
        <!-- Card Content - Collapse -->
        <div class="collapse show" id="collapseCardExample">
            <div class="card-body">
                @foreach ($features as $feature)
                <div class="row">
                    <div class="col mb-3">
                        <label class="form-label">Feature Name</label>
                        <input type="text" class="form-control" placeholder="Product Code" value="{{ $feature['feature_name'] }}" readonly>
                        <label class="form-label">Feature Desc</label>
                        <textarea class="form-control" placeholder="Descriptoin" readonly>{{ $feature['feature_desc'] }}</textarea>

                    </div>
                    <div class="col mb-3" align="center">
                        <label class="form-label">Feature Image</label><br>
                        <img src="{{ asset('assets/images/makro/' . $feature['feature_image']) }}" width="100" alt="Feature Image">
                    </div>
                </div>
                <hr>
                @endforeach
            </div>
        </div>
    </div>
</div>
@endsection