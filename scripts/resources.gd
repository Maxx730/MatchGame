extends Node

var _scenes = ["res://scenes/main_menu.tscn", "res://scenes/play_menu.tscn"]
var _sprites = []

func _ready():
	_load_cell_sprites()

func _load_cell_sprites():
	var dir = Directory.new()
	
	dir.open("res://assets/sprites/items")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		else:
			if !(".import" in file):
				pass
			
	dir.list_dir_end()
