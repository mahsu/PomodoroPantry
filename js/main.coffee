#@TODO rename all occurrances of efficiency with accuracy

settings =
  pomo: 25 #length of a pomodoro
  shortbreak: 5 #length of a short break
  longbreak: 30 #length of a long break
  state: 0 #step of the pomodoro process (0=pause, 1,3,5,7 = pomodoro; 2,4,6,8 = break; 8 = long break)

current =
  taskid: 0 #id of task
  taskname: "" #name of task
  actual: 0 #actual number of pomodoros
  elapsed: 0 #elapsed

$(document).ready(()->
  #create the timer
  _resetTimer()

  #bind event listeners to timer controls
  bindTimerControls()

  #bind event listeners to the pantry buttons
  bindPantry()

  #load all tasks
  loadTasks()

  #setup ajax defaults
  $.ajaxSetup(
    error: (jqXHR, exception) ->
      if (jqXHR.status == 0)
        _connectionError('Unable to connect to server. Verify your network connection.');
      else if (jqXHR.status == 404)
        _connectionError('404 The requested page was not found.');
      else if (jqXHR.status == 500)
        _connectionError('500 Internal Server Error. Your session has expired, or you are not logged in.');
      else if (exception == 'parsererror')
        _connectionError('Looks like your session has expired. Try refreshing the page and signing in again.');
      else if (exception == 'timeout')
        _connectionError('Request has timed out. The server is probably under heavy load.');
      else if (exception == 'abort')
        _connectionError('Connection request has failed');
      else
        _connectionError('Unexpected Error.\n' + jqXHR.responseText);
  );

  #bind modal close event
  $("#modal-edit").on("hide.bs.modal", () ->
    $("#modal-edit-id").val('');
    $("#modal-edit-name").val(1)
    $("#modal-edit-numberpomodoros").val('')
    $("#modal-edit-btn-save").removeClass("disabled")
  )

  #enable/disable the save changes button
  $("#modal-edit-name").keyup( ()->
    if $(this).val() != ""
      $("#modal-edit-btn-save").removeClass("disabled")
    else $("#modal-edit-btn-save").addClass("disabled")
  )

  #save button event handler
  $("#modal-edit-btn-save").click( ()->
    #save the editted task
    editTask($("#modal-edit-id").val(),$("#modal-edit-name").val(),$("#modal-edit-numberpomodoros").val())
  )
)


##################
# AJAX FUNCTIONS #
##################

#add new task to save data array
newTask = (taskname,estimated) ->
  $.ajax(
    url: "/tasks/newTask",
    type: 'POST',
    data:
      n: taskname
      e: estimated
      tz: new Date().getTimezoneOffset()
    dataType: 'json', #data format
    success: (data) ->  #refresh stats on success
      $("#pantry-table").append('<tr id="'+data+'" class="task"><td class="taskname">'+ taskname+'</td><td class="estimated">'+estimated+'</td><td class="count-actual">-</td><td class="efficiency">-</td><td class="actions"><button type="button" class="start btn btn-success">Start</button><button type="button" class="edit btn btn-warning">Edit</button><button type="button" class="delete btn btn-danger">Delete</button></td></tr>') #add the task to the table
      #settings.taskcount+=1;
      $("#taskname").val("");
      $("#numberpomodoros").val(1);
      $("#create-task").addClass("disabled")
  )

#delete a task
deleteTask = (taskid,selector) ->
  $.ajax(
    url: "/tasks/deleteTask",
    type: 'POST',
    data:
      id: taskid
    dataType: 'json', #data format
    success: (data) ->  #refresh stats on success
      selector.remove();
      _resetTimer() #clear pomodoro timer
  )

#load tasks
loadTasks = () ->
  $.ajax(
    url: "/tasks/loadAllTasks",
    type: 'GET',
    dataType: 'json', #data format
    success: (data) ->  #refresh stats on success
      for i in data
        efficiency = '-' #do not calculate efficiency unless task is complete
        #determine if task is complete
        if parseInt(i.actual) == 0
          i.actual = '-'
        if i.completed&1 == 1 #convert from string to integer
          efficiency = Math.round(i.estimated/ i.actual*100)+"%"
        $("#pantry-table").append('<tr id="'+i.task_id+'" class="task"><td class="taskname">'+ i.task_name+'</td><td class="estimated">'+i.estimated+'</td><td class="count-actual">'+i.actual+'</td><td class="efficiency">'+efficiency+'</td><td class="actions"><button type="button" class="start btn btn-success">Start</button><button type="button" class="edit btn btn-warning">Edit</button><button type="button" class="delete btn btn-danger">Delete</button></td></tr>') #add the task to the table
        if i.completed&1 == 1 #disable buttons if task is completed
          $("tr.task#"+i.task_id+" .start").addClass("disabled")
          $("tr.task#"+i.task_id+" .edit").addClass("disabled")
        #settings.taskcount+=1;
        $("#taskname").val("");
        $("#numberpomodoros").val(1);
    )

