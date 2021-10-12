extends ColorRect

export(float) var _blur_amount = 2

func _ready():
	globals._blur_shader = self
	
func _fade_in():
	$tween.interpolate_property(material, "shader_param/blur_amount", 0, _blur_amount, 0.25, Tween.TRANS_QUAD, Tween.EASE_IN)
	$tween.start()
	
func _fade_out():
	$tween.interpolate_property(material, "shader_param/blur_amount", _blur_amount, 0, 0.25, Tween.TRANS_QUAD, Tween.EASE_IN)
	$tween.start()
	
func _on_fade_finish():
	pass
