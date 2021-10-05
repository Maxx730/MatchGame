tool

extends Node2D

enum STATES {IDLE, COLLAPSING}

onready var viewport_size = get_viewport().size
onready var window_width = ProjectSettings.get("display/window/size/width")
onready var window_height = ProjectSettings.get("display/window/size/height")
onready var score_instance = preload("res://scenes/floating_score.tscn")

export(int) var rows = 20
export(int) var cols = 20
export(bool) var _debug = false
export(PackedScene) var cell_scene
export(float, 1) var _neighbor_alpha
export(NodePath) var _score_path
export(NodePath) var _game_time

var cells = Array()
var surrounding = Array()
var adjacent = Array()
var first_cell = null
var second_cell = null
var cell_scale = 1
var state = STATES.IDLE
var last_match = 0
var chain_timeout = 0.5
var matched_point_total = Vector2.ZERO

var score_text = null
var score = 0
var time_text = null

func _ready():
	cell_scale = viewport_size / Vector2(window_width, window_height)
	_generate_grid()
	
	if _score_path != null:
		score_text = get_node(_score_path)
		
	if _game_time != null:
		time_text = get_node(_game_time)

func _process(delta):
	_set_game_timer($game_timer.time_left)
	if score_text != null:
		score_text.text = String(floor(score))
		
	if _is_idle(OS.get_ticks_msec() - last_match):
		state = STATES.IDLE
	
func _generate_grid():
	if cell_scene != null:
		for r in rows:
			cells.append([])
			for c in cols:
				var cell = _add_cell(r, c)
				cells[r].append(cell)
				
				while _has_match(r, c, cell):
					cell._generate_type()
				
func _has_match(row, col, cell):
	if col > 1:
		if cells[row][col - 1]._type == cell._get_type() and cells[row][col - 2]._type == cell._get_type():
			return true
	
	if row > 1:
		if cells[row - 1][col]._type == cell._get_type() and cells[row - 2][col]._get_type() == cell._type:
			return true
	
	pass

func _set_clicked_cell(cell):
	if state == STATES.IDLE:
		if first_cell != null:
			if first_cell == cell:
				_reset_selections()
			else:
				if surrounding.find(cell) != -1:
					second_cell = cell
					_swap_points(first_cell, second_cell)
					_check_for_matches()
		else:
			first_cell = cell
			_highlight_surrounding(first_cell)

func _highlight_surrounding(cell):
	if cell._position.y < cols - 1:
		if cells[cell._position.x][cell._position.y + 1] != null:
			cells[cell._position.x][cell._position.y + 1]._set_alpha(0.5, true)
			surrounding.append(cells[cell._position.x][cell._position.y + 1])
	
	if cell._position.y > 0:
		if cells[cell._position.x][cell._position.y - 1] != null:
			cells[cell._position.x][cell._position.y - 1]._set_alpha(0.5, true)
			surrounding.append(cells[cell._position.x][cell._position.y - 1])
		
	if cell._position.x > 0:
		if cells[cell._position.x - 1][cell._position.y] != null:
			cells[cell._position.x - 1][cell._position.y]._set_alpha(0.5, true)
			surrounding.append(cells[cell._position.x - 1][cell._position.y])
		
	if cell._position.x < rows - 1:
		if cells[cell._position.x + 1][cell._position.y] != null:
			cells[cell._position.x + 1][cell._position.y]._set_alpha(0.5, true)
			surrounding.append(cells[cell._position.x + 1][cell._position.y])
		
func _is_highlighted_cell(cell):
	var index = surrounding.find(cell)
	return index != -1
	
func _reset_selections():
	for cell in surrounding:
		if cell != null:
			cell._reset()
				
	surrounding.clear()
	first_cell = null

func _swap_points(_cell_a, _cell_b):
	_cell_a._move_cell(_cell_b.position)
	_cell_b._move_cell(_cell_a.position)
	
	var _pos_a = _cell_a._position
	var _pos_b = _cell_b._position
	
	cells[_pos_a.x][_pos_a.y] = _cell_b
	cells[_pos_b.x][_pos_b.y] = _cell_a
	_cell_b._position = _pos_a
	_cell_a._position = _pos_b

func _get_adjacent_cells(cell):
	var _index = cells.find(cell)

	if _index > 0:
		if cells[_index - 1]._type == cell._type and adjacent.find(cells[_index - 1]) == -1:
			adjacent.append(cells[_index - 1])
			_get_adjacent_cells(cells[_index - 1])
		
	if _index < cells.size() - 1:
		if cells[_index + 1]._type == cell._type and adjacent.find(cells[_index + 1]) == -1:
			adjacent.append(cells[_index + 1])
			_get_adjacent_cells(cells[_index + 1])
	
	if _index > (cols - 1):
		if cells[_index - cols]._type == cell._type and adjacent.find(cells[_index - cols]) == -1:
			adjacent.append(cells[_index - cols])
			_get_adjacent_cells(cells[_index - cols])
	
	if _index < cols * (rows - 1):
		if cells[_index + cols]._type == cell._type and adjacent.find(cells[_index + cols]) == -1:
			adjacent.append(cells[_index + cols])
			_get_adjacent_cells(cells[_index + cols])

