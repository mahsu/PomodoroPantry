<script src="/js/main.js"></script>
<div class="row">
    <div class="col-md-offset-3 col-md-6">
        <ul id="tabcontainer" class="nav nav-tabs">
            <li class="active"><a href="#pantry" data-toggle="tab">Pomodoro Pantry</a></li>
            <li><a href="#timer" data-toggle="tab">Pomodoro Timer</a></li>
            <li><a href="#profile" data-toggle="tab">Stats</a></li>
            </li>
        </ul>
        <div id="myTabContent" class="tab-content">
            <div class="tab-pane fade in active" id="pantry">
                <div class="row">
                    <table class="table table-striped" id="pantry-table">
                        <tr>
                            <th>Task</th>
                            <th>Est. Pomodoros</th>
                            <th>Actual Pomodoros</th>
                            <th>Actions</th>
                        </tr>
                    </table>
                </div>
                <div class="row">
                    <h2>Add a task</h2>

                    <form class="form-inline" role="form">
                        <div class="form-group">
                            <label class="sr-only" for="taskname">Task</label>
                            <input type="text" class="form-control" id="taskname" placeholder="Task Name">
                        </div>
                        <div class="form-group">
                            <label class="sr-only" for="numberpomodoros">Estimated Pomodoros</label>
                            <input type="text" class="form-control" id="numberpomodoros"
                                   placeholder="Estimated Pomodoros">
                        </div>
                        <button type="button" id="create-task" class="btn btn-default">Create Task</button>
                    </form>
                    <span>Keep in mind when estimating the number of required pomodoros that each is 25 minutes in length.</span>
                </div>
            </div>
            <div class="tab-pane fade" id="timer">
                <div class="row">
                    <div>Current Task:<span id="task">None</span></div>
                    <div><span id="elapsed">0</span> Pomodoros elapsed.</div>
                </div>
                <div class="row">
                    <div class="col-md-offset-4 col-md-4">
                        <div style="" id="pomodoro-timer"></div>
                    </div>
                </div>
                <div class="row">
                    <div id="timer-controls">
                    <button type="button" id="start-pomodoro" class="btn btn-success">Start Pomodoro</button>

                    <div id="next"></div>
                    </div>
                </div>
            </div>
            <div class="tab-pane fade" id="dropdown1">
                <p>Etsy mixtape wayfarers, ethical wes anderson tofu before they sold out mcsweeney's organic lomo retro
                    fanny pack lo-fi farm-to-table readymade. Messenger bag gentrify pitchfork tattooed craft beer,
                    iphone
                    skateboard locavore carles etsy salvia banksy hoodie helvetica. DIY synth PBR banksy irony. Leggings
                    gentrify squid 8-bit cred pitchfork. Williamsburg banh mi whatever gluten-free, carles pitchfork
                    biodiesel fixie etsy retro mlkshk vice blog. Scenester cred you probably haven't heard of them,
                    vinyl
                    craft beer blog stumptown. Pitchfork sustainable tofu synth chambray yr.</p>
            </div>
            <div class="tab-pane fade" id="dropdown2">
                <p>Trust fund seitan letterpress, keytar raw denim keffiyeh etsy art party before they sold out master
                    cleanse gluten-free squid scenester freegan cosby sweater. Fanny pack portland seitan DIY, art party
                    locavore wolf cliche high life echo park Austin. Cred vinyl keffiyeh DIY salvia PBR, banh mi before
                    they
                    sold out farm-to-table VHS viral locavore cosby sweater. Lomo wolf viral, mustache readymade
                    thundercats
                    keffiyeh craft beer marfa ethical. Wolf salvia freegan, sartorial keffiyeh echo park vegan.</p>
            </div>
        </div>
    </div>
</div>
