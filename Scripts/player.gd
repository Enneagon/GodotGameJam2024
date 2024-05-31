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
@onready var ability1Timer = $Ability1Timer
@onready var ability2Timer = $Ability2Timer
@onready var ability3Timer = $Ability3Timer
var animated_sprite
@onready var bite_effect = $BiteEffect

@onready var camera = $Camera2D

@onready var footstep_player = $FootstepPlayer

var footstep_sounds = [
	load("res://Assets/Audio/SFX/Small Steps/Small_Step_1.mp3"),
	load("res://Assets/Audio/SFX/Small Steps/Small_Step_2.mp3"),
	load("res://Assets/Audio/SFX/Small Steps/Small_Step_3.mp3"),
	load("res://Assets/Audio/SFX/Small Steps/Small_Step_4.mp3")
]

# Define screen shake properties
var shake_duration = 0.25
var shake_timer = 0.0
var shake_intensity = 5.0

var sprint_speed
var normal_speed
var speed
var isPlayer = true
var apexDash = false
var bossSpawned = false

const SPIT = preload("res://Scenes/spit_blob.tscn")

signal dinoSpriteChoice(animated_sprite)
signal bellyFull
signal skillUsedBite(resetTime)
signal ability1Used(resetTime)
signal ability2Used(resetTime)
signal ability3Used(resetTime)

func start_shake(duration, intensity):
	if(GlobalVars.isScreenshakeEnabled):
		shake_duration = duration
		shake_intensity = intensity
		shake_timer = shake_duration

func _ready():
	$"../../CanvasLayer/GameplayInterface".roundStarted.connect(_roundStart)
	$"../../CanvasLayer/GameplayInterface/AbilitiesPopup".abilityChosen.connect(gainAbility)
	$Camera2D.limit_top = -GlobalVars.worldHeight/2
	$Camera2D.limit_bottom = GlobalVars.worldHeight/2
	$Camera2D.limit_left = -GlobalVars.worldWidth/2
	$Camera2D.limit_right = GlobalVars.worldWidth/2
	biteTimer.wait_time = GlobalVars.playerAttackSpeed
	var dinoManager = get_tree().get_nodes_in_group("DinoManager")
	dinoManager[0].bossSpawned.connect(lookAtBoss)
	setPlayerSpeed()
	gainAbilityRelatedStats()

func _process(delta):
	checkForNullInArray()
	if Input.is_action_pressed("ability_1") and ability1Timer.is_stopped():
		if GlobalVars.abilitySpit:
			ability1Timer.wait_time = GlobalVars.ABILITY_SPIT_SPITCOOLDOWN
			ability1Timer.start()
			ability1Used.emit(GlobalVars.ABILITY_SPIT_SPITCOOLDOWN)
			makeSpit()
	if Input.is_action_pressed("ability_2") and ability2Timer.is_stopped():
		if GlobalVars.abilityTailWhip:
			ability2Timer.wait_time = GlobalVars.ABILITY_TAILWHIP_COOLDOWN
			ability2Timer.start()
			ability2Used.emit(GlobalVars.ABILITY_TAILWHIP_COOLDOWN)
		elif GlobalVars.abilityGroundSlam:
			ability2Timer.wait_time = GlobalVars.ABILITY_GROUNDSLAM_COOLDOWN
			ability2Timer.start()
			ability2Used.emit(GlobalVars.ABILITY_GROUNDSLAM_COOLDOWN)
	if Input.is_action_pressed("ability_3") and ability3Timer.is_stopped():
		if GlobalVars.abilityApexPredator:
			ability3Used.emit(GlobalVars.ABILITY_APEXDASH_COOLDOWN)
			ability3Timer.wait_time = GlobalVars.ABILITY_APEXDASH_COOLDOWN
			ability3Timer.start()
			apexDashStart()
		elif GlobalVars.abilityHeadbutt:
			ability3Timer.wait_time = GlobalVars.ABILITY_HEADBUTT_COOLDOWN
			ability3Timer.start()
			ability3Used.emit(GlobalVars.ABILITY_HEADBUTT_COOLDOWN)
	
	if shake_timer > 0:
		shake_timer -= delta
		$Camera2D.offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
	else:
		$Camera2D.offset = Vector2(0, 0)  # Reset the camera offset when not shaking
	

