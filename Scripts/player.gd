extends CharacterBody2D

# Maybe use a List instead of an array since we're adding and removing elements frequently
var biteArray = []

func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	velocity = direction.normalized()
	position += velocity * GlobalVars.playerSpeed * delta
	#Old Movement
	#velocity.x = move_toward(velocity.x, GlobalVars.playerSpeed * direction.x, GlobalVars.playerAccel * delta)
	#velocity.y = move_toward(velocity.y, GlobalVars.playerSpeed * direction.y, GlobalVars.playerAccel * delta)
	
	move_and_slide()


func _on_hurtbox_body_entered(body):
	if body.is_in_group("Enemy"):
		biteArray.append(body)


func _on_hurtbox_body_exited(body):
	if body.is_in_group("Enemy"):
		biteArray.erase(body)


func _on_bite_timer_timeout():
	if !biteArray.is_empty():
		biteArray[0].takeDamage(GlobalVars.playerStrength)
		$PlaceholderMunch.play()

func enemy_killed(enemy):
	if enemy.is_in_group("Enemy"):
		biteArray.erase(enemy)
