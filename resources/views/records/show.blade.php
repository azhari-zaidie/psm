@extends('layouts.app')

@section('title', 'Records Details')

@section('contents')

<hr />

<div class="row">
    <div class="col-lg-6">
        <!-- Basic Card Example -->
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Record Details</h6>

                <a href="{{route('pdf.single', ['id' => $record->record_id]) }}" class="btn btn-secondary" target="_blank" class="href">Generate Report</a>

            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col mb-3">
                        <label class="form-label">User Name</label>
                        <input type="text" name="record_name" class="form-control" placeholder="Title" value="{{ $record->User->user_name }}" readonly>
                    </div>
                </div>

                <div class="row">
                    
                    
                    <div class="col mb-3">
                        <label class="form-label">Record Average</label>
                        <input type="text" name="makro_mark" class="form-control" placeholder="Price" value="{{ $record->record_average }}" readonly>
                    </div>
                    <div class="col mb-3">
                        <label class="form-label">Water Status</label>
                        <input type="text" name="makro_mark" class="form-control" placeholder="Price" value="{{ $water_status }}" readonly>
                    </div>
                </div>
                <div class="row">
                    <div class="col mb-3">
                        <label class="form-label">Created At</label>
                        <input type="text" name="created_at" class="form-control" placeholder="Created At" value="{{ $record->created_at }}" readonly>
                    </div>
                    <div class="col bm-3">
                        <label class="form-label">Updated At</label>
                        <input type="text" name="updated_at" class="form-control" placeholder="Created At" value="{{ $record->updated_at }}" readonly>
                    </div>
                </div>
    
                <div class="row">
    
                    <div class="col mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="makro_desc" placeholder="Descriptoin" readonly>{{ $record->record_desc }}</textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-6">

        <!-- Collapsable Card Example -->
        <div class="card shadow mb-4">
            <!-- Card Header - Accordion -->
            <a href="#collapseCardExample1" class="d-block card-header py-3" data-toggle="collapse" role="button" aria-expanded="true" aria-controls="collapseCardExample1">
                <h6 class="m-0 font-weight-bold text-primary">Details of Location</h6>
            </a>
            <!-- Card Content - Collapse -->
            <div class="collapse show" id="collapseCardExample1">
                <div class="card-body">
                    <div class="row">
                        <div class="col mb-3">
                        
                            <label class="form-label">Location</label>
                            <input type="text" name="family_name" class="form-control" placeholder="Product Code" value="{{ $record->location }}" readonly>
                        </div>
                    </div>
                    <div class="col mb-3" id="map"></div>
                    <script>
                        var latitude = "{{ $record->latitude }}";
                        var longitude = "{{ $record->longitude }}";
                        // Initialize the map
                        var map = L.map('map').setView([latitude, longitude], 13);

                        // Add the tile layer (OpenStreetMap)
                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                            attribution: '&copy; OpenStreetMap contributors'
                        }).addTo(map);

                        // Add a marker to the map
                        var marker = L.marker([latitude, longitude]).addTo(map);
                    </script>
                </div>
            </div>
        </div>
    </div> 
</div>


<div class="row">
    <div class="col">
        <div class="card shadow mb-4">
            <!-- Card Header - Accordion -->
            <a href="#collapseCardExample" class="d-block card-header py-3" data-toggle="collapse" role="button" aria-expanded="true" aria-controls="collapseCardExample">
                <h6 class="m-0 font-weight-bold text-primary">Selected Macros Details</h6>
            </a>
            <!-- Card Content - Collapse -->
            <div class="collapse show" id="collapseCardExample">
                <div class="card-body">
                    @foreach ($recordItems as $feature)
                    <div class="row">
                        <div class="col mb-3">
                            <label class="form-label">Macros Name</label>
                            <input type="text" class="form-control" placeholder="Product Code" value="{{ $feature->makro->makro_name }}" readonly>
                            <br>
                            <label class="form-label">Macros Desc</label>
                            <textarea class="form-control" placeholder="Descriptoin" readonly>{{ $feature->makro->makro_desc }}</textarea>
                        </div>
                        <div class="col mb-3" align="center">
                            <label class="form-label">Macros Image</label><br>
                            <img src="{{ asset('assets/images/makro/' . $feature->makro->makro_image) }}" width="100" alt="Feature Image">
                        </div>
                    </div>
                    <hr>
                    @endforeach
                </div>
            </div>
        </div>
    </div>
</div>

@endsection