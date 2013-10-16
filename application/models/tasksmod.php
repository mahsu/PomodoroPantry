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
        $this->db->insert('tasks',array('user_id' => $user_id, 'task_name' => $task_name, 'date' => $date, 'estimated' => $estimated));
        return $this->db->insert_id();
    }

    /**
     * load all of one user's tasks
     * @param $user_id
     */
    public function loadAllTasks($user_id) {
            $this->db->select(array("task_id", "task_name", "date", "estimated", "actual", "completed"))->where('user_id', $user_id);
            $query = $this->db->get('tasks');
            if ($query->num_rows() > 0) {
                foreach ($query->result_array() as $row)
                    $data[] = $row;
                return $data;
            }
        else return false;
    }

    public function deleteTask($user_id,$task_id) {
        $this->db->delete('tasks',array('user_id' => $user_id, 'task_id' =>$task_id));
        return true;
    }

    /* Updating functions*/

    /**
     * update name/estimated of a task
     * @param $task_id
     * @param $task_name
     * @param $estimated
     * @todo disable updating after task is completed
     */
    public function updateTask($user_id,$task_id,$task_name,$estimated){

    }

    /**
     * update the task status by updating the actual pomodoros
     * @param $task_id
     * @param $actual
     */
    public function updateStatus($user_id,$task_id,$actual,$completed){

    }

    /*Checking functions*/
}