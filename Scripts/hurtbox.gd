extends Area2D

var biteRange = 15.0
@onready var animated_sprite = $"../AnimatedSprite2D"

func _process(_delta):
	var direction = (get_global_mouse_position() - self.get_parent().position).normalized()
	position = biteRange * direction
	if(direction.x < 0):
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
