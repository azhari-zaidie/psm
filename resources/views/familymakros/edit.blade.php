@extends('layouts.app')

@section('title', 'Update Family Macros')

@section('contents')
<hr />
<form id="updateForm" action="{{route('familymakros.update', $familymakros->family_id)}}" method="POST" enctype="multipart/form-data">
    @csrf
    @method('PUT')
    <div class="col">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Family Macro Information</h6>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col mb-3">
                        <label class="form-label">Family Macro Sceintific Name</label>
                        <input type="text" name="family_scientific_name" class="form-control" placeholder="Title" value="{{ $familymakros->family_scientific_name }}" required>
                        <br>
                        <label class="form-label">Family Macro Name</label>
                        <input type="text" name="family_name" class="form-control" placeholder="Title" value="{{ $familymakros->family_name }}" required>
                        <br>
                        <label for="family_makro_id">Family Macro Status</label>
                        <select name="status" id="family_makro_id" class="form-control" required>
                            @foreach($statusOptions as $value => $label)
                            <option value="{{ $value }}" {{ $familymakros->status == $value ? 'selected' : '' }}>{{ $label }}</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="col mb-3" align="center">
                        <label for="family_makro_id">Family Macro Image</label>
                        <br>
                        <img src="{{ asset('assets/images/familymakro/'.$familymakros->family_image) }}" alt="job image" width="150" title="job image"><br>
                        <input type="file" name="family_image" class="form-control">
                    </div>
                </div>
                <div class="row">
                    <div class="col mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="family_desc" placeholder="Description" required>{{ $familymakros->family_desc }}</textarea>
                    </div>
                </div>
                <div class="row">
                    <button class="btn btn-secondary" id="updateBtn">Update</button>
                </div>
            </div>
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
                    Are you sure you want to update this Family Macro?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="confirmUpdateBtn">Update</button>
                </div>
            </div>
        </div>
    </div>
</form>
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