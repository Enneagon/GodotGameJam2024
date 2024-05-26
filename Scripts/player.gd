extends CharacterBody2D

# Using a biteArray to deal with multiple enemies at a time.
# If two enemies are in the Bite hurtbox, whenever the timer runs down it will attack only the first enemy.
# It also keeps track of enemies inside the hurtbox, instead of enemies having to exit and then enter the hurtbox again to be recognized.
var enemiesWithinBiteRange = []
var dinoSize = size.SMALL

enum size
{
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3,
	GARGANTUAN = 4
}

var sprint_speed = GlobalVars.playerSpeed * GlobalVars.playerSprintSpeedMultiplier
var normal_speed = GlobalVars.playerSpeed
var speed = GlobalVars.playerSpeed


signal sizeUpPopup

func _ready():
	$BiteTimer.wait_time = GlobalVars.playerAttackSpeed

func _process(_delta):
	checkForNullInArray()
	

func stop_sprinting():
	speed = normal_speed
	
func start_sprinting():
	speed = sprint_speed

func _physics_process(delta):
	if Input.is_action_pressed("sprint") && GlobalVars.playerSprintEnergy > 0:
		start_sprinting()
	else:
		stop_sprinting()
	
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += Input.get_action_strength("move_right")
	if Input.is_action_pressed("move_left"):
		direction.x -= Input.get_action_strength("move_left")
	if Input.is_action_pressed("move_up"):
		direction.y -= Input.get_action_strength("move_up")
	if Input.is_action_pressed("move_down"):
		direction.y += Input.get_action_strength("move_down")

	velocity = direction.normalized() * speed
	handle_sprinting(delta)
	move_and_collide(velocity * delta)

func handle_sprinting(delta):
	if speed == sprint_speed:
		GlobalVars.playerSprintEnergy -= 20 * delta  # Decrease energy
		if GlobalVars.playerSprintEnergy < 0:
			GlobalVars.playerSprintEnergy = 0
			stop_sprinting()  # Stop sprinting when out of energy.
	elif GlobalVars.playerSprintEnergy < GlobalVars.playerSprintEnergyMax:
		GlobalVars.playerSprintEnergy += 8 * delta  # Recover energy

#func update_energy_bar():
	# update energy bar

func _on_hurtbox_body_entered(body):
	if body.is_in_group("Enemy"):
		enemiesWithinBiteRange.append(body)

func _on_hurtbox_body_exited(body):
	remove_enemy_from_enemies_within_range(body)

func remove_enemy_from_enemies_within_range(body):
	if body.is_in_group("Enemy"):
		enemiesWithinBiteRange.erase(body)

func _on_bite_timer_timeout():
	if !enemiesWithinBiteRange.is_empty():
		var damage = GlobalVars.playerStrength
		var targetedEnemy = enemiesWithinBiteRange[0]
		if(targetedEnemy.dinoSize > self.dinoSize):
			damage = damage * GlobalVars.DAMAGE_REDUCTION_MULTIPLIER
		elif (targetedEnemy.dinoSize < self.dinoSize):
			damage = damage * GlobalVars.DAMAGE_INCREASE_MULTIPLIER
			
		enemiesWithinBiteRange[0].takeDamage(damage, self)
		$PlaceholderMunch.play()

func enemy_killed(enemy):
	# Enemy has been killed so remove it from enemies within range
	remove_enemy_from_enemies_within_range(enemy)
	


func eat_food():
	GlobalVars.playerHP += 1
	if GlobalVars.playerHP > GlobalVars.playerHPMax:
		GlobalVars.playerHP = GlobalVars.playerHPMax
	GlobalVars.evoPoints += 1
	if dinoSize < 4:
		GlobalVars.hungerPoints += 1
		
	if GlobalVars.hungerPoints >= GlobalVars.hungerPointsMax:
		sizeUp()

func takeDamage(damage, enemy):
	GlobalVars.playerHP -= damage
	if GlobalVars.playerHP <= 0:
		die(enemy)

func die(enemy):
	GlobalVars.killedBy = enemy.enemyName
	get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")

func sizeUp():
	GlobalVars.playerSize += 1
	scale += Vector2(1, 1)
	GlobalVars.playerStrength += 2
	GlobalVars.hungerPoints = 0
	GlobalVars.hungerPointsMax += 25
	# Spawns a popup in the gameplay interface that pauses the game and lets the player buy upgrades.
	sizeUpPopup.emit()

func checkForNullInArray():
	# Failsafe system that removes null references. I hope.
	if !enemiesWithinBiteRange.is_empty():
		for body in enemiesWithinBiteRange:
			if body == null:
				enemiesWithinBiteRange.erase(body)