func _roundStart(dinoChoice):
	match dinoChoice:
		1:
			camera.zoom = Vector2(3.5,3.5)
			print("EORAPTOR!!")
			animated_sprite = $EoraptorSprite
			$EoraptorSprite.show()
		2:
			camera.zoom = Vector2(2.5,2.5)
			GlobalVars.playerHPMax = 16.0
			GlobalVars.playerStrength = 2.5
			dinoSize = size.MEDIUM
			GlobalVars.playerSize = size.MEDIUM
			animated_sprite = $GuanlongSprite
			$GuanlongSprite.show()
		3:
			camera.zoom = Vector2(3,3)
			GlobalVars.playerHPMax = 12.0
			GlobalVars.playerSpeed = 80.0
			animated_sprite = $CoelurusSprite
			$CoelurusSprite.show()
		4:
			camera.zoom = Vector2(1.5,1.5)
			GlobalVars.playerHPMax = 25.0
			GlobalVars.playerStrength = 4.0
			dinoSize = size.LARGE
			GlobalVars.playerSize = size.LARGE
			animated_sprite = $TRexSprite
			$TRexSprite.show()
		5:
			camera.zoom = Vector2(2.5,2.5)
			GlobalVars.playerHPMax = 20.0
			GlobalVars.playerStrength = 3.0
			GlobalVars.playerSpeed = 80.0
			dinoSize = size.MEDIUM
			GlobalVars.playerSize = size.MEDIUM
			animated_sprite = $VelociraptorSprite
			$VelociraptorSprite.show()
		6:
			camera.zoom = Vector2(3,3)
			GlobalVars.playerHPMax = 18.0
			GlobalVars.playerSpeed = 100.0
			animated_sprite = $ArchaeopteryxSprite
			$ArchaeopteryxSprite.show()
	print("Camera zoom = " + str(camera.zoom))
	dinoSpriteChoice.emit(animated_sprite)
	GlobalVars.playerHP = GlobalVars.playerHPMax
	GlobalVars.playerSprintEnergy = GlobalVars.playerSprintEnergyMax
	setPlayerSpeed()
	GlobalVars.playerType = dinoChoice
	GlobalVars.hungerPoints = 0

func gainAbility(abilityGained):
	match abilityGained:
		1:
			GlobalVars.abilityPredator = true
		2:
			GlobalVars.abilityScavenger = true
		3:
			GlobalVars.abilitySpit = true
		4:
			GlobalVars.abilityTailWhip = true
		5:
			GlobalVars.abilityAggressor = true
		6:
			GlobalVars.abilityGroundSlam = true
		7:
			GlobalVars.abilityInfectiousBite = true
		8:
			GlobalVars.abilityApexPredator = true
		9:
			GlobalVars.abilityHeadbutt = true
	gainAbilityRelatedStats()

func gainAbilityRelatedStats():
	if GlobalVars.abilityScavenger:
		GlobalVars.playerSprintEnergyMax = GlobalVars.playerSprintEnergyMax * GlobalVars.ABILITY_SCAVENGER_SPEED_MULTIPLIER
	elif GlobalVars.abilitySpit:
		ability1Timer.wait_time = GlobalVars.ABILITY_SPIT_SPITCOOLDOWN
	if GlobalVars.abilityTailWhip:
		ability2Timer.wait_time = GlobalVars.ABILITY_TAILWHIP_COOLDOWN
	elif GlobalVars.abilityAggressor:
		$BiteHurtbox.scale = $BiteHurtbox.scale * GlobalVars.ABILITY_AGGRESSOR_HURTBOX_SCALE_MULTIPLIER
		$BiteHurtbox.attackRange = GlobalVars.playerAttackRange + GlobalVars.ABILITY_AGGRESSOR_HURTBOX_RANGE_EXTENSION
	elif GlobalVars.abilityGroundSlam:
		ability2Timer.wait_time = GlobalVars.ABILITY_GROUNDSLAM_COOLDOWN

