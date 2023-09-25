<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="#">
        <div class="sidebar-brand-icon">
            <img src="assets/images/newlogo.png" width="50">
        </div>
        <div class="sidebar-brand-text mx-3">UjiMakro</div>
    </a>
    <!-- Divider -->
    <hr class="sidebar-divider my-0">

    <!-- Nav Item - Dashboard -->
    <li class="{{request()->is('dashboard') ? 'nav-item active' : 'nav-item'}}">
        <a class="nav-link" href="{{route('dashboard')}}">
            <i class="fas fa-fw fa-tachometer-alt"></i>
            <span>Dashboard</span></a>
    </li>
    <!-- Nav Item - Profile -->
    {{-- <li class="{{request()->is('profile') ? 'nav-item active' : 'nav-item'}}">
        <a class="nav-link" href="/profile">
            <i class="fas fa-fw fa-users"></i>
            <span>Profile</span>
        </a>
    </li> --}}

    <!-- Divider -->
    <hr class="sidebar-divider">

    <!-- Heading -->
    <div class="sidebar-heading">
        Macro Management
    </div>
    <!-- Nav Item - Macros -->
    <li class="{{request()->is('makros') ? 'nav-item active' : 'nav-item'}}">
        <a class="nav-link" href="{{route('makros')}}">
            <i class="fa fa-fw fa-key"></i>
            <span>Macros</span>
        </a>
    </li>

    <li class="{{request()->is('familymakros') ? 'nav-item active' : 'nav-item'}}">
        <a class="nav-link" href="{{route('familymakros')}}">
            <i class="fa fa-fw fa-key"></i>
            <span>Family Macros</span>
        </a>
    </li>

    <!-- Divider -->
    <hr class="sidebar-divider">

    <!-- Heading -->
    <div class="sidebar-heading">
        Others Management
    </div>
    <!-- Nav Item - Macros -->
    <li class="{{request()->is('news') ? 'nav-item active' : 'nav-item'}}">
        <a class="nav-link" href="{{route('news')}}">
            <i class="fa fa-fw fa-book"></i>
            <span>News</span>
        </a>
    </li>

    <li class="{{request()->is('users') ? 'nav-item active' : 'nav-item'}}">
        <a class="nav-link" href="{{route('users')}}">
            <i class="fa fa-fw fa-users"></i>
            <span>User</span>
        </a>
    </li>

    <li class="{{request()->is('records') ? 'nav-item active' : 'nav-item'}}">
        <a class="nav-link" href="{{route('records')}}">
            <i class="fa fa-fw  fa-bars"></i>
            <span>Record</span>
        </a>
    </li>

    <!-- Divider -->
    <hr class="sidebar-divider d-none d-md-block">

    <!-- Sidebar Toggler (Sidebar) -->
    <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>

    <!-- Sidebar Message 
    <div class="sidebar-card d-none d-lg-flex">
        <img class="sidebar-card-illustration mb-2" src="img/undraw_rocket.svg" alt="...">
        <p class="text-center mb-2"><strong>SB Admin Pro</strong> is packed with premium features, components, and more!</p>
        <a class="btn btn-success btn-sm" href="https://startbootstrap.com/theme/sb-admin-pro">Upgrade to Pro!</a>
    </div> -->

</ul>