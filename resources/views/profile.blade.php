@extends('layouts.app')

@section('title', 'Profile')

@section('contents')

<div class="col">

</div>

<form method="POST" enctype="multipart/form-data" id="profile_setup_frm" action="">
    <!-- Basic Card Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Profile Info</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col mb-3">
                    <div class="row mt-2">

                        <div class="col-md-6">
                            <label class="labels">Name</label>
                            <input type="text" name="user_name" class="form-control" placeholder="first name" value="{{ auth()->user()->user_name }}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="labels">Email</label>
                            <input type="text" name="user_email" disabled class="form-control" value="{{ auth()->user()->user_email }}" placeholder="Email" readonly>
                        </div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-md-6">
                            <label class="labels">Phone</label>
                            <input type="text" name="phone" class="form-control" placeholder="Phone Number" value="{{ auth()->user()->phone }}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="labels">Address</label>
                            <input type="text" name="address" class="form-control" value="{{ auth()->user()->address }}" placeholder="Address" readonly>
                        </div>
                    </div>
                    <!-- <div class="mt-5 text-center"><button id="btn" class="btn btn-primary profile-button" type="submit">Save Profile</button></div> -->

                </div>
            </div>
        </div>
    </div>

</form>
@endsection