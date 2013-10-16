<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Class Tasks
 *
 * deals with all the user login functionality
 */
class Tasks extends CI_Controller
{

    /**
     * class constructor
     *
     * @see usermod                 functions that deal with user database management
     * @see form_helper             helps to dynamically generate forms
     * @see message_helper          helps generate twitter bootstrap template messages
     * @see form_validation         form validation library
     * @see classes/password.php    compatibility library with bcrypt hashing for php <5.5
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
        $this->load->model("tasksmod");

    }

    public function index() {
    echo "yolo";
    }
}