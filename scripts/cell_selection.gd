extends AnimatedSprite

func _ready():
	globals._selector = self

func _move_to(point):
	print(point)
	$tween.interpolate_property(self, 'position', position, point, 0.01, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()
