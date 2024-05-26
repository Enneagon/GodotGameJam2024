extends CharacterBody2D

# Using a biteArray to deal with multiple enemies at a time.
# If two enemies are in the Bite hurtbox, whenever the timer runs down it will attack only the first enemy.
# It also keeps track of enemies inside the hurtbox, instead of enemies having to exit and then enter the hurtbox again to be recognized.
var enemiesWithinRange = []
var dinoSize = size.SMALL

enum size
{
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3,
	GARGANTUAN = 4
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
		var damage = GlobalVars.playerStrength
		var targetedEnemy = enemiesWithinRange[0]
		if(targetedEnemy.dinoSize > self.dinoSize):
			damage = damage * GlobalVars.DAMAGE_REDUCTION_MULTIPLIER
		elif (targetedEnemy.dinoSize < self.dinoSize):
			damage = damage * GlobalVars.DAMAGE_INCREASE_MULTIPLIER
			
		enemiesWithinRange[0].takeDamage(damage, self)
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
