extends CharacterBody2D

# Using a biteArray to deal with multiple enemies at a time.
# If two enemies are in the Bite hurtbox, whenever the timer runs down it will attack only the first enemy.
# It also keeps track of enemies inside the hurtbox, instead of enemies having to exit and then enter the hurtbox again to be recognized.
var enemiesWithinRange = []


func _process(_delta):
	print(enemiesWithinRange)

func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = direction.normalized()
	position += velocity * GlobalVars.playerSpeed * delta
	#Old Movement
	#velocity.x = move_toward(velocity.x, GlobalVars.playerSpeed * direction.x, GlobalVars.playerAccel * delta)
	#velocity.y = move_toward(velocity.y, GlobalVars.playerSpeed * direction.y, GlobalVars.playerAccel * delta)
	
	move_and_slide()


func _on_hurtbox_body_entered(body):
	if body.is_in_group("Enemy"):
		enemiesWithinRange.append(body)


func _on_hurtbox_body_exited(body):
	# If an enemy leaves attack range, remove it from enemiesWithinRange
	if body.is_in_group("Enemy"):
		enemiesWithinRange.erase(body)


func _on_bite_timer_timeout():
	if !enemiesWithinRange.is_empty():
		enemiesWithinRange[0].takeDamage(GlobalVars.playerStrength)
		$PlaceholderMunch.play()

func enemy_killed(enemy):
	if enemy.is_in_group("Enemy"):
		enemiesWithinRange.erase(enemy)
