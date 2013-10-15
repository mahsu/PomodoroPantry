settings =
  pomo: 1 #length of a pomodoro
  shortbreak: 1 #length of a short break
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
  #timer stuff
  initializeTimer()#create the timer

  bindPantry() #bind event listeners to the pantry buttons
  #pantry stuff

)

initializeTimer = () -> #timer stuff
  _resetTimer()
  bindTimerControls()

#bind the start, stop, complete buttons
bindTimerControls = () ->
  #button definitions
  startButton ='<button type="button" id="start-pomodoro" class="btn btn-success">Start Pomodoro</button>'
  stopButton = '<button type="button" id="stop-pomodoro" class="btn btn-danger">Stop Pomodoro</button>'
  doneButton = '<button type="button" id="task-complete" class="btn btn-primary">Mark Task as Complete</button>'

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
      $("#timer-controls").html(startButton)
  )

  #bind task complete button to parent and make it non-instance exclusive
  $("#timer-controls").on('click','#task-complete', ()->
    if confirm("If you stop now, you will not get credit for your current pomodoro cycle.")
      settings.state = 0; #timer is not active
      completTask(current.taskid,current.elapsed)
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

  if state == 8 #end of a pomodoro cycle
    state=0
    $("#pomodoro-timer").css("background-color","#e74c3c"); #change timer background to inactive
  else
    if state % 2 == 1 #next state is break, pomodoro just finished
      current.elapsed +=1 #update pomodoros elapsed counter
      $("#elapsed").text(currentpomodoro.elapsed)
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
  sel.children("td.efficiency").html(Math.round(estimated/actual*100)+"%")
  sel.find("td.actions .start").remove(); #remove the start button

#pantry manager
loadPantry = () ->
  poop = 1

#event handlers for the pantry buttons
bindPantry = () ->
  $("#create-task").click( ()-> #stuff to do when create task button is pressed
    taskname = $("#taskname").val()
    estimated = $("#numberpomodoros").val()
    $("#pantry-table").append('<tr id="'+settings.taskcount+'" class="task"><td class="taskname">'+ taskname+'</td><td class="estimated">'+estimated+'</td><td class="count-actual"></td><td class="efficiency"></td><td class="actions"><button type="button" class="start btn btn-success">Start</button><button type="button" class="edit btn btn-warning">Edit</button><button type="button" class="delete btn btn-danger">Delete</button></td></tr>') #add the task to the table
    settings.taskcount+=1;
    $("#taskname").val("");
    $("#numberpomodoros").val("");
  )

  #start task button is pressed
  $("#pantry-table").on('click','.start', ()->
    current.taskid = $(this).parents("tr.task").attr("id");
    current.taskname = $(this).parent().siblings(".taskname").html();
    console.log current.taskname
    $('#main-tab-container a[href="#timer"]').tab('show');
  )

  #edit task button is pressed
  $("#pantry-table").on('click','.edit', ()->
    #$(this).parents("tr.task").remove();
  )

  #delete task button is pressed
  $("#pantry-table").on('click','.delete', ()->
    $(this).parents("tr.task").remove();
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