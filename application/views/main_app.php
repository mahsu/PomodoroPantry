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
                        <div class="form-group">
                            <label class="sr-only" for="numberpomodoros">Estimated Pomodoros</label>
                            <input type="text" class="form-control" id="numberpomodoros"
                                   placeholder="Estimated Pomodoros">
                            <form action="">
                                <select name="cars">
                                    <option value="volvo">Volvo</option>
                                    <option value="saab">Saab</option>
                                    <option value="fiat">Fiat</option>
                                    <option value="audi">Audi</option>
                                </select>
                            </form>
                        </div>
                        <button type="button" id="create-task" class="btn btn-default">Add Task</button>
                    </form>
                    <span>Keep in mind that each pomodoro is 25 minutes in length.</span>
                </div>
            </div>
            <div class="tab-pane fade" id="timer">
                <div class="row">
                    <div>Current Task:<span id="task">None</span></div>
                    <div><span id="elapsed">0</span> Pomodoros elapsed.</div>
                </div>
                <div class="row">
                    <div class="col-md-offset-4 col-md-4">
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