#update the actual number of pomodoros or whether task is complete
updateStatus = (taskid,actual,completed,backgroundUpdate) ->
  actual = current.actual + actual
  $.ajax(
    url: "/tasks/updateStatus",
    type: 'POST',
    data:
      id: taskid
      a: actual
      c: completed&1
    dataType: 'json', #data format
    success: (data) ->  #refresh stats on success
      if backgroundUpdate == false #do not update in the background - task is actually complete
        $("tr.task#"+current.taskid).find(".start").removeClass("disabled")#enable the start button again
        settings.state = 0; #timer is not active
        _resetTimer() #reset the timer
        $("#pomodoro-timer").css("background-color","#e74c3c"); #change timer background to inactive
        $('#main-tab-container a[href="#pantry"]').tab('show');#return to pantry tab

        #update pantry
        selector = $("tr.task#"+taskid)
        selector.find(".count-actual").text(actual)
        if completed == true
          selector.find(".start").addClass("disabled")
          selector.find(".edit").addClass("disabled")
          selector.find(".efficiency").text(Math.round(current.estimated/actual*100)+"%")
  )

#edit a task name or estimated pomodoros
editTask = (taskid,taskname,estimated) ->
  $.ajax(
    url: "/tasks/editTask",
    type: 'POST',
    data:
      id: taskid
      n: taskname
      e: estimated
    dataType: 'json', #data format
    success: (data) ->  #refresh stats on success
      $("#modal-edit").modal('hide');
      $("tr#"+taskid+" .taskname").text(taskname);
      $("tr#"+taskid+" .estimated").text(estimated);
  )



  ###
  BIND BUTTON EVENTS
  ###

#bind the start, stop, complete buttons
bindTimerControls = () ->
  #button definitions
  startButton ='<button type="button" id="start-pomodoro" class="btn btn-success">Start Pomodoro</button>'
  stopButton = '<button type="button" id="stop-pomodoro" class="btn btn-danger">Stop Pomodoro</button>'
  doneButton = '<button type="button" id="task-complete" class="btn btn-primary ">Mark Task as Complete</button>' #disable until one pomodoro (experimenting w/ enabled)

  #bind start button to parent and make it non-instance exclusive
  $("#timer-controls").on('click','#start-pomodoro', ()->
    time = new Date();
    time.setMinutes(time.getMinutes() + settings.pomo);
    #time.setSeconds(time.getSeconds() + settings.pomo);
    $("#pomodoro-timer").countdown('option',{until: time});
    settings.state = 1; #timer is active
    $("#start-pomodoro").remove(); #remove start button

    #create stop buttons
    $("#timer-controls").text('')
    if current.taskname == "" #no task is active - don't show task completed button
      $("#timer-controls").html(stopButton)
    else
      $("#timer-controls").html(stopButton + doneButton)
      if current.actual >0 #allow completion if more than 1 pomodoro elapsed
          $("#task-complete").removeClass('disabled')
  )

  #bind stop button to parent and make it non-instance exclusive
  $("#timer-controls").on('click','#stop-pomodoro', ()->
    if confirm("If you stop now, you will not get credit for your current pomodoro cycle.")
      updateStatus(current.taskid,current.elapsed,false,false)
      $("#timer-controls").html(startButton)
  )

  #bind task complete button to parent and make it non-instance exclusive
  $("#timer-controls").on('click','#task-complete', ()->
      #completeTask(current.taskid,current.elapsed)
      updateStatus(current.taskid,current.elapsed,true,false)
      $("#timer-controls").html(startButton)
  )

  #bind cancel current task button
  $("#cancel-task").click( (e)->
    e.preventDefault() #prevent link from triggering
    if settings.state != 0 #timer is currently active
      if confirm("If you stop now, you will not get credit for your current pomodoro cycle.")
        updateStatus(current.taskid,current.elapsed,false,false)
        $("#timer-controls").html(startButton)
    _resetTimer() #reset timer
    _reset(current.taskid) #remove active task
    $('#main-tab-container a[href="#pantry"]').tab('show');#return to pantry tab
  )


