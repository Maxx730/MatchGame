extends Node2D

func _ready():
	$tween.interpolate_property(self, 'scale', scale, Vector2(2, 2), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y - 100), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(self, 'modulate', Color.white, Color(1, 1, 1, 0), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()

func _animation_end():
	queue_free()

func _update_combo_count(count = 1):
	$text.text = "Combo x" + String(count)
