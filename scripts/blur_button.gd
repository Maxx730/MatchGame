tool
extends MarginContainer

export var _label = "Button"

signal _button_pressed()

func _ready():
	$margin/button.text = _label

func _on_pressed():
	emit_signal("_button_pressed")
