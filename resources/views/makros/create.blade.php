@extends('layouts.app')

@section('title', 'Create Macros')

@section('contents')
<h1 class="mb-0">Add Macros</h1>
<hr />
<form action="{{route('makros.store')}}" method="POST" enctype="multipart/form-data">
    @csrf
    <div class="form-container" id="formContainer">
    <div class="row mb-3">
        <div class="col">
            <input type="text" name="makro_name" class="form-control" placeholder="Macros Name">
        </div>
        <div class="col">
            <input type="text" name="makro_mark" class="form-control" placeholder="Macros Mark">
        </div>
    </div>
    <div class="row mb-3">
        <div class="col">
            <input type="text" name="family_id" class="form-control" placeholder="Family ID">
        </div>
        <div class="col">
            <textarea class="form-control" name="makro_desc" placeholder="Description"></textarea>
        </div>
    </div>
    <div class="row mb-3" id="productContainer">
        <div class="col">
            <label for="product1Name">Product 1 Name:</label>
            <input type="text" class="form-control" id="product1Name" name="makro[0][test_name]" required>
        </div>
        <div class="col">
            <label for="product1Desc">Product 1 Description:</label>
            <textarea class="form-control" id="product1Desc" name="makro[0][test_desc]" required></textarea>
        </div>
    </div>

    

    <!-- <div class="row mb-3">
        <div class="col">
            <input type="text" name="makro[0][test_name]" class="form-control" placeholder="tesc_name1">
        </div>
        <div class="col">
            <textarea class="form-control" name="makro[0][test_desc]" placeholder="tesc_desc1"></textarea>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col">
            <input type="text" name="makro[1][test_name]" class="form-control" placeholder="tesc_name2">
        </div>
        <div class="col">
            <textarea class="form-control" name="makro[1][test_desc]" placeholder="tesc_desc2"></textarea>
        </div>
    </div> -->

    
    </div>
    <div class="row">
        <div class="d-grid">
            <button type="submit" class="btn btn-primary">Submit</button>
        </div>
        <button type="button" id="addProductButton" onclick="addNewForm()">Add New Product</button>
    </div>
</form>

<script>
    function addNewForm() {
    // Create a new form container
    var formContainer = document.createElement('div');
    formContainer.classList.add('row', 'mb-3');

    // Create the name input field
    var nameFormGroup = document.createElement('div');
    nameFormGroup.classList.add('col');

    var nameLabel = document.createElement('label');
    nameLabel.setAttribute('for', 'name');
    nameLabel.textContent = 'Name';

    var nameInput = document.createElement('input');
    nameInput.classList.add('form-control');
    nameInput.setAttribute('type', 'text');
    nameInput.setAttribute('name', 'name');
    nameInput.setAttribute('placeholder', 'Name');

    nameFormGroup.appendChild(nameLabel);
    nameFormGroup.appendChild(nameInput);

    // Create the email input field
    var emailFormGroup = document.createElement('div');
    emailFormGroup.classList.add('col');

    var emailLabel = document.createElement('label');
    emailLabel.setAttribute('for', 'email');
    emailLabel.textContent = 'Email';

    var emailInput = document.createElement('input');
    emailInput.classList.add('form-control');
    emailInput.setAttribute('type', 'email');
    emailInput.setAttribute('name', 'email');
    emailInput.setAttribute('placeholder', 'Email');

    emailFormGroup.appendChild(emailLabel);
    emailFormGroup.appendChild(emailInput);

    // Append the form groups to the form container
    formContainer.appendChild(nameFormGroup);
    formContainer.appendChild(emailFormGroup);

    // Append the form container to the dynamic-form
    var dynamicForm = document.getElementById('formContainer');
    dynamicForm.appendChild(formContainer);
  }
    // const container = document.getElementById('productContainer');
    // const addButton = document.getElementById('addProductButton');
    // let productCount = 1;

    // addButton.addEventListener('click', () => {
    //     const productDiv = document.createElement('div');
    //     productDiv.classList.add('row mb-3');

    //     var nameFormGroup = document.createElement('div');
    // nameFormGroup.classList.add('form-group');

    //     const productNameLabel = document.createElement('label');
    //     productNameLabel.textContent = `makro ${productCount + 1} Name:`;
    //     const productNameInput = document.createElement('input');
    //     productNameInput.type = 'text';
    //     productNameInput.name = `makro[${productCount}][test_name]`;
    //     productNameInput.classList.add('form-control');
    //     productNameInput.required = true;

    //     nameFormGroup.appendChi

    //     const productDescLabel = document.createElement('label');
    //     productDescLabel.textContent = `makro ${productCount + 1} Description:`;
    //     const productDescTextarea = document.createElement('textarea');
    //     productDescTextarea.name = `makro[${productCount}][test_desc]`;
    //     productDescTextarea.classList.add('form-control');
    //     productDescTextarea.required = true;

    //     productDiv.appendChild(productNameLabel);
    //     productDiv.appendChild(productNameInput);
    //     productDiv.appendChild(document.createElement('br'));
    //     //container.appendChild(productDiv);
    //     productDiv.appendChild(productDescLabel);
    //     productDiv.appendChild(productDescTextarea);

    //     container.appendChild(productDiv);

    //     productCount++;
    // });
</script>
@endsection