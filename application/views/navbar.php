<!--NAVBAR-->
<div class="navbar navbar-inverse navbar-fixed-top ">
    <button type="button" id="nav-btn" class="navbar-toggle" data-type="open" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>


    <div class="navbar-collapse collapse" style="overflow: hidden;">
        <ul class="nav navbar-nav navbar-left">
            <li><a class="navbar-brand" href="/"><span id="title">Pomodoro Pantry <sup style="font-size:6pt">BETA</sup></span></a></li>
            <li><a href="/">Home</a></li>
            <li><a href="/about">About</a></li>
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <?php
            if ($this->session->userdata('auth') == 'true') {
                echo '<li><a style="background: rgba(0,0,0,0)">Hi ' . $this->session->userdata('name') . '!</a></li>';
                echo '<li><a href="/profile">Profile</a></li>' . '<li><a href="/login/logout">Logout</a>';
            } else {
                echo '<li><a href="/login">Login / Register</a></li>';
            }?>
        </ul>
    </div>
</div>