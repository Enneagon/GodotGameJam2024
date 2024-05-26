extends Node2D

var velocity = Vector2()

var deceleration = 10  # The amount of velocity to subtract in each frame.

var isReadyToBeEaten = false

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	position += velocity * delta

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy") || body.is_in_group("Player") && isReadyToBeEaten:
		body.eat_food()
		queue_free()


func _on_timer_timeout():
	isReadyToBeEaten = true