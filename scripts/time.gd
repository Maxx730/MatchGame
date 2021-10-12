extends Label

func _ready():
	globals._time = self
	
func _start():
	pass
	
func _process(delta):
	_set_time($timer.time_left)

func _set_time(time_left):
	var minutes = floor(time_left / 60)
	var seconds = floor(fmod(time_left, 60.0))
		
	text = String(minutes) + ':' + (String(seconds) if seconds > 9 else '0' + String(seconds))

func _game_time_ended():
	var final_score = globals._score_instance.instance()
	globals._user_interface._open_dialog()
	globals._user_interface._add_dialog('Time Up', final_score, 'Retry', 'Cancel')
