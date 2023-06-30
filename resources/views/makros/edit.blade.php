@extends('layouts.app')

@section('title', 'Update Macros')

@section('contents')
<hr />
<form id="updateForm" action="{{ route('makros.update', $makro->makro_id) }}" method="POST" enctype="multipart/form-data">
    @csrf
    @method('PUT')

    <div class="col">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Macro Information</h6>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col mb-3">
                        <label class="form-label">Macro Name</label>
                        <input type="text" name="makro_name" class="form-control" placeholder="Title" value="{{ $makro->makro_name }}" required>
                        <br>
                        <label class="form-label">Macro Mark</label>
                        <input type="number" min="1" name="makro_mark" class="form-control" placeholder="Macro Mark" value="{{ $makro->makro_mark }}" required>
                        <br>
                        <label for="family_makro_id">Macro Family:</label>
                        <select name="family_id" id="family_makro_id" class="form-control" required>
                            @foreach($familyMakro as $familyMakro)
                            <option value="{{ $familyMakro->family_id }}" @if ($familyMakro->family_id === $makro->family_id) selected @endif>{{ $familyMakro->family_name }}</option>
                            @endforeach
                        </select>
                        <br>
                        <label for="macro_status">Macro Status</label>
                        <select name="status" id="macro_status" class="form-control" required>
                            @foreach($statusOptions as $value => $label)
                            <option value="{{ $value }}" {{ $makro->status == $value ? 'selected' : '' }}>{{ $label }}</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="col mb-3" align="center">
                        <label for="family_makro_id">Macro Image</label>
                        <br>
                        <img src="{{ asset('assets/images/makro/'.$makro->makro_image) }}" alt="job image" width="150" title="job image"><br>
                        <input type="file" name="makro_image" class="form-control">

                    </div>


                </div>
                <div class="row">
                    <div class="col mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="makro_desc" placeholder="Description" required>{{ $makro->makro_desc }}</textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col">
        <div class="card shadow mb-4">
            <!-- Card Header - Accordion -->
            <div class="card-header py-3 d-flex justify-content-between">
                <a href="#collapseCardExample" class="d-block card-header py-3" data-toggle="collapse" role="button" aria-expanded="true" aria-controls="collapseCardExample">
                    <h6 class="m-0 font-weight-bold text-primary">Macros Features</h6>
                </a>
                <button type="button" class="btn btn-info" id="addProductButton">Add New Feature</button>
            </div>

            <!-- Card Content - Collapse -->
            <div class="collapse show" id="collapseCardExample">
                <div class="card-body" id="formContainer">
                    @foreach ($features as $index => $feature)
                    <div class="row">
                        <div class="col mb-3">
                            <label class="form-label">Feature Name</label>
                            <input type="text" class="form-control" placeholder="Feature Name" name="makro[{{$index}}][current_feature_name]" value="{{ $feature['feature_name'] }}" required>
                            <label class="form-label">Feature Desc</label>
                            <textarea class="form-control" name="makro[{{$index}}][current_feature_desc]" placeholder="Description" required>{{ $feature['feature_desc'] }}</textarea>
                        </div>
                        <div class="col mb-3" align="center">
                            <label class="form-label">Feature Image</label><br>

                            <img src="{{ asset('assets/images/makro/' . $feature['feature_image']) }}" width="100" alt="Feature Image">
                            <br>
                            <!-- Button to update new image -->
                            <input type="file" name="makro[{{$index}}][current_feature_image]" class="form-control">
                        </div>
                    </div>

                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="makro[{{$index}}][current_feature_delete]" value="makro[{{$loop->iteration}}][feature_name]">
                        <label class="form-check-label" style="color: black;">Delete this feature</label>
                    </div>
                    <hr>
                    @endforeach
                </div>
            </div>
        </div>
    </div>

    <div class="col">
        <button class="btn btn-primary" id="updateBtn">Update</button>
    </div>
    <br>
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
                    Are you sure you want to update this Macro?
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
    const container = document.getElementById('productContainer');
    const addButton = document.getElementById('addProductButton');
    let featureCount = 1;

    addButton.addEventListener('click', () => {
        const makroDiv = document.createElement('div');
        makroDiv.classList.add('row');

        var formGroup = document.createElement('div');
        formGroup.classList.add('col', 'mb-3');

        const featureNameLabel = document.createElement('label');
        featureNameLabel.textContent = `Feature Name:`;
        featureNameLabel.classList.add('form-label');
        const featureNameInput = document.createElement('input');
        featureNameInput.type = 'text';
        featureNameInput.name = `newMakro[${featureCount}][new_feature_name]`;
        featureNameInput.classList.add('form-control');
        featureNameInput.required = true;

        // Create the desc input field
        var descFormGroup = document.createElement('div');
        descFormGroup.classList.add('col', 'mb-3');

        const featureDescLabel = document.createElement('label');
        featureDescLabel.textContent = `Feature Description:`;
        featureDescLabel.classList.add('form-label');
        const featureDescTextarea = document.createElement('textarea');
        featureDescTextarea.name = `newMakro[${featureCount}][new_feature_desc]`;
        featureDescTextarea.classList.add('form-control');
        featureDescTextarea.required = true;

        formGroup.appendChild(featureNameLabel);
        formGroup.appendChild(featureNameInput);
        formGroup.appendChild(featureDescLabel);
        formGroup.appendChild(featureDescTextarea);

        var fileFormGroup = document.createElement('div');
        fileFormGroup.classList.add('col', 'mb-3');

        const featureImageLabel = document.createElement('label');
        featureImageLabel.textContent = `Feature Image:`;
        featureImageLabel.classList.add('form-label');
        const featureImageInput = document.createElement('input');
        featureImageInput.type = 'file';
        featureImageInput.name = `newMakro[${featureCount}][new_feature_image]`;
        featureImageInput.classList.add('form-control');
        featureImageInput.required = true;

        fileFormGroup.appendChild(featureImageLabel);
        fileFormGroup.appendChild(featureImageInput);

        //     // Append the form groups to the form container
        makroDiv.appendChild(formGroup);
        makroDiv.appendChild(fileFormGroup);

        // Create the "Remove Form" button
        var removeButton = document.createElement('button');
        removeButton.classList.add('btn', 'btn-danger');
        removeButton.textContent = 'Remove Feature';
        removeButton.addEventListener('click', removeForm);

        // Append the "Remove Form" button to the form container
        makroDiv.appendChild(removeButton);

        //     // Append the form container to the dynamic-form
        var dynamicForm = document.getElementById('formContainer');

        var hrElement = document.createElement("hr");
        hrElement.id = "hr-element";

        // //dynamicForm.appendChild(hrElement);
        dynamicForm.appendChild(makroDiv);
        dynamicForm.appendChild(hrElement);

        featureCount++;
    });

    function removeForm(event) {
        event.preventDefault();
        var dynamicForm = document.getElementById('formContainer');
        var formContainer = event.target.parentNode;
        //dynamicForm.removeChild(formContainer);

        var hrElement = document.getElementById("hr-element");
        hrElement.parentNode.removeChild(hrElement);
        //formContainer.removeChild(hrElement);
        dynamicForm.removeChild(formContainer);
    }
</script>
@endsection