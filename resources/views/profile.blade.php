@extends('layouts.app')

@section('title', 'Profile')

@section('contents')

<hr>
@if(Session::has('success'))
<div class="alert alert-success" role="alert">
    {{Session::get('success')}}
</div>
@endif

<div class="row">
    <div class="col">
        <!-- Basic Card Example -->
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Profile Info</h6>
            </div>
            <div class="card-body">
                <form id="updateForm" action="{{ route('update.profile', ['user_id' => auth()->user()->user_id]) }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                    <div class="row">
                        <div class="col">
                            <label class="form-label">User Name</label>
                            <input type="text" class="form-control form-control-user @error('user_name')is-invalid @enderror" placeholder="User Name" name="user_name" value="{{auth()->user()->user_name}}" required>
                            @error('user_name')
                            <span class="invalid-feedback">
                                {{$message}}
                            </span>
                            @enderror
                        </div>
                        <div class="col">
                            <label class="form-label">user Email</label>
                            <input type="text" class="form-control form-control-user @error('user_email')is-invalid @enderror" placeholder="User Email" name="user_email" value="{{auth()->user()->user_email}}" required>
                            @error('user_email')
                            <span class="invalid-feedback">
                                {{$message}}
                            </span>
                            @enderror
                        </div>
                    </div>
                    <br>
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