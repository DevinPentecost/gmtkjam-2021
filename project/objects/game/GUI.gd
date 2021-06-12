extends CanvasLayer

onready var _time = $HBoxContainer/Time

func refresh(hits, progress, steps):
	
	$HBoxContainer/BonkCounter.text = "Bonks: " + str(hits)
	$HBoxContainer/Progress.value = progress * 100
	$HBoxContainer/StepCounter.text = "Steps: " + str(steps)

func refresh_time(time):
	var minutes = int(time / 60)
	var seconds = int(time / 1)
	var milliseconds = int(time*1000) % 1000
	var timetext = "%02d:%02d" % [minutes, seconds]
	_time.text = timetext + '.' + str(milliseconds).left(2)
