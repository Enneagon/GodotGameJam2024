extends StaticBody2D

const FOOD = preload("res://Scenes/food.tscn")

func takeDamage(_damage, source, _crit):
	$NestEgg.hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	if source != null:
		source.enemy_killed(self)
	healPlayer()

func getPoisoned():
	pass

func healPlayer():
	GlobalVars.playerHP += GlobalVars.playerHPMax * 0.75
	if GlobalVars.playerHP > GlobalVars.playerHPMax:
		GlobalVars.playerHP = GlobalVars.playerHPMax

func instantiate_food():
	var numFood = randi_range(4, 8)

	for i in range(numFood):
		var food = FOOD.instantiate()
		food.position = position
		get_tree().root.call_deferred("add_child", food)

		# Set the food's velocity to make it fly off in a direction.
		var angle = i * 2 * PI / numFood  # Divide the circle into equal parts.
		var random_angle = randf_range(-PI/8, PI/8)  # Add a random angle between -22.5 and 22.5 degrees.
		angle += random_angle
		var foodDirection = Vector2(cos(angle), sin(angle))  # Calculate the direction vector.
		food.velocity = foodDirection * 20  # Set the velocity. The food will move 2 units per second.
