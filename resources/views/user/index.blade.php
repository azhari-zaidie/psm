@extends('layouts.app')

@section('title', 'User Management')

@section('contents')
<hr>
@if(Session::has('success'))
<div class="alert alert-success" role="alert">
    {{Session::get('success')}}
</div>
@endif
<div class="row">
    <div class="col-lg-6">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">List of User</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="3">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>User Name</th>
                                <th>User Email</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th>#</th>
                                <th>User Name</th>
                                <th>User Email</th>
                                <th>Action</th>
                            </tr>
                        </tfoot>
                        <tbody>
                            @if($user->count() >0)
                            @foreach($user as $mk)
                            <tr>
                                <td class="align-middle">{{$loop->iteration}} </td>
                                <td class="align-middle">{{$mk->user_name}} </td>
                                <td class="align-middle">{{$mk->user_email}} </td>
                                <td class="align-middle">
                                    <div class="btn-group" role="group">
                                        <a href="{{route('users', ['user_id' => $mk->user_id])}}" type="button" class="btn btn-secondary btn-circle" title="Details"><i class="fas fa-book"></i></a>
                                        <!-- <button type="button" class="btn btn-danger btn-circle p-0 delete-btn" data-product-id="{{ $mk->family_id }}"><i class="fas fa-trash"></i></button> -->
                                        <form id="deleteForm" action="{{route('users.destroy', $mk->user_id)}}" method="POST" type="button" class="btn btn-danger btn-circle p-0" onclick="return confirm('Are you sure?')">
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
                                <td class="text-center" colspan="5">Users not found</td>
                            </tr>
                            @endif
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-6">

        <!-- Basic Card Example -->
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">User Details</h6>
            </div>
            <div class="card-body">
                @if(!empty($selectedUser))
                <form id="updateForm" action="{{ route('users.update', ['user_id' => $selectedUser->user_id]) }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                    <div class="row">
                        <div class="col">
                            <label class="form-label">User Name</label>
                            <input type="text" class="form-control form-control-user @error('user_name')is-invalid @enderror" placeholder="User Name" name="user_name" value="{{$selectedUser -> user_name}}" required>
                            @error('user_name')
                            <span class="invalid-feedback">
                                {{$message}}
                            </span>
                            @enderror
                        </div>
                        <div class="col">
                            <label class="form-label">user Email</label>
                            <input type="text" class="form-control form-control-user @error('user_email')is-invalid @enderror" placeholder="User Email" name="user_email" value="{{$selectedUser -> user_email}}" required>
                            @error('user_email')
                            <span class="invalid-feedback">
                                {{$message}}
                            </span>
                            @enderror
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col">
                            <label class="form-label">Created at</label>
                            <input type="text" class="form-control" placeholder="News Description" name="news_desc" value="{{$selectedUser->created_at}}" readonly>
                        </div>
                        <div class="col">
                            <label class="form-label">Updated at</label>
                            <input type="text" class="form-control" placeholder="News Description" name="news_desc" value="{{$selectedUser->updated_at}}" readonly>
                        </div>

                    </div>
                    <hr>
                    <div class="row">
                        <div class="col">
                            <label class="form-label">New Password</label>
                            <input type="password" class="form-control form-control-user @error('password')is-invalid @enderror" name="password">

                            @error('password')
                            <span class="invalid-feedback">
                                {{$message}}
                            </span>
                            @enderror
                        </div>
                        <div class="col">
                            <label class="form-label">Confirm Password</label>
                            <input type="password" class="form-control form-control-user @error('password_confirmation')is-invalid @enderror" name="password_confirmation">
                            @error('password_confirmation')
                            <span class="invalid-feedback">
                                {{$message}}
                            </span>
                            @enderror
                        </div>

                    </div>
                    <hr>
                    <div class="row">
                        <div class="col">
                            <button type="submit" class="btn btn-info" title="Update" id="updateBtn">Update <i class="fas fa-check"></i></a>
                        </div>
                    </div>

                    <!-- Confirmation Modal -->
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
                                    Are you sure you want to update this User?
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-primary" id="confirmUpdateBtn">Update</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
                @endif

            </div>
        </div>

    </div>
</div>
<script>
    $(document).ready(function() {

        // Show the confirmation modal when the update button is clicked
        $('#updateBtn').click(function() {
            event.preventDefault();
            var form = $('#updateForm');
            if (form[0].checkValidity() === false) {
                form.addClass('was-validated');
                return;
            }
            $('#confirmationModal').modal('show');
        });

        // Handle the update action when the confirm button is clicked
        $('#confirmUpdateBtn').click(function() {
            // Submit the form or trigger the update action
            $('#updateForm').submit();
        });
    });
</script>
@endsection