extends MarginContainer

export(int) var _start = 3
export(NodePath) var _blur_path

var _blur = null

func _ready():
	$timer.start()
	$timer.connect("timeout", self, "_on_timeout")
	
	if _blur_path != null:
		_blur = get_node(_blur_path)
		_blur.connect("_fade_finished", self, "_destroy_blur")

func _on_timeout():
	if _start > 1:
		_start -= 1
		$number.text = String(_start)
	else:
		if _blur != null:
			_blur._fade_out()

func _destroy_blur():
	_blur.queue_free()
