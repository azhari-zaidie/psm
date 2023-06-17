@extends('layouts.app')

@section('title', 'Create Macros')

@section('contents')
<hr />
<form action="{{route('makros.store')}}" method="POST" enctype="multipart/form-data">
    @csrf
    <div class="row">
        <div class="col-lg-12">
            <!-- Default Card Example -->
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h6 class="m-0 font-weight-bold text-primary">Macro Details</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col">
                            <label for="makro_name">Macro Name:</label>
                            <input type="text" name="makro_name" class="form-control" placeholder="Larvae Beetle" required>
                        </div>
                        <div class="col">
                            <label for="makro_mark">Macro Mark:</label>
                            <input type="number" min="1" name="makro_mark" class="form-control" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col">
                            <label for="family_makro_id">Macro Family:</label>
                            <select name="family_id" id="family_makro_id" class="form-control" required>
                                @foreach($familyMakro as $f)
                                <option value="{{ $f->family_id }}">{{ $f->family_name }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col">
                            <label for="makro_image">Macro Image:</label>
                            <input type="file" name="makro_image" class="form-control" required>
                        </div>
                    </div>
                    <div class="col">
                        <label for="family_makro_id">Macro Description:</label>
                        <textarea class="form-control" name="makro_desc" placeholder="Description" required></textarea>
                    </div>

                </div>
            </div>
        </div>

        <div class="col-lg-12">
            <!-- Default Card Example -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Macro Feature</h6>

                    <button type="button" class="btn btn-info" id="addProductButton">Add New Feature</button>
                </div>
                <div class="card-body" id="formContainer">
                    <div class="row mb-3" id="productContainer">
                        <div class="col">
                            <label for="product1Name">Feature Name:</label>
                            <input type="text" class="form-control" id="product1Name" name="makro[0][feature_name]" required>
                        </div>
                        <div class="col">
                            <label for="product1Desc">Feature Description:</label>
                            <textarea class="form-control" id="product1Desc" name="makro[0][feature_desc]" required></textarea>
                        </div>
                        <div class="col">
                            <label for="product1Desc">Feature Image:</label>
                            <input type="file" class="form-control" id="product1Desc" name="makro[0][feature_image]" required>
                        </div>
                    </div>
                    <hr>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="d-grid">
            <button type="submit" class="btn btn-primary mr-1">Submit</button>
        </div>
    </div>
</form>

<script>
    const container = document.getElementById('productContainer');
    const addButton = document.getElementById('addProductButton');
    let featureCount = 1;

    addButton.addEventListener('click', () => {
        const makroDiv = document.createElement('div');
        makroDiv.classList.add('row', 'mb-3');

        var nameFormGroup = document.createElement('div');
        nameFormGroup.classList.add('col');

        const featureNameLabel = document.createElement('label');
        featureNameLabel.textContent = `Feature Name:`;
        const featureNameInput = document.createElement('input');
        featureNameInput.type = 'text';
        featureNameInput.name = `makro[${featureCount}][feature_name]`;
        featureNameInput.classList.add('form-control');
        featureNameInput.required = true;

        nameFormGroup.appendChild(featureNameLabel);
        nameFormGroup.appendChild(featureNameInput);

        // Create the desc input field
        var descFormGroup = document.createElement('div');
        descFormGroup.classList.add('col');

        const featureDescLabel = document.createElement('label');
        featureDescLabel.textContent = `Feature Description:`;
        const featureDescTextarea = document.createElement('textarea');
        featureDescTextarea.name = `makro[${featureCount}][feature_desc]`;
        featureDescTextarea.classList.add('form-control');
        featureDescTextarea.required = true;

        descFormGroup.appendChild(featureDescLabel);
        descFormGroup.appendChild(featureDescTextarea);

        var fileFormGroup = document.createElement('div');
        fileFormGroup.classList.add('col');

        const featureImageLabel = document.createElement('label');
        featureImageLabel.textContent = `Feature Image:`;
        const featureImageInput = document.createElement('input');
        featureImageInput.type = 'file';
        featureImageInput.name = `makro[${featureCount}][feature_image]`;
        featureImageInput.classList.add('form-control');
        featureImageInput.required = true;

        fileFormGroup.appendChild(featureImageLabel);
        fileFormGroup.appendChild(featureImageInput);

        //     // Append the form groups to the form container
        makroDiv.appendChild(nameFormGroup);
        makroDiv.appendChild(descFormGroup);
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

        //dynamicForm.appendChild(hrElement);
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