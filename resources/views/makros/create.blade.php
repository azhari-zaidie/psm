@extends('layouts.app')

@section('title', 'Create Macros')

@section('contents')
<h1 class="mb-0">Add Macros</h1>
<hr />
<form action="{{route('makros.store')}}" method="POST" enctype="multipart/form-data">
    @csrf
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

    <button type="button" id="addProductButton">Add New Product</button>

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

    <div class="row">
        <div class="d-grid">
            <button type="submit" class="btn btn-primary">Submit</button>
        </div>
    </div>
</form>

<script>
    const container = document.getElementById('productContainer');
    const addButton = document.getElementById('addProductButton');
    let productCount = 1;

    addButton.addEventListener('click', () => {
        const productDiv = document.createElement('div');
        productDiv.classList.add('col');

        const productNameLabel = document.createElement('label');
        productNameLabel.textContent = `makro ${productCount + 1} Name:`;
        const productNameInput = document.createElement('input');
        productNameInput.type = 'text';
        productNameInput.name = `makro[${productCount}][test_name]`;
        productNameInput.classList.add('form-control');
        productNameInput.required = true;

        const productDescLabel = document.createElement('label');
        productDescLabel.textContent = `makro ${productCount + 1} Description:`;
        const productDescTextarea = document.createElement('textarea');
        productDescTextarea.name = `makro[${productCount}][test_desc]`;
        productDescTextarea.classList.add('form-control');
        productDescTextarea.required = true;

        productDiv.appendChild(productNameLabel);
        productDiv.appendChild(productNameInput);
        productDiv.appendChild(document.createElement('br'));
        container.appendChild(productDiv);
        productDiv.appendChild(productDescLabel);
        productDiv.appendChild(productDescTextarea);

        //container.appendChild(productDiv);

        productCount++;
    });
</script>
@endsection