#event handlers for the pantry buttons
bindPantry = () ->
  $("#create-task").click( ()-> #stuff to do when create task button is pressed
    taskname = $("#taskname").val()
    estimated = $("#numberpomodoros").val()
    newTask(taskname,estimated)
  )

  #start task button is pressed
  $("#pantry-table").on('click','.start', ()->
    _reset(current.taskid) #enable any disabled buttons for previous task

    #set the current task container
    current.taskid = $(this).parents("tr.task").attr("id");
    current.taskname = $(this).parent().siblings(".taskname").text();
    current.estimated = parseInt($(this).parent().siblings(".estimated").text())
    current.actual = parseInt($(this).parent().siblings(".count-actual").text())

    #check for NaN exceptions
    if isNaN(current.estimated)
      current.estimated=0
    if isNaN(current.actual)
      current.actual=0

    #timer visual elements
    $("#cancel-task").text("(Cancel)");
    $("#current-task").text(current.taskname); #set the current task
    $("#elapsed").text(current.actual); #set current elapsed
    $('#main-tab-container a[href="#timer"]').tab('show'); #switch to timer tab
    $(this).addClass("disabled");


  )

  #edit task button is pressed
  $("#pantry-table").on('click','.edit', ()->
    $("#modal-edit").modal('show');
    $("#modal-edit-id").val($(this).parents("tr.task").attr("id"));
    $("#modal-edit-name").val($(this).parent().siblings(".taskname").text())
    $("#modal-edit-numberpomodoros").val($(this).parent().siblings(".estimated").text())
  )

  #delete task button is pressed
  $("#pantry-table").on('click','.delete', ()->
    taskSelector = $(this).parents("tr.task")
    id = taskSelector.attr("id")
    deleteTask(id,taskSelector)
  )

  #enable/disable the add task button
  $("#taskname").keyup( ()->
    if $(this).val() != ""
      $("#create-task").removeClass("disabled")
    else $("#create-task").addClass("disabled")
  )

###
  MISC HELPER FUNCTIONS
###

#advance the pomodoro timer to the next state
_advancePomodoro = () ->
  state = settings.state
  time = new Date();
  addTime = 0; #time to be added
  $("#task-complete").removeClass("disabled")
  if state == 8 #end of a pomodoro cycle
    #end of cycle
    #state=0
    #settings.state=0
    #$("#pomodoro-timer").css("background-color","#e74c3c"); #change timer background to inactive
    #updateStatus(current.taskid,current.elapsed,false,false)

    #start another pomodoro
    settings.state=0
    $.playSound("/sound/break-alarm.mp3")
    addTime = settings.pomo
    $("#pomodoro-timer").css("background-color","#e74c3c"); #change timer background to red
  else
    if state % 2 == 1 #next state is break, pomodoro just finished
      current.elapsed +=1 #update pomodoros elapsed counter
      updateStatus(current.taskid,current.elapsed,false,true) #save data
      $("#elapsed").text(current.elapsed+current.actual)
      $.playSound("/sound/timer-alarm.mp3")
      $("#pomodoro-timer").css('background-color','#2ecc71') #change timer background to green

      if state == 7 #long break
        addTime = settings.longbreak
      else
        addTime = settings.shortbreak
    else
      #start another pomodoro
      $.playSound("/sound/break-alarm.mp3")
      addTime = settings.pomo
      $("#pomodoro-timer").css("background-color","#e74c3c"); #change timer background to red

    settings.state+=1
    time.setMinutes(time.getMinutes() + addTime);
    $("#pomodoro-timer").countdown('option',{until: time});

#returns the current date w/o time
_getDate = () ->
  d = new Date();
  day = d.getDate();
  month = d.getMonth() + 1; #Months are zero based
  year = d.getFullYear();
  return month + "-" + day + "-" + year;

#add minutes (mainly used to account for timezone offset
_addMinutes = (date, minutes) ->
  return new Date(date.getTime() + minutes*60000);

#reset the timer by destroying it and recreating it
_resetTimer = () ->
  $("#pomodoro-timer").countdown("destroy");
  $("#pomodoro-timer").countdown({compact: true, format: 'HMS', description: '', onExpiry: _advancePomodoro});

  #reset timer descriptions
  $("#current-task").text("")
  $("#elapsed").text("0")
  $("#cancel-task").text("");

#reset action buttons for previous task
_reset = (taskid) ->
  sel = $("#pantry-table tr#"+taskid)
  sel.find("td.actions .start").removeClass("disabled")
  sel.find("td.actions .edit").removeClass("disabled")
  #reset the current task variable
  current.elapsed=0;
  current.taskid=0;
  current.taskname = "";
  current.estimated=0;
  current.actual = 0;

#reset all action buttons

#render an error
_connectionError = (txt) ->
  $("#alert-error").show();
  $("#alert-text").text(txt);