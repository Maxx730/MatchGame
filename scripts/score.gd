extends Label

var _current = 0

func _ready():
	globals._score = self

func _process(delta):
	text = String(floor(_current))

func _add_score(amount):
	var _temp = _current
	_current += amount
	set_process(true)
	$tween.interpolate_property(self, '_current', _temp, _current + amount, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()
