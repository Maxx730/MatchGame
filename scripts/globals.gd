extends Node

#instances
var _combo_text_instance = preload("res://scenes/combo_text.tscn")
var _point_text_instance = preload("res://scenes/floating_score.tscn")
var _dialog_instance = preload("res://scenes/dialog.tscn")
var _blur_instance = preload("res://scenes/blur_shader.tscn")
var _score_instance = preload("res://scenes/final_score.tscn")
var _transition_instance = preload("res://scenes/transition.tscn")

var _camera = null
var _combo_timer = null
var _combo_threshold = 0.8
var _level_progress = null
var _blur_shader = null
var _user_interface = null
var _score = null
var _time = null
var _selector = null
