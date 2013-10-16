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

    public function newTask() {
        $today = $this->_timeToDay(now() + $this->input->post("tz")*60*-1);//get current date, accounting for time zone differences
                                                              //timezone offset is in minutes, positive -GMT and negative +GMT
        $name = $this->input->post("n"); //name of task
        $estimated = $this->input->post("e");//estimated number of pomodoros
        $task_id =$this->tasksmod->newTask($this->session->userdata("id"),$name,$today,$estimated);//($user_id,$task_name,$date,$estimated)
        echo $task_id;
    }

    public function deleteTask() {
        $task_id = $this->input->post('id');
        $this->tasksmod->deleteTask($this->session->userdata("id"),$task_id);
        echo true;
    }

    public function loadAllTasks() {
        echo json_encode($this->tasksmod->loadAllTasks($this->session->userdata("id")));
    }

    public function updateTask() {
        $this->input->post("id");//name of task
        $this->input->post("e");//estimated pomodoros
    }

    public function updateStatus() {
        $task_id = $this->input->post("id");//task name
        $actual = $this->input->post("a");//actual number of pomodoros
        $completed = $this->input->post("c");//completed
        echo json_encode($this->tasksmod->updateStatus($this->session->userdata('id'),$task_id,$actual,$completed));
    }

    /*private helper functions*/

    /**
     * Converts seconds to unix epoch from days from unix epoch, truncating to int
     *
     * accepts int time
     *
     * @param int $time     unix date integer (seconds from unix epoch)
     * @return int          unix date integer converted to days from unix epoch
     */
    private function _timeToDay($time)
    { //converts a time in unix format to day format
        $time = $time / (24 * 60 * 60);
        return (int)($time);

    }
}