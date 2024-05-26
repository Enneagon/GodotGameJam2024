extends Area2D

var biteRange = 15.0
var targetDirection = Vector2.LEFT
var direction = Vector2.LEFT
var elapsed = 0.5

func _process(delta):
	direction = direction.lerp(targetDirection, elapsed * delta).normalized()
	position = direction * biteRange * self.get_parent().enemyRangeMultiplier
