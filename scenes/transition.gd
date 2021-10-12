extends ColorRect

func _start():
	$tween.interpolate_property(material, "shader_param/progress", 0, 1, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()
	
