<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Class Login
 *
 * deals with all the user login functionality
 */
class Login extends CI_Controller
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
        $this->load->model("usermod")

    }

    /**
     * third party authentication through google
     *
     * retrieves email, firstname, lastname from their account
     * then sets a session cookie with this information
     * sets a temportary cookie if first time auth, then redirects them to register a username
     * @see classes/openid.php      class allows for openid authentication
     * @see message_helper          twitter bootstrap message creation assistant
     * @return void
     */
    public function index()
    {
        require(APPPATH . 'classes/openid.php');
        $openid = new LightOpenID($_SERVER['HTTP_HOST']);
        if (!$openid->mode) {
            // Didn't get login info from the OpenID provider yet / came from the login link
            $openid->identity = 'https://www.google.com/accounts/o8/id';
            $openid->required = array('namePerson/first', 'namePerson/last', 'contact/email');
            header('Location: ' . $openid->authUrl());
        } else if ($openid->mode == 'cancel') {
            // The user decided to cancel logging in, so we'll redirect to the home page instead
            $this->session->set_flashdata('result', message('Authentication failed. Try logging in again.', 3));
            redirect(base_url('login'));
        } else {
            // The user has logged in and the user's info is ready
            if (!$openid->validate()) {
                // Authentication failed, try logging in again
                $this->session->set_flashdata('result', message('Authentication failed. Try logging in again.', 3));
                redirect(base_url('login'));
            } else {
                // Authentication was successful

                // Get user attributes:
                $user_data = $openid->getAttributes();

                // Check to make sure that the user is logging in using a @ctemc.org account:
                //if (preg_match('/^[^@]+@ctemc\.org$/', $user_data['contact/email'])) {
                //echo "Welcome, " . " " . $user_data['namePerson/first'] . ' ' . $user_data['namePerson/last'];

                $fname = $user_data['namePerson/first'];
                $lname = $user_data['namePerson/last'];
                $email = $user_data['contact/email'];
                // Add new user or retrieve id of existing user
                $user_id = $this->usermod->addUser($email,$fname,$lname);
                if ($user_id != false){
                    $this->session->set_userdata(array('auth' => 'true', 'email' => $email, 'id' => $user_id));
                    redirect(base_url('register/username'));
                    redirect(base_url('app'));
                } else {
                    exit("Oops. Something went wrong. :(");

                }

            }
        }
    }
}