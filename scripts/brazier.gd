extends AnimatedSprite

var _increase = true

func _ready():
	_start(_increase)

func _start(increase):
	$tween.interpolate_property($light, 'scale', $light.scale, Vector2(1.2, 1.2) if increase else Vector2(1, 1), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()

func _on_tween_complete():
	_increase = !_increase
	_start(_increase)
