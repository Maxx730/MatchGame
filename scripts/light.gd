extends Light2D

var _increase = true
export (Vector2) var _start_scale = Vector2(1, 1)
export (Vector2) var _end_scale = Vector2(1.2, 1.2)

export(float) var _amount = 0.5

func _ready():
	_start(_increase)

func _start(increase):
	$tween.interpolate_property(self, 'scale', scale, _end_scale if increase else _start_scale, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()

func _tween_complete():
	_increase = !_increase
	_start(_increase)
