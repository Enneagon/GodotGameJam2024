extends Area2D

var biteRange = 15.0
var targetDirection = Vector2.LEFT
var direction = Vector2.LEFT
var targetRotation = 0.0
var elapsed = 0.5
var startPos = position

func _process(delta):
	targetRotation = lerp_angle(direction.angle(), targetDirection.angle(), self.get_parent().enemyRotationSpeed * self.get_parent().speedEffectMultiplier * delta)
	
	direction = Vector2.RIGHT.rotated(targetRotation)
	position = (direction * biteRange * self.get_parent().enemyRangeMultiplier) + startPos