func _cell_to_point(r, c):
	var cell_width = (viewport_size.x / cell_scale.x) / cols
	return Vector2((c * cell_width) + (cell_width / 2), r * cell_width)

func _cell_moved():
	#_reset_selections()
	pass

func _check_for_matches():
	var matched = false
	for r in rows:
		for c in cols:
			if cells[r][c] != null:
				var _current_type = cells[r][c]._type
				if c > 0 and c < (cols - 1):
					if cells[r][c - 1] != null and cells[r][c + 1] != null:
						if cells[r][c - 1]._type == _current_type and cells[r][c + 1]._type == _current_type:
							_set_matched_effect([cells[r][c], cells[r][c - 1], cells[r][c + 1]])
							
							cells[r][c]._matched = true
							cells[r][c - 1]._matched = true
							cells[r][c + 1]._matched = true
							matched = true
							
				if r > 0 and r < (rows - 1):
					if cells[r - 1][c] != null and cells[r + 1][c] != null:
						if cells[r - 1][c]._type == _current_type and cells[r + 1][c]._type == _current_type:
							_set_matched_effect([cells[r][c], cells[r + 1][c], cells[r - 1][c]])
							
							cells[r][c]._matched = true
							cells[r + 1][c]._matched = true
							cells[r - 1][c]._matched = true
							matched = true
	if matched:
		_reset_selections()						
		$destroy_timer.start()
		last_match = OS.get_ticks_msec()
		state = STATES.COLLAPSING
	else:
		if state == STATES.IDLE:
			$swap_timer.start()

func _destroyed_matched_cells():
	var _total_matched = 0
	for r in rows:
		for c in cols:
			if cells[r][c] != null:
				if cells[r][c]._matched:
					_add_floating_score(100, cells[r][c].position, cells[r][c]._score_color)
					cells[r][c].queue_free()
					cells[r][c] = null
					_total_matched += 1
	
	if _total_matched > 0:
		globals._camera._shake(100, 0.05)
		
	_set_score(_total_matched * 100)

func _on_destroy_timer_finished():
	_destroyed_matched_cells()
	$collapse_timer.start()

func _move_peices_down():
	for r in rows:
		for c in cols:
			if cells[r][c] == null:
				for row in range(r, -1, -1):
					if cells[row][c] != null:
						#move the cell down
						cells[row][c]._move_cell(_cell_to_point(row + 1, c))
						cells[row + 1][c] = cells[row][c]
						cells[row + 1][c]._position = Vector2(row + 1, c)
						cells[row][c] = null

	$fill_timer.start()
						
func _add_cell(r, c):
	if cell_scene != null:
		var cell = cell_scene.instance()
		cell.position = _cell_to_point(r, c)
		cell.get_child(2).shape.extents.x = 16
		cell.get_child(2).shape.extents.y = 16
		cell._position = Vector2(r, c)
		cell.connect("_on_click", self, "_set_clicked_cell")
		cell.connect("_on_move_complete", self, "_cell_moved")
		add_child(cell)
		return cell		

func _fill_cells():
	for r in rows:
		for c in cols:
			if cells[r][c] == null:
				cells[r][c] = _add_cell(r, c)
	
	_check_for_matches()

func _swap_back():
	print("Swapping Back")
	first_cell._move_cell(second_cell.position)
	second_cell._move_cell(first_cell.position)

	var _pos_first = first_cell._position
	var _pos_second = second_cell._position
		
	cells[_pos_first.x][_pos_first.y] = second_cell
	cells[_pos_second.x][_pos_second.y] = first_cell
	second_cell._position = _pos_first
	first_cell._position = _pos_second
		
	first_cell = null
	second_cell = null
		
	_reset_selections()

func _is_idle(msec):
	var secs = msec / 1000.0
	return secs > 1.0

func _set_score(value):
	$score_tween.interpolate_property(self, 'score', score, score + value, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$score_tween.start()

func _add_floating_score(val, point, color):
	if score_instance != null:
		var inst = score_instance.instance()
		inst.position = Vector2(point.x - 24, point.y)
		add_child(inst)
		inst._move_to(Vector2(point.x - 24, point.y - 100))

func _set_matched_effect(matched_cells):
	for cell in matched_cells:
		cell._set_alpha(0.2, false)
		if cell._modulate != null:
			pass

func _set_game_timer(time_left):
	if time_text != null:
		var minutes = floor(time_left / 60)
		var seconds = floor(fmod(time_left, 60.0))
		
		time_text.text = String(minutes) + ':' + (String(seconds) if seconds > 9 else '0' + String(seconds))

func _game_time_ended():
	pass

