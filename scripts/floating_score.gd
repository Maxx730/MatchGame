extends Node2D

onready var label = $value

export(float) var _speed = 0.5

func _move_to(point):
	$floating_score.interpolate_property(self, 'position', position, point, _speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$floating_score.interpolate_property(self, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), _speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$floating_score.start()

func _update_score_value(value):
	$value.text = "+" + String(value)
