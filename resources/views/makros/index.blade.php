@extends('layouts.app')

@section('title', 'Macro Management')

@section('contents')
<div class="d-flex align-items-center justify-content-between">
    <h1 class="mb-0">List Macros</h1>
    <a href="{{route('makros.create')}}" class="btn btn-primary">Add Macros</a>
</div>
<hr>
@if(Session::has('success'))
<div class="alert alert-success" role="alert">
    {{Session::get('success')}}
</div>
@endif
<table class="table table-hover">
    <thead class="table-primary">
        <tr>
            <th>#</th>
            <th>Name</th>
            <th>Desc</th>
            <th>Image</th>
            <th>Mark</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        @if($makros->count() >0)
        @foreach($makros as $mk)
        <tr>
            <td class="align-middle">{{$loop->iteration}} </td>
            <td class="align-middle">{{$mk->makro_name}} </td>
            <td class="align-middle">{{$mk->makro_desc}} </td>
            <td class="align-middle">
                <img src="{{ asset('assets/images/makro/'.$mk->makro_image) }}" alt="job image" width="100" title="job image" si>
            </td>
            <td class="align-middle">{{$mk->makro_mark}} </td>
            <td class="align-middle">
                <div class="btn-group" role="group">
                    <a href="{{route('makros.show', $mk->makro_id)}}" type="button" class="btn btn-secondary">Details</a>
                    <a href="{{route('makros.edit', $mk->makro_id)}}" type="button" class="btn btn-warning">Update</a>
                    <form action="{{route('makros.destroy', $mk->makro_id)}}" method="POST" type="button" class="btn btn-danger p-0" onsubmit="return confirm('Delete?')">
                        @csrf
                        @method('DELETE')
                        <button class="btn btn-danger m-0">Delete</button>
                    </form>
                </div>
            </td>
        </tr>
        @endforeach
        @else
        <tr>
            <td class="text-center" colspan="5">Makros not found</td>
        </tr>
        @endif
    </tbody>
</table>
@endsection