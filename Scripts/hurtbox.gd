extends Area2D

var biteRange = 15.0

func _process(_delta):
	var direction = (get_global_mouse_position() - self.get_parent().position).normalized()
	position = biteRange * direction
