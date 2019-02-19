extends Node

func hide_indicator():
	$Indicator/PauseIndicator.visible = false

func toggle_pause():
	get_tree().paused = not get_tree().paused
	$Indicator/PauseIndicator.visible = get_tree().paused

func set_pause(value : bool):
	get_tree().paused = value
	$Indicator/PauseIndicator.visible = get_tree().paused
	
func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()