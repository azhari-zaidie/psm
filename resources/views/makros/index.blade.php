@extends('layouts.app')

@section('title', 'Macro Management')

@section('contents')


@if(Session::has('success'))
<div class="alert alert-success" role="alert">
    {{Session::get('success')}}
</div>
@endif
<hr>
<div class="card shadow mb-4">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
         <h6 class="m-0 font-weight-bold text-primary">List of Macros</h6>
         <a href="{{route('makros.create')}}" class="btn btn-primary">Add Macros</a>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="3">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Desc</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>#</th>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Desc</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </tfoot>
                <tbody>
                    @if($makros->count() >0)
                    @foreach($makros as $mk)
                    <tr>
                        <td class="align-middle">{{$loop->iteration}} </td>
                        <td class="align-middle">
                            <img src="{{ asset('assets/images/makro/'.$mk->makro_image) }}" alt="job image" width="100" title="job image">
                        </td>
                        <td class="align-middle">{{$mk->makro_name}} </td>
                        <td class="align-middle">{{$mk->makro_desc}} </td>
                        
                        <td class="align-middle">
                            @if($mk->status == 'Pending') 
                                <span class="badge badge-warning">{{$mk->status}}</span>
                            @else
                                <span class="badge badge-success">{{$mk->status}}</span>
                            @endif
                        </td>
                        <td class="align-middle">
                            <div class="btn-group" role="group">
                                <a href="{{route('makros.show', $mk->makro_id)}}" type="button" class="btn btn-secondary btn-circle" title="Details"><i class="fas fa-book"></i></a>
                                <a href="{{route('makros.edit', $mk->makro_id)}}" type="button" class="btn btn-info btn-circle" title="Update"><i class="fas fa-check"></i></a>
                                <!-- <button type="button" class="btn btn-danger btn-circle p-0 delete-btn" data-product-id="{{ $mk->makro_id }}"><i class="fas fa-trash"></i></button> -->
                                <form id="deleteForm" action="{{route('makros.destroy', $mk->makro_id)}}" method="POST" type="button" class="btn btn-danger btn-circle p-0" onclick="return confirm('Are you sure?')">
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
                        <td class="text-center" colspan="5">Makros not found</td>
                    </tr>
                    @endif
                </tbody>
            </table>
        </div>
    </div>

    <!-- Bootstrap Modal -->
    <div class="modal fade" id="deleteConfirmationModal" tabindex="-1" role="dialog" aria-labelledby="deleteConfirmationModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteConfirmationModalLabel">Confirmation</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this Macros?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <form id="deleteProductForm" method="POST" action="">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    // Add event listener to delete buttons
    const deleteButtons = document.querySelectorAll('.delete-btn');
    const deleteProductForm = document.getElementById('deleteProductForm');

    deleteButtons.forEach(button => {
        button.addEventListener('click', (event) => {
            //event.preventDefault();

            // Set the form action to the product's delete route
            const productId = event.target.getAttribute('data-product-id');
            deleteProductForm.action = `/makros/destroy/${productId}`;

            // Show the confirmation modal
            $('#deleteConfirmationModal').modal('show');
        });
    });
    $(document).ready(function() {

        // Show the confirmation modal when the update button is clicked
        $('#deleteBtn').click(function() {
            event.preventDefault();
            $('#confirmationModal').modal('show');
        });

        // Handle the update action when the confirm button is clicked
        $('#confirmDeleteBtn').click(function() {
            // Submit the form or trigger the update action
            $('#deleteForm').submit();
        });
    });
</script>
@endsection