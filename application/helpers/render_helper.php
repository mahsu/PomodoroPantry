<?php

function render($view, $data = null, $title = null)
{
    $CI = & get_instance();

    $CI->load->view('header', array('title' => $title));
    $CI->load->view('navbar');
    $CI->load->view($view, $data);

    file_exists('version.php') && include 'version.php';
    //$vars['app_disp'] = 1; 
    $vars['version'] = isset($version) ? ('v' . ($version / 1000) . 'a') : ('v0000a');
    $CI->load->view('footer', $vars);
}
