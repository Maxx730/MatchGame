extends Camera2D

var _shake_amount = 0
var _offset = offset

func _ready():
	globals._camera = self
	set_process(false)
	
func _process(delta):
	offset = Vector2(rand_range(-_shake_amount, _shake_amount), rand_range(-_shake_amount, _shake_amount)) * delta + _offset
	
func _shake(value, time=0.5, limit=100):
	_shake_amount += value
	if _shake_amount > limit:
		_shake_amount = limit
	
	$_shake_timer.wait_time = time
	set_process(true)
	$_shake_tween.stop_all()
	$_shake_timer.start()
	
func _timer_end():
	_shake_amount = 0
	set_process(false)
	
	$_shake_tween.interpolate_property(self, 'offset', offset, _offset, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$_shake_tween.start()
