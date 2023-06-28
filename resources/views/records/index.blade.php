@extends('layouts.app')

@section('title', 'Records Management')

@section('contents')
<hr>
@if(Session::has('success'))
<div class="alert alert-success" role="alert">
    {{Session::get('success')}}
</div>
@endif
<div class="row">
    <div class="col-lg-6">
        <!-- Basic Card Example -->
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">List of Record</h6>

                <a href="{{ route('pdf.full') }}" class="btn btn-info" target="_blank" class="href">Generate Report</a>

            </div>
            <div class="card-body">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr class="text-center">
                            <th>#</th>
                            <th>User Name</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr class="text-center">
                            <th>#</th>
                            <th>User Name</th>
                            <th>Action</th>
                        </tr>
                    </tfoot>
                    <tbody>
                        @if($records->count() >0)
                        @foreach($records as $mk)
                        <tr class="text-center">
                            <td>{{$loop->iteration}} </td>
                            <td class="align-middle">{{$mk->User->user_name}} </td>
                            <td>
                                <div class="btn-group" role="group">
                                    <a href="{{route('records', ['record_id' => $mk->record_id]) }}" type="button" class="btn btn-secondary btn-circle" title="Details"><i class="fas fa-book"></i></a>
                                    <a href="{{route('pdf.single', ['id' => $mk->record_id]) }}" target="_blank" type="button" class="btn btn-info btn-circle" title="Report"><i class="fas fa-check"></i></a>
                                    <!-- <button type="button" class="btn btn-danger btn-circle p-0 delete-btn" data-product-id="{{ $mk->makro_id }}"><i class="fas fa-trash"></i></button> -->
                                    <form id="deleteForm" action="{{route('records.destroy', ['id' => $mk->record_id])}}" method="POST" type="button" class="btn btn-danger btn-circle p-0" onclick="return confirm('Are you sure?')">
                                        @csrf
                                        @method('DELETE')
                                        <button class="btn btn-danger btn-circle m-0" title="Delete"><i class="fas fa-trash"></i></button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        @endforeach
                        @else
                        <tr>
                            <td class="text-center" colspan="5">Record not found</td>
                        </tr>
                        @endif
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-lg-6">

        <!-- Collapsable Card Example -->
        <div class="card shadow mb-4">
            <!-- Card Header - Accordion -->
            <a href="#collapseCardExample1" class="d-block card-header py-3" data-toggle="collapse" role="button" aria-expanded="true" aria-controls="collapseCardExample1">
                <h6 class="m-0 font-weight-bold text-primary">Details of Record</h6>
            </a>
            <!-- Card Content - Collapse -->
            <div class="collapse show" id="collapseCardExample1">
                <div class="card-body">
                    @if(!empty($selectedRecord))

                    <div class="col">
                        <div class="row">
                            <label class="form-label">User Name</label>
                            <input type="text" class="form-control" placeholder="Product Code" value="{{ $selectedRecord->User->user_name  }}" readonly>
                        </div>
                        <div class="row">
                            <label class="form-label">Average Score</label>
                            <input type="text" class="form-control" placeholder="Product Code" value="{{ $selectedRecord->record_average  }}" readonly>

                        </div>
                        <div class="row">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" placeholder="Descriptoin" readonly>{{ $selectedRecord->record_desc}}</textarea>
                        </div>
                        <br>
                        <div id="map"></div>
                        <div class="row">
                            <label class="form-label">Location</label>
                            <textarea class="form-control" placeholder="Descriptoin" readonly>{{ $selectedRecord->location}}</textarea>
                        </div>
                    </div>


                    <script>
                        var latitude = "{{ $selectedRecord->latitude }}";
                        var longitude = "{{ $selectedRecord->longitude }}";
                        // Initialize the map
                        var map = L.map('map').setView([latitude, longitude], 13);

                        // Add the tile layer (OpenStreetMap)
                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                            attribution: '&copy; OpenStreetMap contributors'
                        }).addTo(map);

                        // Add a marker to the map
                        var marker = L.marker([latitude, longitude]).addTo(map);
                    </script>
                    @endif
                </div>
            </div>
        </div>

        <!-- Collapsable Card Example -->
        <div class="card shadow mb-4">
            <!-- Card Header - Accordion -->
            <a href="#collapseCardExample" class="d-block card-header py-3" data-toggle="collapse" role="button" aria-expanded="true" aria-controls="collapseCardExample1">
                <h6 class="m-0 font-weight-bold text-primary">List of Macro</h6>
            </a>
            <!-- Card Content - Collapse -->
            <div class="collapse show" id="collapseCardExample">
                <div class="card-body">
                    @if(!empty($makros))
                    @foreach($makros as $m)
                    <div class="row">
                        <div class="col">
                            <label class="form-label">Macro Name</label>
                            <input type="text" class="form-control" placeholder="Product Code" value="{{ $m['makro_name'] }}" readonly>
                            <label class="form-label">Macro Score</label>
                            <input type="text" class="form-control" placeholder="Product Code" value="{{ $m['makro_mark'] }}" readonly>
                        </div>
                        <div class="col">
                            <label class="form-label">Macro Image</label><br>
                            <img src="{{ asset('assets/images/makro/' . $m['makro_image']) }}" width="100" alt="Feature Image">
                        </div>
                    </div>
                    <hr>
                    @endforeach
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>
@endsection