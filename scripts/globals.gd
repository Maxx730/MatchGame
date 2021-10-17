extends Node
const Save_Data = preload("res://scripts/save_data.gd")
const _save_file = "user://_save_file.save"

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
var _save_data = Save_Data.new()

func _ready():
	_load_data(_save_file)

func _save_data(file):
	var _file = File.new()
	_file.open(file, File.WRITE)
	_file.store_var(_save_data, true)
	_file.close()
	
func _load_data(file):
	var _file = File.new()
	if _file.file_exists(file):
		_file.open(file, File.READ)
		_save_data = _file.get_var(true)
		_file.close()
	else:
		_save_data(file)
