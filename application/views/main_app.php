<script src="/js/main.js"></script>

<div class="row">
    <div class="col-md-offset-3 col-md-6">
        <ul id="main-tab-container" class="nav nav-tabs">
            <li class="active"><a href="#pantry" data-toggle="tab">Pomodoro Pantry</a></li>
            <li><a href="#timer" data-toggle="tab">Pomodoro Timer</a></li>
            <li><a href="#stats" data-toggle="tab">Stats</a></li>
            </li>
        </ul>
        <div id="main-tab-content" class="tab-content">
            <div class="tab-pane fade in active" id="pantry">
                <div class="row">
                    <table class="table table-striped" id="pantry-table">
                        <tr>
                            <th>Task</th>
                            <th>Est. Pomodoros</th>
                            <th>Actual Pomodoros</th>
                            <th>Efficiency</th>
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
                                for($i=1;$i<=15;$i++)
                                    echo '<option>'.$i.'</option>';
                                ?>
                            </select>
                        </div>
                        <div class="form-group">
                        <button type="button" id="create-task" class="btn btn-default disabled">Add Task</button>
                           </div>
                    </form>
                    <span>Keep in mind that each pomodoro is 25 minutes in length.</span>
                </div>
            </div>
            <div class="tab-pane fade" id="timer">
                <div class="row">
                    <div>Current Task: <span id="current-task">None</span></div>
                    <div><span id="elapsed">0</span> Pomodoros elapsed.</div>
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
            </div>
            <div class="tab-pane fade" id="stats">
                <p>Coming soon!</p>
            </div>
        </div>
    </div>
</div>