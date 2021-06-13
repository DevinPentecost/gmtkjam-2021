extends CanvasLayer

onready var _time = $HBoxContainer/Time

func refresh(hits, progress, steps):
	
	$HBoxContainer/BonkCounter.text = "Bonks: " + str(hits)
	var target_progress = progress * 100
	$HBoxContainer/StepCounter.text = "Steps: " + str(steps)
	
	var old_progress = $HBoxContainer/Progress.value
	if target_progress != old_progress:
		$Tween.stop_all()
		$Tween.interpolate_property($HBoxContainer/Progress, "value", old_progress, target_progress, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
	
func refresh_time(time):
	var minutes = int(time / 60)
	var seconds = int(time / 1) % 60
	var milliseconds = int(time*1000) % 1000
	var timetext = "%02d:%02d" % [minutes, seconds]
	_time.text = timetext + '.' + str(milliseconds).left(2)


func _on_Game_game_complete():
	$"HBoxContainer/WINNER!".visible = true
 
