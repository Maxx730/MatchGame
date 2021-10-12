extends Area2D

var _sprites = [
	preload("res://assets/sprites/items/Item_000.png"),
	preload("res://assets/sprites/items/Item_003.png"),
	preload("res://assets/sprites/items/Item_004.png"),
	preload("res://assets/sprites/items/Item_015.png"),
	preload("res://assets/sprites/items/Item_009.png"),
	preload("res://assets/sprites/items/Item_010.png"),
]
var _power_sprites = [preload("res://assets/sprites/items/Item_279.png")]

enum ITEMS {
	WOOD_SWORD,
	COPPER_SWORD,
	STEEL_SWORD,
	RUBY_SWORD,
	GREEN_SWORD,
	PURPLE_SWORD
}
enum POWERUPS {SKULL, BOMB}

signal _on_click(cell)
signal _on_move_complete()

export(float, 2) var _shake_speed
export(float, 3) var _fade_speed
export(NodePath) var _tween_path
export(NodePath) var _modulate_path
export(Color) var _score_color

var _type = 0
var _powerup = 0
var _rng = RandomNumberGenerator.new()
var _selected = false
var _flashing = false
var _fade_in = false
var _tween = null
var _position = Vector2.ZERO
var _matched = false
var _modulate
var _is_powerup = false

func _enter_tree():
	_generate_type()
	
	if _modulate_path != null:
		_modulate = get_node(_modulate_path)
	
	if _tween_path != null:
		_tween = get_node(_tween_path)
	
func _ready():
	$tween.interpolate_property($sprite, 'scale', scale, Vector2(2, 2), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

func _process(delta):
	if _selected:
		pass
		
	if _flashing:
		var target_a = 0
		if _fade_in:
			target_a = 1
		else:
			target_a = 0
			
		if $sprite.modulate.a > 0.9:
			_fade_in = false
			
		if $sprite.modulate.a < 0.3:
			_fade_in = true
			
		$sprite.modulate.a = lerp($sprite.modulate.a, target_a, delta * _fade_speed)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		emit_signal("_on_click", self)
		
func _set_clicked(debug):
	if debug:
		$sprite.modulate = Color.blue

func _set_highlight(debug):
	if debug:
		$sprite.modulate = Color.red
	
func _reset():
	$sprite.modulate = Color.white
	_selected = false
	$sprite.position = Vector2.ZERO
	_set_alpha(1, false)
	_fade_in = false

func _set_alpha(value, flashing):
	$sprite.modulate.a = value
	_flashing = flashing

func _move_cell(point):
	if _tween != null:
		_tween.interpolate_property(self, "position", position, point, .1, Tween.TRANS_BOUNCE, Tween.EASE_OUT_IN)
		_tween.start()

func _generate_type():
	_rng.randomize()
	var value = _rng.randf()

	_rng.randomize()
	self._type = _rng.randi_range(0, ITEMS.values().size() - 1)
	$sprite.texture = _sprites[_type]
	#_set_particle_color()
		
	if $debug_label:
		$debug_label.text = String(_type)
	
func _get_type():
	return self._type

func _tween_completed(obj, key):
	emit_signal("_on_move_complete")
	if _is_powerup:
		match key:
			':scale':
				pass

func _set_particle_color():
	if $shine != null:
		match _type:
			ITEMS.RED_GEM:
				$shine.color = Color.red
			ITEMS.BLUE_GEM:
				$shine.color = Color.blue
			ITEMS.GREEN_GEM:
				$shine.color = Color.green
			ITEMS.ORANGE_GEM:
				$shine.color = Color.orange
			ITEMS.BLACK_PEARL:
				$shine.color = Color.black
			ITEMS.COIN:
				$shine.color = Color.yellow
			ITEMS.RING:
				$shine.color = Color.yellow
