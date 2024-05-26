extends CharacterBody2D

# Using a biteArray to deal with multiple enemies at a time.
# If two enemies are in the Bite hurtbox, whenever the timer runs down it will attack only the first enemy.
# It also keeps track of enemies inside the hurtbox, instead of enemies having to exit and then enter the hurtbox again to be recognized.
var enemiesWithinRange = []
var playerSize = size.SMALL

enum size
{
	SMALL,
	MEDIUM,
	LARGE,
	GARGANTUAN
}

signal sizeUpPopup

func _ready():
	$BiteTimer.wait_time = GlobalVars.playerAttackSpeed

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
		enemiesWithinRange[0].takeDamage(GlobalVars.playerStrength, self)
		$PlaceholderMunch.play()

func enemy_killed(enemy):
	#Enemy Size is currently used as a measure of value, but this can be configured for each dino.
	
	# Old size mechanics
	#GlobalVars.evoPoints += enemy.enemySize
	#if GlobalVars.playerSize < 3:
	#	GlobalVars.hungerPoints += enemy.enemySize
	
	#Heal by nomming monsters!
	GlobalVars.playerHP += enemy.enemySize
	if GlobalVars.playerHP > GlobalVars.playerHPMax:
		GlobalVars.playerHP = GlobalVars.playerHPMax
	# Enemy has been killed so remove it from enemies within range
	remove_enemy_from_enemies_within_range(enemy)
	
	#if GlobalVars.hungerPoints >= GlobalVars.hungerPointsMax:
	#	sizeUp()

func eat_food():
	print("ate food")

func takeDamage(damage, enemy):
	GlobalVars.playerHP -= damage
	if GlobalVars.playerHP <= 0:
		die(enemy)

func die(enemy):
	GlobalVars.killedBy = enemy.enemyName
	get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")

func is_bigger_than(other):
	return playerSize > other.dinoSize

func sizeUp():
	GlobalVars.playerSize += 1
	scale += Vector2(1, 1)
	GlobalVars.playerStrength += 2
	GlobalVars.hungerPoints = 0
	#GlobalVars.hungerPointsMax += 5
	#Spawns a popup in the gameplay interface that pauses the game and lets the player buy upgrades.
	sizeUpPopup.emit()
