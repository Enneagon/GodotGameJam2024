extends CharacterBody2D

# Using a biteArray to deal with multiple enemies at a time.
# If two enemies are in the Bite hurtbox, whenever the timer runs down it will attack only the first enemy.
# It also keeps track of enemies inside the hurtbox, instead of enemies having to exit and then enter the hurtbox again to be recognized.
var enemiesWithinRange = []

func _process(_delta):
	print(enemiesWithinRange)

func _physics_process(delta):
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += Input.get_action_strength("move_right")
	if Input.is_action_pressed("move_left"):
		direction.x -= Input.get_action_strength("move_left")
	if Input.is_action_pressed("move_up"):
		direction.y -= Input.get_action_strength("move_up")
	if Input.is_action_pressed("move_down"):
		direction.y += Input.get_action_strength("move_down")

	velocity = direction.normalized() * GlobalVars.playerSpeed
	move_and_collide(velocity * delta)


func _on_hurtbox_body_entered(body):
	if body.is_in_group("Enemy"):
		enemiesWithinRange.append(body)


func _on_hurtbox_body_exited(body):
	remove_enemy_from_enemies_within_range(body)

func remove_enemy_from_enemies_within_range(body):
	if body.is_in_group("Enemy"):
		enemiesWithinRange.erase(body)

func _on_bite_timer_timeout():
	if !enemiesWithinRange.is_empty():
		enemiesWithinRange[0].takeDamage(GlobalVars.playerStrength)
		$PlaceholderMunch.play()

func enemy_killed(enemy):
	# Enemy has been killed so remove it from enemies within range
	remove_enemy_from_enemies_within_range(enemy)
