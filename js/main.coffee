settings =
  pomo: 1 #length of a pomodoro
  shortbreak: 1 #length of a short break
  longbreak: 30 #length of a long break
  break: false #whether on break
  state: 0 #step of the pomodoro process (0=pause, 1,3,5,7 = pomodoro; 2,4,6,8 = break; 8 = long break)
  taskcount: 0 #current number of tasks

currentpomodoro =
  taskname: ""
  estimated: 0
  elapsed: 0
  complete: false

savedata = []

$(document).ready(()->
  #timer stuff
  initializeTimer()#create the timer

  bindPantry() #bind event listeners to the pantry buttons
  #pantry stuff

)

initializeTimer = () -> #timer stuff
  $("#pomodoro-timer").countdown({compact: true, format: 'HMS', description: '', onExpiry: advancePomodoro});

  $("#start-pomodoro").click( ()->
    time = new Date();
    time.setMinutes(time.getMinutes() + settings.pomo);
    $("#pomodoro-timer").countdown('option',{until: time});
    settings.state = 1;
    $(this).unbind();
    $("#start-pomodoro").remove();
    $("#timer-controls").html('<button type="button" id="stop-pomodoro" class="btn btn-danger">Stop Pomodoro</button><button type="button" id="task-complete" class="btn btn-primary">Mark Task as Complete</button>')
  )
  
advancePomodoro = () -> #advance the pomodoro timer to the next state
  state = settings.state
  time = new Date();
  addTime = 0; #time to be added

  if state == 8 #end of a pomodoro cycle
    state=0
    $("#pomodoro-timer").css("background-color","#e74c3c"); #change timer background to inactive
  else
    if state % 2 == 1 #next state is break, pomodoro just finished
      currentpomodoro.elapsed +=1
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
      #update pomodoros elapsed counter

    settings.state+=1
    time.setMinutes(time.getMinutes() + addTime);
    $("#pomodoro-timer").countdown('option',{until: time});


#pantry manager
loadPantry = () ->
  poop = 1

bindPantry = () ->
  $("#create-task").click( ()-> #stuff to do when create task button is pressed
    taskname = $("#taskname").val()
    estimated = $("#numberpomodoros").val()
    $("#pantry-table").append('<tr id="'+settings.taskcount+'" class="task"><td>'+ taskname+'</td><td>'+estimated+'</td><td class="count-actual"></td><td></td><td><button type="button" id="'+settings.taskcount+'" class="start btn btn-success">Start</button><button type="button" id="'+settings.taskcount+'" class="edit btn btn-warning">Edit</button><button type="button" id="'+settings.taskcount+'" class="delete btn btn-danger">Delete</button></td></tr>') #add the task to the table
    settings.taskcount+=1
    $("#taskname").val("");
    $("#numberpomodoros").val("");
  )

  $("#pantry-table").on('click','.start', ()-> #start task button is pressed
    $(this).parents("tr.task").remove();
  )

  $("#pantry-table").on('click','.start', ()-> #edit task button is pressed
    $(this).parents("tr.task").remove();
  )

  $("#pantry-table").on('click','.delete', ()-> #delete task button is pressed
    $(this).parents("tr.task").remove();
  )

###PromptYesNo(text) ->
  #creates a yes/no modal prompt
###