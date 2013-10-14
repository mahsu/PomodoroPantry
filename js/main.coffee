settings =
  pomo: 25 #length of a pomodoro
  shortbreak: 5 #length of a short break
  longbreak: 30 #length of a long break
  break: false #whether on break
  state: 0 #step of the pomodoro process (0=pause, 1,3,5,7 = pomodoro; 2,4,6,8 = break; 8 = long break)

currentpomodoro =
  taskname: ""
  estimated: 0
  elapsed: 0
  complete: false

savedata = []

$(document).ready(()->
  $("#pomodoro-timer").countdown({compact: true, format: 'HMS', description: '', onExpiry: advancePomodoro});

  $("#start-pomodoro").click( ()->
    time = new Date();
    time.setMinutes(time.getMinutes() + settings.pomo);
    $("#pomodoro-timer").countdown('option',{until: time});
    settings.state = 1;
    $(this).unbind();
  )
)

advancePomodoro = () ->
  state = settings.state
  time = new Date();
  addTime = 0; #time to be added

  if state = 8 #end of a pomodoro cycle
    state=0
  else
    if state % 2 == 1 #next state is break
      if state != 7 #not a long break
        addTime = settings.shortbreak
      else
        addTime = settings.longbreak
    else
      addTime = settings.pomo
    $("#pomodoro-timer").countdown('option',{until: time});