@extends('layouts.app')

@section('title', 'News Management')

@section('contents')

<div class="d-flex align-items-center justify-content-between">
    <a href="{{route('news.create')}}" class="btn btn-primary">Add News</a>
</div>

<hr>
@if(Session::has('success'))
<div class="alert alert-success" role="alert">
    {{Session::get('success')}}
</div>
@endif
<div class="row">
    <div class="col-lg-6">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">List of News</h6>
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#noticeModal">
                    <i class="fas fa-info-circle" aria-hidden="true"></i>
                </button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                        <thead>
                            <tr class="text-center">
                                <th>#</th>
                                <th>Image</th>
                                <th>Title</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr class="text-center">
                                <th>#</th>
                                <th>Image</th>
                                <th>Title</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </tfoot>
                        <tbody>
                            @if($news->count() >0)
                            @foreach($news as $mk)
                            <tr class="text-center">
                                <td>{{$loop->iteration}} </td>
                                <td>
                                    <img src="{{ asset('assets/images/news/'.$mk->news_image) }}" alt="job image" width="100" title="job image">
                                </td>
                                <td class="align-middle">{{nl2br($mk->news_title, true)}} </td>
                                <td class="align-middle">{{nl2br($mk->status, true)}} </td>
                                <td class="align-middle">
                                    <div class="btn-group" role="group">
                                        <a href="{{route('news', ['news_id' => $mk->news_id])}}" type="button" class="btn btn-secondary btn-circle" title="Details"><i class="fas fa-book"></i></a>
                                        <!-- <button type="button" class="btn btn-danger btn-circle p-0 delete-btn" data-product-id="{{ $mk->makro_id }}"><i class="fas fa-trash"></i></button> -->
                                        <form id="deleteForm" action="{{route('news.destroy', $mk->news_id)}}" method="POST" type="button" class="btn btn-danger btn-circle p-0" onclick="return confirm('Are you sure?')">
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
                                <td class="text-center" colspan="5">News not found</td>
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
    </div>

    <div class="col-lg-6">

        <!-- Basic Card Example -->
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">News Details</h6>
            </div>
            <div class="card-body">
                @if(!empty($selectedNews))
                <form id="updateForm" action="{{ route('news.update', $selectedNews->news_id) }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                    <div class="row">
                        <div class="col">
                            <label class="form-label">News Title</label>
                            <input type="text" class="form-control" placeholder="News Title" name="news_title" value="{{$selectedNews -> news_title}}" required>

                        </div>

                    </div>
                    <br>
                    <div class="row">
                        <div class="col">
                            <label class="form-label">News Categories</label>

                            <select name="category" id="category" class="form-control" required>
                                @foreach($statusOptions as $value => $label)
                                <option value="{{ $value }}" {{ $selectedNews->category == $value ? 'selected' : '' }}>{{ $label }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col">
                            <label class="form-label">News Status</label>

                            <select name="status" id="status" class="form-control" required>
                                @foreach($displayOptions as $value => $label)
                                <option value="{{ $value }}" {{ $selectedNews->status == $value ? 'selected' : '' }}>{{ $label }}</option>
                                @endforeach
                            </select>
                        </div>
                    </div>
                    <br>
                    <div class="row ">
                        <div class="col" style="text-align: center;">
                            <label class="form-label">News Image</label><br>
                            <img src="{{ asset('assets/images/news/' . $selectedNews->news_image) }}" width="400" alt="Feature Image">
                            <hr>
                            <input type="file" name="news_image" class="form-control">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col">
                            <label class="form-label">News Description</label>
                            <textarea class="form-control" name="news_desc" placeholder="News Description" required>{{$selectedNews->news_desc}}</textarea>
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
                                    Are you sure you want to update this News?
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

    <!-- Create the modal dialog with the desired content -->
    <div class="modal fade" id="noticeModal" tabindex="-1" role="dialog" aria-labelledby="noticeModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="noticeModalLabel">About News</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Add your popup content here, e.g., a list of briefings -->
                    <p>This is News pages, in here Admin can display/update and delete by click books icon and trash icon respectively.</p>
                    <p>For updating purpose, News Categories is used to determine the different categories for every News which is Learning or News.</p>
                    <p>Also for News Status is used to determine whether the News will be display on Application or not.</p>
                    <p>Application will only display 4 News only. So Admin need to decide which News will be display on apps.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
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