extends TextureProgress

signal _combo_timer_finished

func _ready():
	set_process(false)
	globals._combo_timer = self
	_start()

func _process(delta):
	value = max_value - (max_value * ($timer.time_left / $timer.wait_time))
	
func _timer_finished():
	emit_signal("_combo_timer_finished")
	set_process(false)
	value = 0

func _start():
	value = 0
	$timer.start()
	set_process(true)
