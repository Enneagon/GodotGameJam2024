extends Enemy

signal bossKilled

func _ready():
	# Enemy names, just for fun until we get art.
	$Name.text = enemyNameShort
	enemyHP = enemyHPMax
	$HPBar.max_value = enemyHPMax
	$HPBar.value = enemyHP
	$HPBar.hide()
	$AttackTimer.wait_time = enemyAttackCooldown
	# Final boss instantly locks on to the player
	player = get_tree().get_nodes_in_group("Player")
	preyWithinDetectionRange.append(player[0])
	behaviorState = state.POSE
	bigRoar()

func bigRoar():
	#$AnimatedSprite2D/AnimationPlayer.play("spawn")
	$AnimatedSprite2D.play("roar")
	await $AnimatedSprite2D.animation_finished
	$RoarSound.play()
	$AnimatedSprite2D.play_backwards("roar")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("default")
	behaviorState = state.HUNT

func _on_detectionrange_body_entered(_body):
	pass

func _on_detectionrange_body_exited(_body):
	pass

func _on_hunt_timer_timeout():
	pass

func takeDamage(damage, source, crit):
	if behaviorState == state.POSE:
		return
	if crit:
		$Path2D/PathFollow2D/WeakSpot.criticallyHit()

	if(behaviorState == state.HUNT):
		prefferedPrey = source
		setHuntTimer()
		
	
	enemyHP -= damage
		
	$HPBar.value = enemyHP
	$HPBar.show()
	if enemyHP <= 0:
		win()

func win():
	$Hurtbox.hide()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	behaviorState = state.POSE
	$RoarSound.play()
	$AnimatedSprite2D.pause()
	$AnimatedSprite2D/AnimationPlayer.play("death_flop")
	bossKilled.emit()

func chooseDirection(delta):
	old_direction = direction
	
	if behaviorState == state.POSE:
		animated_sprite.flip_h = false
		animated_sprite.position = Vector2(-9, -16)
		drop_shadow.position.x = 5
		return
	
	if behaviorState == state.HUNT:
		if(!preyWithinDetectionRange.is_empty() && preyWithinDetectionRange[0] != null):
			if(prefferedPrey != null):
				direction = (position + heightOffset).direction_to(prefferedPrey.position)
			else:
				direction = (position + heightOffset).direction_to(preyWithinDetectionRange[0].position)
		else:
			behaviorState = state.IDLE
	elif behaviorState == state.FLEE:
		if(!predatorsWithinDetectionRange.is_empty()):
			var largest_dino = null
			var largest_size = size.SMALL

			for predators in predatorsWithinDetectionRange:
				if predators.dinoSize > largest_size:
					largest_size = predators.dinoSize
					largest_dino = predators
				
			direction = -(position + heightOffset).direction_to(largest_dino.position)
		else:
			direction = -(position + heightOffset).direction_to(predator.position)
	elif behaviorState == state.EAT:
		direction = (position + heightOffset).direction_to(foodWithinDetectionRange[0].position)
	
	else:
		direction = direction.lerp(targetDirection, enemyRotationSpeed * delta).normalized()
		
	biteHurtbox.targetDirection = direction
	
	if(animated_sprite != null):
		if(direction.x > 0):
			animated_sprite.flip_h = true
			animated_sprite.position = Vector2(9, -16)
			drop_shadow.position.x = -1
		else:
			animated_sprite.flip_h = false
			animated_sprite.position = Vector2(-9, -16)
			drop_shadow.position.x = 5

func _on_attack_timer_timeout():
	if !enemiesWithinBiteRange.is_empty() and behaviorState != state.POSE:
		# Reset the Hunt Timer if the dino successfully bites something
		if !hunt_timer.is_stopped():
			hunt_timer.wait_time = hunt_time
		# Enemies cannot crit
		var crit = false
		enemiesWithinBiteRange[0].takeDamage(enemyStrength, self, crit)
		if(isPlayerWithinAudioRange):
			bite_sound.play()
