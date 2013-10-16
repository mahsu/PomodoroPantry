settings =
  pomo: 25 #length of a pomodoro
  shortbreak: 5 #length of a short break
  longbreak: 30 #length of a long break
  break: false #whether on break
  state: 0 #step of the pomodoro process (0=pause, 1,3,5,7 = pomodoro; 2,4,6,8 = break; 8 = long break)
  taskcount: 0 #current number of tasks

current =
  taskid: 0 #id of task
  taskname: "" #name of task
  date: "" #date created
  estimated: 0 #estimated pomodoros
  elapsed: 0 #elapsed
  complete: false #whether complete

savedata = []

$(document).ready(()->
  #create the timer
  _resetTimer()
  bindTimerControls()

  #bind event listeners to the pantry buttons
  bindPantry()
)


#bind the start, stop, complete buttons
bindTimerControls = () ->
  #button definitions
  startButton ='<button type="button" id="start-pomodoro" class="btn btn-success">Start Pomodoro</button>'
  stopButton = '<button type="button" id="stop-pomodoro" class="btn btn-danger">Stop Pomodoro</button>'
  doneButton = '<button type="button" id="task-complete" class="btn btn-primary disabled">Mark Task as Complete</button>' #disable until one pomodoro

  #bind start button to parent and make it non-instance exclusive
  $("#timer-controls").on('click','#start-pomodoro', ()->
    time = new Date();
    time.setMinutes(time.getMinutes() + settings.pomo);
    $("#pomodoro-timer").countdown('option',{until: time});
    settings.state = 1; #timer is active
    #$(this).unbind(); #unbind start button
    $("#start-pomodoro").remove(); #remove start button

    #create stop buttons
    $("#timer-controls").html('')
    if current.taskname == "" #no task is active - don't show task completed button
      $("#timer-controls").html(stopButton)
    else $("#timer-controls").html(stopButton + doneButton)
  )

  #bind stop button to parent and make it non-instance exclusive
  $("#timer-controls").on('click','#stop-pomodoro', ()->
    if confirm("If you stop now, you will not get credit for your current pomodoro cycle.")
      settings.state = 0; #timer is not active
      _resetTimer() #reset the timer
      $("#pomodoro-timer").css("background-color","#e74c3c"); #change timer background to inactive
      $("#timer-controls").html(startButton)
  )

  #bind task complete button to parent and make it non-instance exclusive
  $("#timer-controls").on('click','#task-complete', ()->
      settings.state = 0; #timer is not active
      completeTask(current.taskid,current.elapsed)
      #reset the current task variable
      current.elapsed=0;
      current.taskid=0;
      current.taskname = ""
      current.estimated=0;
      _resetTimer() #reset the timer
      $("#timer-controls").html(startButton)
  )

#advance the pomodoro timer to the next state
advancePomodoro = () ->
  state = settings.state
  time = new Date();
  addTime = 0; #time to be added
  $("#task-complete").removeClass("disabled")
  if state == 8 #end of a pomodoro cycle
    state=0
    $("#pomodoro-timer").css("background-color","#e74c3c"); #change timer background to inactive
  else
    if state % 2 == 1 #next state is break, pomodoro just finished
      current.elapsed +=1 #update pomodoros elapsed counter
      $("#elapsed").text(current.elapsed)
      $.playSound("/sound/timer-alarm.mp3")
      $("#pomodoro-timer").css('background-color','#2ecc71') #change timer background to green

      if state == 7 #long break
        addTime = settings.longbreak
      else
        addTime = settings.shortbreak
    else
      $.playSound("/sound/break-alarm.mp3")
      addTime = settings.pomo
      $("#pomodoro-timer").css("background-color","#e74c3c"); #change timer background to red

    settings.state+=1
    time.setMinutes(time.getMinutes() + addTime);
    $("#pomodoro-timer").countdown('option',{until: time});

#add new task to save data array
#newTask = () ->

#update completed task
completeTask = (taskid,actual) ->
  #insert ajax updating here
  sel = $("#pantry-table tr#"+taskid)
  sel.children("td.count-actual").html(actual)
  estimated=parseInt(sel.children("td.estimated").html())
  sel.children("td.efficiency").html(Math.round(estimated/actual*100)+"%") #update efficiency
  sel.find("td.actions .start").remove(); #remove the start button
  $('#main-tab-container a[href="#pantry"]').tab('show');#return to pantry tab

#pantry manager
loadPantry = () ->
  poop = 1

#event handlers for the pantry buttons
bindPantry = () ->
  $("#create-task").click( ()-> #stuff to do when create task button is pressed
    taskname = $("#taskname").val()
    estimated = $("#numberpomodoros").val()
    $("#pantry-table").append('<tr id="'+settings.taskcount+'" class="task"><td class="taskname">'+ taskname+'</td><td class="estimated">'+estimated+'</td><td class="count-actual">-</td><td class="efficiency">-</td><td class="actions"><button type="button" class="start btn btn-success">Start</button><button type="button" class="edit btn btn-warning">Edit</button><button type="button" class="delete btn btn-danger">Delete</button></td></tr>') #add the task to the table
    settings.taskcount+=1;
    $("#taskname").val("");
    $("#numberpomodoros").val(1);
    $(this).addClass("disabled")
  )

  #start task button is pressed
  $("#pantry-table").on('click','.start', ()->
    _reset(current.taskid) #enable any disabled buttons for previous task
    current.taskid = $(this).parents("tr.task").attr("id");
    current.taskname = $(this).parent().siblings(".taskname").html();
    $("#current-task").html(current.taskname);
    $('#main-tab-container a[href="#timer"]').tab('show');
    $(this).addClass("disabled");
  )

  #edit task button is pressed
  $("#pantry-table").on('click','.edit', ()->
    #$(this).parents("tr.task").remove();
  )

  #delete task button is pressed
  $("#pantry-table").on('click','.delete', ()->
    $(this).parents("tr.task").remove();
  )

  #enable/disable the add task button
  $("#taskname").keyup( ()->
    console.log $(this).val()
    if $(this).val() != ""
      $("#create-task").removeClass("disabled")
    else $("#create-task").addClass("disabled")
  )

###PromptYesNo(text) ->
  #creates a yes/no modal prompt
###

#returns the current date w/o time
_getDate = () ->
  d = new Date();
  day = d.getDate();
  month = d.getMonth() + 1; #Months are zero based
  year = d.getFullYear();
  return month + "-" + day + "-" + year;

#reset the timer by destroying it and recreating it
_resetTimer = () ->
  $("#pomodoro-timer").countdown("destroy");
  $("#pomodoro-timer").countdown({compact: true, format: 'HMS', description: '', onExpiry: advancePomodoro});

  #reset timer descriptions
  $("#current-task").html("None")
  $("#elapsed").html("0")

#reset action buttons for previous task
_reset = (taskid) ->
  sel = $("#pantry-table tr#"+taskid)
  sel.find("td.actions .start").removeClass("disabled")