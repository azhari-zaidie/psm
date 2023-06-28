@extends('layouts.app')

@section('title', 'Add News')

@section('contents')
<hr>
<form action="{{route('news.store')}}" method="POST" enctype="multipart/form-data">
    @csrf
    <div class="row">
        <div class="col-lg-12">
            <!-- Default Card Example -->
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h6 class="m-0 font-weight-bold text-primary">News Details</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col">
                            <label for="makro_name">News Title:</label>
                            <input type="text" name="news_title" class="form-control" placeholder="Kerjasama" required>
                        </div>
                        <div class="col">
                            <label for="makro_name">Category:</label>
                            <select name="category" id="category" class="form-control" required>
                                @foreach($statusOptions as $value => $label)
                                <option value="{{ $value }}">{{ $label }}</option>
                                @endforeach
                            </select>
                        </div>
                        <div class="col">
                            <label for="makro_image">News Image:</label>
                            <input type="file" name="news_image" class="form-control" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label for="family_makro_id">News Description:</label>
                            <textarea class="form-control" name="news_desc" placeholder="Description" required></textarea>
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