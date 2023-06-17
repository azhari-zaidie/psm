@extends('layouts.app')

@section('title', 'Create Family Macros')

@section('contents')
<hr />
<form action="{{route('familymakros.store')}}" method="POST" enctype="multipart/form-data">
    @csrf
    <div class="row">
        <div class="col-lg-12">
            <!-- Default Card Example -->
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h6 class="m-0 font-weight-bold text-primary">Family Macro Details</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col">
                            <label for="makro_name">Family Scientific Name:</label>
                            <input type="text" name="family_scientific_name" class="form-control" placeholder="Larvae Beetle" required>
                        </div>
                        <div class="col">
                            <label for="makro_name">Family Macro Name:</label>
                            <input type="text" name="family_name" class="form-control" placeholder="Larvae Beetle" required>
                        </div>
                        <div class="col">
                            <label for="makro_image">Family Macro Image:</label>
                            <input type="file" name="family_image" class="form-control" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label for="family_makro_id">Macro Description:</label>
                            <textarea class="form-control" name="family_desc" placeholder="Description" required></textarea>
                        </div>
                    </div>
                    <br>
                    <div class="row mb-3">
                        <div class="col">
                            <button type="submit" class="btn btn-primary mr-1">Submit</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</form>
@endsection