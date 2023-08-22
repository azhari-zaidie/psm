@extends('layouts.app')

@section('title', 'Family Macro Management')

@section('contents')

@if(Session::has('success'))
<div class="alert alert-success" role="alert">
    {{Session::get('success')}}
</div>
@endif

<hr>

<div class="card shadow mb-4">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
         <h6 class="m-0 font-weight-bold text-primary">List of Family Macros</h6>
         <a href="{{route('familymakros.create')}}" class="btn btn-primary">Add Family Macros</a>
        </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="3">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Image</th>
                        <th>Family Name</th>
                        <th>Desc</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>#</th>
                        <th>Image</th>
                        <th>Family Name</th>
                        <th>Desc</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </tfoot>
                <tbody>
                    @if($familymakros->count() >0)
                    @foreach($familymakros as $mk)
                    <tr>
                        <td class="align-middle">{{$loop->iteration}} </td>
                        <td class="align-middle">
                            <img src="{{ asset('assets/images/familymakro/'.$mk->family_image) }}" alt="job image" width="100" title="job image">
                        </td>
                        <td class="align-middle">{{$mk->family_name}} </td>
                        <td class="align-middle">{{$mk->family_desc}} </td>
                        <td class="align-middle">
                            @if($mk->status == 'Pending') 
                                <span class="badge badge-warning">{{$mk->status}}</span>
                            @else
                                <span class="badge badge-success">{{$mk->status}}</span>
                            @endif
                        </td>
                        <td class="align-middle">
                            <div class="btn-group" role="group">
                                <a href="{{route('familymakros.show', $mk->family_id)}}" type="button" class="btn btn-secondary btn-circle" title="Details"><i class="fas fa-book"></i></a>
                                <a href="{{route('familymakros.edit', $mk->family_id)}}" type="button" class="btn btn-info btn-circle" title="Update"><i class="fas fa-check"></i></a>
                                <!-- <button type="button" class="btn btn-danger btn-circle p-0 delete-btn" data-product-id="{{ $mk->family_id }}"><i class="fas fa-trash"></i></button> -->
                                <form id="deleteForm" action="{{route('familymakros.destroy', $mk->family_id)}}" method="POST" type="button" class="btn btn-danger btn-circle p-0" onclick="return confirm('Are you sure?')">
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
                        <td class="text-center" colspan="5">Family Macros not found</td>
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
                    <p>Are you sure you want to delete this Family Macros?</p>
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
    <!-- Confirmation Modal
    <div class="modal fade" id="confirmationModal" tabindex="-1" role="dialog" aria-labelledby="confirmationModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmationModalLabel">Confirmation</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this Family Macro?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="confirmDeleteBtn">Delete</button>
                </div>
            </div>
        </div>
    </div> -->
</div>
<script>
    // Add event listener to delete buttons
    const deleteButtons = document.querySelectorAll('.delete-btn');
    const deleteProductForm = document.getElementById('deleteProductForm');

    deleteButtons.forEach(button => {
        button.addEventListener('click', (event) => {
            event.preventDefault();

            // Set the form action to the product's delete route
            const productId = event.target.getAttribute('data-product-id');
            deleteProductForm.action = `/familymakros/destroy/${productId}`;

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