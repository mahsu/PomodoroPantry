<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Class Tasksmod
 *
 * contains functions for database management of tasks
 */
class Tasksmod extends CI_Model
{

    function __construct()
    {
        // Call the Model constructor
        parent::__construct();
    }

    /*Saving/loading functions*/

    /**
     * create a new task
     * @param $user_id
     * @param $task_name
     * @param $date
     * @param $estimated
     */
    public function newTask($user_id,$task_name,$date,$estimated) {

    }

    /**
     * load all of one user's tasks
     * @param $user_id
     */
    public function loadAllTasks($user_id) {

    }

    /* Updating functions*/

    /**
     * update name/estimated of a task
     * @param $task_id
     * @param $task_name
     * @param $estimated
     * @todo disable updating after task is completed
     */
    public function updateTask($task_id,$task_name,$estimated){

    }

    /**
     * update the task status by updating the actual pomodoros
     * @param $task_id
     * @param $actual
     */
    public function updateStatus($task_id,$actual){

    }

    /*Checking functions*/
}