func setPlayerSpeed():
	if GlobalVars.abilityScavenger:
		sprint_speed = GlobalVars.playerSpeed * GlobalVars.playerSprintSpeedMultiplier * GlobalVars.ABILITY_SCAVENGER_SPEED_MULTIPLIER
		normal_speed = GlobalVars.playerSpeed * GlobalVars.ABILITY_SCAVENGER_SPEED_MULTIPLIER
		speed = GlobalVars.playerSpeed * GlobalVars.ABILITY_SCAVENGER_SPEED_MULTIPLIER
	else:
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

	
	if apexDash == true:
		velocity = direction.normalized() * GlobalVars.ABILITY_APEXDASH_SPEED
	else:
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
		GlobalVars.playerSprintEnergy += 12 * delta  # Recover energy

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
		var targetedEnemy2 = null
		if GlobalVars.abilityAggressor and enemiesWithinBiteRange.size() > 1:
			targetedEnemy2 = enemiesWithinBiteRange[1]
		var crit = false
		
		if $BiteHurtbox.weakSpotInRange == true:
			damage = damage * GlobalVars.CRITICAL_DAMAGE_MULTIPLIER
			crit = true
			$Crit_Audio.play()
		if GlobalVars.abilityPredator == true:
			damage = damage * GlobalVars.ABILITY_PREDATOR_DAMAGE_MULTIPLIER
		#if(targetedEnemy.dinoSize > self.dinoSize):
		#	damage = damage * GlobalVars.DAMAGE_REDUCTION_MULTIPLIER
		#elif (targetedEnemy.dinoSize < self.dinoSize):
		#	damage = damage * GlobalVars.DAMAGE_INCREASE_MULTIPLIER
			
		bite_effect.visible = true
		bite_effect.play("bite")
		
		var target_direction = (targetedEnemy.global_position - self.global_position).normalized()
		var target_position = target_direction * 25
		bite_effect.position = target_position
		
		targetedEnemy.takeDamage(damage, self, crit)
		if GlobalVars.abilityInfectiousBite:
			targetedEnemy.getPoisoned()
		if targetedEnemy2:
			targetedEnemy2.takeDamage(damage, self, crit)
			if GlobalVars.abilityInfectiousBite:
				targetedEnemy2.getPoisoned()
		biteTimer.start()
		skillUsedBite.emit(GlobalVars.playerAttackSpeed)
		$PlaceholderMunch.play()

func enemy_killed(enemy):
	# Enemy has been killed so remove it from enemies within range
	remove_enemy_from_enemies_within_range(enemy)


func eat_food():
	GlobalVars.playerHP += 0.15
	if GlobalVars.playerHP > GlobalVars.playerHPMax:
		GlobalVars.playerHP = GlobalVars.playerHPMax
	GlobalVars.hungerPoints += 1
	if GlobalVars.hungerPoints >= GlobalVars.hungerPointsMax and bossSpawned == false:
		bellyFull.emit()
		bossSpawned = true

func takeDamage(damage, enemy, _crit):
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


func _on_bite_effect_animation_finished():
	bite_effect.visible = false
	bite_effect.play("default")


func makeSpit():
	var spit = SPIT.instantiate()
	$Spit_Audio.play()
	spit.global_position = $BiteHurtbox.global_position
	spit.rotation = $AngleVisualizer.rotation
	spit.spitOwner = self
	get_parent().call_deferred("add_child", spit)

func apexDashStart():
	apexDash = true
	$ApexDashTimer.wait_time = GlobalVars.ABILITY_APEXDASH_TIME
	$ApexDashTimer.start()
	$CollisionShape2D.disabled = true


func _on_foot_step_timer_timeout():
	if not velocity.is_zero_approx():
		var sound = footstep_sounds[randi() % footstep_sounds.size()]
		footstep_player.stream = sound
		footstep_player.play() # Replace with function body.


func _on_apex_dash_timer_timeout():
	apexDash = false
	$CollisionShape2D.disabled = false

func lookAtBoss(bossPos):
	$Camera2D.global_position = bossPos.position
	$FinaleCutsceneTimer.start()


func _on_finale_cutscene_timer_timeout():
	$Camera2D.global_position = position
