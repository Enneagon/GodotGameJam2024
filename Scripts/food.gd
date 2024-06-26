extends Node2D

var velocity = Vector2()

var deceleration = 10  # The amount of velocity to subtract in each frame.

@onready var food_1 = $Food1
@onready var food_2 = $Food2
@onready var food_3 = $Food3

var isReadyToBeEaten = false

func _ready():
	var chosen_food = randi() % 3
	if chosen_food == 0:
		food_1.visible = true
	elif chosen_food == 1:
		food_2.visible = true
	else:
		food_3.visible = true

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	position += velocity * delta

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy") || body.is_in_group("Player") && isReadyToBeEaten:
		body.eat_food()
		queue_free()


func _on_timer_timeout():
	if position.x < (-GlobalVars.worldWidth/2) or position.x > (GlobalVars.worldWidth/2) or position.y < (-GlobalVars.worldHeight/2) or position.y > (GlobalVars.worldHeight/2 - 50.0):
		print("Removed OOB food")
		queue_free()
	isReadyToBeEaten = true
	var hungryDinos = $Area2D.get_overlapping_bodies()
	if !hungryDinos.is_empty():
		for body in hungryDinos:
			if body.is_in_group("Enemy") || body.is_in_group("Player"):
				body.eat_food()
				queue_free()
				break
