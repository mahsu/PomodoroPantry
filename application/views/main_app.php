<script src="/js/main.min.js"></script>

<div class="container">
    <?php if (!$this->session->userdata('auth'))
    echo '<div class="alert alert-danger"><strong>You are not logged in!</strong> You will not be able to save changes or keep a record of your pomodoros. Please <a href="/login">login</a> to continue.</div>';?>
    <div id="alert-error" class="alert alert-danger" style="display:none;"><span id="alert-text"></span></div>
    <div class="row">
        <div class="col-md-offset-1 col-md-10">
            <ul id="main-tab-container" class="nav nav-tabs">
                <li class="active"><a href="#pantry" data-toggle="tab">Pomodoro Pantry</a></li>
                <li><a href="#timer" data-toggle="tab">Pomodoro Timer</a></li>
                <li><a href="#stats" data-toggle="tab">Stats</a></li>
                <li><a href="#about" data-toggle="tab">About</a></li>
            </ul>
            <div id="main-tab-content" class="tab-content">
                <div class="tab-pane fade in active" id="pantry">
                    <div class="row">
                        <table class="table table-striped" id="pantry-table">
                            <tr>
                                <th>Task</th>
                                <th>Est. Pomodoros</th>
                                <th>Actual Pomodoros</th>
                                <th>Accuracy</th>
                                <th>Actions</th>
                            </tr>
                        </table>
                    </div>
                    <div class="row">
                        <hr/>
                        <form class="form-inline" role="form">
                            <div class="form-group">
                                <strong>Add a Task</strong>
                            </div>
                            <div class="form-group">
                                <label class="sr-only" for="taskname">Task</label>
                                <input type="text" class="form-control" id="taskname" placeholder="Task Name">
                            </div>
                            &nbsp;&nbsp;
                            <div class="form-group">
                                <label for="numberpomodoros">Estimated Pomodoros</label>
                            </div>
                            <div class="form-group">
                                <select id="numberpomodoros" class="form-control">
                                    <?php
                                    for ($i = 1; $i <= 15; $i++)
                                        echo '<option>' . $i . '</option>';
                                    ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <button type="button" id="create-task" class="btn btn-default disabled">Add Task
                                </button>
                            </div>
                        </form>
                        <span>Keep in mind that each pomodoro is 25 minutes in length.</span>
                    </div>
                    <br/>

                    <div class="row">
                        <h3>How to Use:</h3>
                        <ol>
                            <li>Add a new task, estimating the approximate number of pomodoros required for
                                completion.
                            </li>
                            <li>Make a task active by clicking on the corresponding "Start" button.</li>
                            <li>Begin timing when ready, and the app will track the number of pomodoros until the task
                                is marked as complete.
                            </li>
                        </ol>
                    </div>
                </div>
                <div class="tab-pane fade" id="timer">
                    <div class="row">
                        <div class="timer-heading"><span id="current-task"></span> <a id="cancel-task"></a></div>
                        <div class="timer-heading"><span id="elapsed">0</span> Pomodoros elapsed.</div>
                    </div>
                    <div class="row">
                        <div class="col-lg-offset-3 col-lg-6 col-md-offset-2 col-md-8 col-sm-offset-3 col-sm-6">
                            <div id="pomodoro-timer"></div>
                        </div>
                    </div>
                    <div class="row">
                        <div id="timer-controls">
                            <button type="button" id="start-pomodoro" class="btn btn-success">Start Pomodoro</button>

                            <div id="next"></div>
                        </div>
                    </div>
                    <br/>
                    <br/>

                    <div class="row">
                        <div class="col-md-6">
                            <p>Each pomodoro is 25 minutes in length. A pomodoro cycle consists of:
                            <ul>
                                <li>3x 25 minute pomodoros with a short break (5 mins) after each.</li>
                                <li>1x 25 minute pomodoro with a long break (30 mins).</li>
                            </ul>
                            Once the timer is started, it cannot be paused.</p>
                        </div>
                        <div class="col-md-6">
                            <p>Start a task from the pantry tab to keep track of your progress.</p>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="stats">
                    <p>Coming soon!</p>
                </div>
                <div class="tab-pane fade" id="about">
                    <br/>
                    <h4>What is the Pomodoro Technique?</h4>

                    <p>According to the technique's <a href="http://pomodorotechnique.com/" target="_blank">website</a>,
                        "The Pomodoro Technique® is a time management method. This Technique helps you to transform time
                        into a valuable ally by helping you accomplish what you want to do and charting continuous
                        improvement in the way you do it."</p>
                    <br/>
                    <h4>What does the Pomodoro Pantry Do?</h4>

                    <p>The pomodoro pantry provides an easy way to track your progress. Create a new task under the
                        pantry tab, start the task, and the app will do the rest!</p>
                    <br/>
                    <span></span>
                    <h4>Legal</h4>
                        <span>This app is an unofficial implementation of the Pomodoro Technique®.
                            <br/>
This app is not affiliated with, associated with, or endorsed by the Pomodoro Technique® or by Francesco Cirillo.
<br/>
The Pomodoro Technique® and Pomodoro™ are registered trademarks by Francesco Cirillo.</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="modal-edit" tabindex="-1" role="dialog" aria-labelledby="modeal-edit-label"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Edit Task</h4>
                </div>
                <div class="modal-body">
                    <form role="form">
                        <input type="hidden" id="modal-edit-id">

                        <div class="form-group">
                            <label for="modal-edit-name">Task Name</label>
                            <input type="email" class="form-control" id="modal-edit-name" placeholder="Task Name">
                        </div>
                        <div class="form-group">
                            <label for="modal-edit-numberpomodoros">Estimated Pomodoros</label>
                            <select id="modal-edit-numberpomodoros" class="form-control">
                                <?php
                                for ($i = 1; $i <= 15; $i++)
                                    echo '<option>' . $i . '</option>';
                                ?>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="button" id="modal-edit-btn-save" class="btn btn-primary">Save changes</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->
</div>