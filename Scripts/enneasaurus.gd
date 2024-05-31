extends Enemy

func _ready():
	# Enemy names, just for fun until we get art.
	$Name.text = enemyNameShort
	enemyHP = enemyHPMax
	$HPBar.max_value = enemyHPMax
	$HPBar.value = enemyHP
	$HPBar.hide()
	$AttackTimer.wait_time = enemyAttackCooldown
	# Final boss instantly locks on to the player
	var player = get_tree().get_nodes_in_group("Player")
	preyWithinDetectionRange.append(player[0])
	behaviorState = state.HUNT

func _on_detectionrange_body_entered(_body):
	pass

func _on_detectionrange_body_exited(_body):
	pass

func _on_hunt_timer_timeout():
	pass

func takeDamage(damage, source, crit):
	
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
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
