extends MarginContainer

var _level = 1
var _target_amount = 0

func _ready():
	globals._level_progress = self

func _add_progress(amount):
	var prog = $vertical/progress
	if prog.value + amount > prog.max_value:
		var leftover = (prog.value + amount) - prog.max_value
		_next_level()
		_add_progress(leftover)
	else:
		prog.value += amount

func _next_level():
	_level += 1
	$vertical/level_text.text = String(_level)
	$vertical/progress.value = 0
	$vertical/progress.max_value = _level * 100
