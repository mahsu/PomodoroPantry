<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Class Usermod
 *
 * contains functions for database management of users
 */
class Usermod extends CI_Model
{

    function __construct()
    {
        // Call the Model constructor
        parent::__construct();
    }

    /*
     * USER FUNCTIONS
     */
    /**
     * Add new user to database
     *
     * also creates required databases
     *
     * @param string $username          username
     * @param string $password          password hashed with bcrypt
     * @param string $email             email of the user
     * @param string $fname             first name
     * @param string $lname             last name
     * @param bool   $verified          whether a user is verified, only 1 for third party authentication (integer bool)
     * @return int|bool $id|false       user id on success, false on failure
     */
    public function addUser($email, $fname = '', $lname = '')
    {
        //$id = bin2hex(openssl_random_pseudo_bytes(15)); //generates a unique id
        $data = array( 'email' => $email, 'fname' => $fname, 'lname' => $lname);
        // Check if the user is already in the database
        if ($this->checkEmail($email)) {
            // Not yet in the database, insert them
            $this->db->insert('users', $data);
        }
            $this->db->select('id')->where("email", $email);
            $query = $this->db->get('users');
            if ($query->num_rows() > 0) {
                $row = $query->row();
                $id = $row->id;

                //also insert to other data tables
                //$this->db->insert('userstats', ARRAY('id' => $id));
                return $id;
            } else
                return false;

        }

    /**
     * checks whether an email is available
     *
     * @param string $email         email to check against
     * @return bool                 true on success, false on fail
     */
    public function checkEmail($email)
    { //checks whether an email is available
        $this->db->where('email', $email);
        $query = $this->db->get('users');
        if ($query->num_rows() == 0)
            return true;
        else
            return false;
    }
}