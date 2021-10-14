extends ColorRect

export(float) var _speed = 1

signal transition_finished()

var fade_in = true

func _animate():
	self.visible = true
	$tween.interpolate_property(material, "shader_param/progress", 1 if fade_in else 0, 0 if fade_in else 1, _speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()
	
func _hide_transition():
	self.visible = !fade_in
	emit_signal("transition_finished")
	fade_in = !fade_in
