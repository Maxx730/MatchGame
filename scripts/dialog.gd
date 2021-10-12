extends Panel

export(float) var _entrance_length = 0.75

signal _on_negative()
signal _on_positive()

func _ready():
	modulate = Color(1, 1, 1, 0)
	$tween.interpolate_property(self, 'modulate', modulate, Color.white, _entrance_length, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()

func _set_data(title, content, positive_label, negative_label):
	$dialog_title.text = title
	if content != null:
		$margin/vertical/message/margin.add_child(content)
		
	$margin/vertical/actions/action_positive.text = positive_label
	$margin/vertical/actions/action_negative.text = negative_label

func _on_negative_choice():
	emit_signal("_on_negative")
	
func _on_positive_choice():
	emit_signal("_on_positive")

