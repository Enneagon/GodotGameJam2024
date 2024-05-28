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

@onready var biteTimer = $BiteTimer
var animated_sprite

var sprint_speed
var normal_speed
var speed

signal dinoSpriteChoice(animated_sprite)
signal bellyFull

func _ready():
	$"../CanvasLayer/GameplayInterface".roundStarted.connect(_roundStart)
	biteTimer.wait_time = GlobalVars.playerAttackSpeed
	setPlayerSpeed()

func _process(_delta):
	checkForNullInArray()

func _roundStart(dinoChoice):
	match dinoChoice:
		1:
			animated_sprite = $EoraptorSprite
			$EoraptorSprite.show()
		2:
			GlobalVars.playerHPMax = 16.0
			GlobalVars.playerStrength = 2.5
			dinoSize = size.MEDIUM
			scale = Vector2(2, 2)
			animated_sprite = $GuanlongSprite
			$GuanlongSprite.show()
		3:
			GlobalVars.playerHPMax = 12.0
			GlobalVars.playerSpeed = 80.0
			animated_sprite = $CoelurusSprite
			$CoelurusSprite.show()
		4:
			GlobalVars.playerHPMax = 25.0
			GlobalVars.playerStrength = 4.0
			dinoSize = size.LARGE
			scale = Vector2(4, 4)
			animated_sprite = $TRexSprite
			$TRexSprite.show()
		5:
			GlobalVars.playerHPMax = 20.0
			GlobalVars.playerStrength = 3.0
			GlobalVars.playerSpeed = 80.0
			dinoSize = size.MEDIUM
			scale = Vector2(2, 2)
			animated_sprite = $VelociraptorSprite
			$VelociraptorSprite.show()
		6:
			GlobalVars.playerHPMax = 18.0
			GlobalVars.playerSpeed = 100.0
			animated_sprite = $ArchaeopteryxSprite
			$ArchaeopteryxSprite.show()
	dinoSpriteChoice.emit(animated_sprite)
	GlobalVars.playerHP = GlobalVars.playerHPMax
	setPlayerSpeed()
	GlobalVars.playerType = dinoChoice
	GlobalVars.hungerPoints = 0

func setPlayerSpeed():
	sprint_speed = GlobalVars.playerSpeed * GlobalVars.playerSprintSpeedMultiplier
	normal_speed = GlobalVars.playerSpeed
	speed = GlobalVars.playerSpeed

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
	if animated_sprite:
		if velocity.is_zero_approx():
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
		
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
		if biteTimer.is_stopped():
			_on_bite_timer_timeout()

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
		biteTimer.start()
		$PlaceholderMunch.play()

func enemy_killed(enemy):
	# Enemy has been killed so remove it from enemies within range
	remove_enemy_from_enemies_within_range(enemy)


func eat_food():
	GlobalVars.playerHP += 1
	if GlobalVars.playerHP > GlobalVars.playerHPMax:
		GlobalVars.playerHP = GlobalVars.playerHPMax
	GlobalVars.hungerPoints += 1
	if GlobalVars.hungerPoints >= GlobalVars.hungerPointsMax:
		bellyFull.emit()

func takeDamage(damage, enemy):
	GlobalVars.playerHP -= damage
	if GlobalVars.playerHP <= 0:
		die(enemy)

func die(enemy):
	GlobalVars.killedBy = enemy.enemyName
	get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")

func checkForNullInArray():
	# Failsafe system that removes null references. I hope.
	if !enemiesWithinBiteRange.is_empty():
		for body in enemiesWithinBiteRange:
			if body == null:
				enemiesWithinBiteRange.erase(body)
