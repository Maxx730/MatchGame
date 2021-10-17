extends Node2D

export (NodePath) var _content_path

var _main_content = null

func _ready():
	$menu/transition.connect("transition_finished", self, "intro_finished")
	$menu/transition._animate()
	
	if _content_path != null:
		_main_content = get_node(_content_path)
		_main_content.modulate = Color(1, 1, 1, 0)
		
	$menu/margin/vertical/content/vert/play_button.connect("_button_pressed", self, "_open_play_menu")
	$menu/margin/vertical/content/vert/high_scores_button.connect("_button_pressed", self, "_open_high_scores")

func intro_finished():
	if _main_content != null:
		var tween = _main_content.get_child(0)
		tween.interpolate_property(_main_content, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()

func outro_finished():
	get_tree().change_scene(resources._scenes[1])

func _open_play_menu():
	$menu/transition.connect("transition_finished", self, "outro_finished")
	$menu/transition._animate()
	
func _open_settings_menu():
	pass

func _open_high_scores():
	get_tree().change_scene(resources._scenes[3])
