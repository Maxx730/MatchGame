extends Node2D

func _ready():
	$user_interface/transition._animate()
	$user_interface/transition.connect("transition_finished", self, "_on_transition_end")
	
func _on_transition_end():
	print("working")
