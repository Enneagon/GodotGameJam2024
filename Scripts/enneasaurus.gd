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

func flipSprite():
	pass
