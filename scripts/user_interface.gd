extends CanvasLayer

var _blur = null

signal _negative_pressed()
signal _positive_pressed()

func _ready():
	globals._user_interface = self
	_blur = globals._blur_instance.instance()
	_blur.visible = false
	add_child_below_node($bottom, _blur)

func _open_dialog():
	_blur.visible = true
	_blur._fade_in()
	
func _add_dialog(title, message, positive_label, negative_label):
	var dialog = globals._dialog_instance.instance()
	dialog._set_data(title, message, positive_label, negative_label)
	dialog.connect("_on_negative", self, "_dialog_negative")
	dialog.connect("_on_positive", self, "_dialog_positive")
	$center.add_child(dialog)
	$center.visible = true

func _close_dialog():
	for child in $center.get_children():
		$center.remove_child(child)
	
	_blur._fade_out()
	_blur.visible = false
	$center.visible = false

func _dialog_negative():
	_close_dialog()

func _dialog_positive():
	emit_signal("_positive_pressed")
