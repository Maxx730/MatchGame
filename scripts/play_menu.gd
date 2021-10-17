extends Node2D

func _ready():
	$menu/transition._animate()

func _on_back():
	$menu/transition._animate()
	$menu/transition.connect("transition_finished", self, "_on_transition_end", [0])

func _on_time_attack_start():
	$menu/transition._animate()
	$menu/transition.connect("transition_finished", self, "_on_transition_end", [2])

func _on_challenge_start():
	pass

func _on_transition_end(scene):
	get_tree().change_scene(resources._scenes[scene])
