class_name Enemy extends CharacterBody2D

#Functions similarly to the player attack script, but with a check for relative size
var enemiesWithinBiteRange = []

var preyWithinDetectionRange = []
var predatorsWithinDetectionRange = []
var foodWithinDetectionRange = []

@onready var biteHurtbox = $Hurtbox
@onready var stateLabel = $State
@onready var flee_timer = $FleeTimer
@onready var hunt_timer = $HuntTimer
var hunt_time = 8.0
var flee = false
var outOfBounds = false
var prefferedPrey
var isPlayer = false
var isPlayerWithinAudioRange = false

@onready var bite_sound = $BiteSound

@onready var drop_shadow = $DropShadow
@onready var animated_sprite = $AnimatedSprite2D


@export var debug = false
@export var enemyName = "an unnamed dinosaur"
@export var enemyNameShort = "Dinosaur"
@export var dinoSize = size.SMALL
@export var enemyMaxSpeed = 30.0
@export var enemyAcceleration = 5.0; 
@export var enemyBaseSpeed = 20.0
@export var enemySpeed = 20.0
@export var enemyRotationSpeed = 0.5
@export var enemyStrength = 1.0
var speedEffectMultiplier = 1.0
var slowdownAmount
var poisonAmount = 0
var poisonHealTime = 5

var enemyHP
@export var enemyHPMax = 1.0
@export var enemyAttackCooldown = 1.0
@export var enemyRangeMultiplier = 1.0
var old_direction = Vector2.ZERO
var direction = Vector2.ZERO
var targetDirection = Vector2.ZERO

var behaviorState = state.IDLE
var predator

@onready var footstep_player = $FootstepPlayer

var small_footstep_sounds = [
	load("res://Assets/Audio/SFX/Small Steps/Small_Step_1.mp3"),
	load("res://Assets/Audio/SFX/Small Steps/Small_Step_2.mp3"),
	load("res://Assets/Audio/SFX/Small Steps/Small_Step_3.mp3"),
	load("res://Assets/Audio/SFX/Small Steps/Small_Step_4.mp3")
]

var med_footstep_sounds = [
	load("res://Assets/Audio/SFX/Medium Steps/Medium_Step_1.mp3"),
	load("res://Assets/Audio/SFX/Medium Steps/Medium_Step_2.mp3"),
	load("res://Assets/Audio/SFX/Medium Steps/Medium_Step_3.mp3"),
]

var lrg_footstep_sounds = [
	load("res://Assets/Audio/SFX/Large Steps/Big_Step 1.mp3"),
	load("res://Assets/Audio/SFX/Large Steps/Big_Step 2.mp3"),
	load("res://Assets/Audio/SFX/Large Steps/Big_Step_3.mp3"),
]

enum state
{
	IDLE,
	FLEE,
	HUNT,
	EAT
}

enum size
{
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3,
	GARGANTUAN = 4
}

const FOOD = preload("res://Scenes/food.tscn")

func _ready():
	# Enemy names, just for fun until we get art.
	$Name.text = enemyNameShort
	enemyHP = enemyHPMax
	$HPBar.max_value = enemyHPMax
	$HPBar.value = enemyHP
	$HPBar.hide()
	$AttackTimer.wait_time = enemyAttackCooldown
	# Set an initial, random vector for the dino.
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	direction = direction.normalized()
	targetDirection = direction
	# if the enemy is smaller than the player, hide the hurtbox from the player
	if dinoSize < GlobalVars.playerSize:
		biteHurtbox.hide()
	_on_direction_timer_timeout()

func _process(_delta):
	checkForNullInArray()
	checkForOutOfBounds()

func _physics_process(delta):
	chooseState()
	setHuntTimer()
	chooseDirection(delta)
	bounceOffWalls(delta)
	
	var differenceInDirections = rad_to_deg(old_direction.angle_to(direction))
	
	
	if(behaviorState == state.HUNT || behaviorState == state.EAT):
		if(abs(differenceInDirections) > 0.3 && enemySpeed > enemyBaseSpeed):
			enemySpeed -= enemyAcceleration * 2 * delta
		elif(enemySpeed < enemyMaxSpeed * speedEffectMultiplier):
			enemySpeed += enemyAcceleration * delta
	elif(behaviorState == state.FLEE):
		if(abs(differenceInDirections) > 0.6 && enemySpeed > enemyBaseSpeed):
			enemySpeed -= enemyAcceleration * 0.5 * delta
		elif(enemySpeed < enemyMaxSpeed * speedEffectMultiplier):
			enemySpeed += enemyAcceleration * 2 * delta
	else:
		enemySpeed = enemyBaseSpeed * speedEffectMultiplier
	
	velocity = direction * enemySpeed
	move_and_slide()

func _on_direction_timer_timeout():
	if behaviorState == state.IDLE:
		targetDirection = Vector2.RIGHT.rotated(direction.angle() + deg_to_rad(randf_range(-120, 120)))
		$DirectionTimer.wait_time = 2 + randf_range(0, 2)


func chooseDirection(delta):
	old_direction = direction
	
	if behaviorState == state.HUNT:
		if(!preyWithinDetectionRange.is_empty() && preyWithinDetectionRange[0] != null):
			if(prefferedPrey != null):
				direction = position.direction_to(prefferedPrey.position)
			else:
				direction = position.direction_to(preyWithinDetectionRange[0].position)
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
				
			direction = -position.direction_to(largest_dino.position)
		else:
			direction = -position.direction_to(predator.position)
	elif behaviorState == state.EAT:
		direction = position.direction_to(foodWithinDetectionRange[0].position)
	
	else:
		direction = direction.lerp(targetDirection, enemyRotationSpeed * delta).normalized()
		
	biteHurtbox.targetDirection = direction
	
	if(animated_sprite != null):
		if(direction.x > 0):
			animated_sprite.flip_h = true
			drop_shadow.position.x = -1
		else:
			animated_sprite.flip_h = false
			drop_shadow.position.x = 5


func bounceOffWalls(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		targetDirection = collision_info.get_normal()


func eat_food():
	pass

func takeDamage(damage, source, crit):
	
	if crit:
		$Path2D/PathFollow2D/WeakSpot.criticallyHit()

	if(behaviorState == state.HUNT):
		prefferedPrey = source
		setHuntTimer()
		
	
	enemyHP -= damage
	if source != null:
		if(source.dinoSize > dinoSize):
			Flee(source)
		elif (source.dinoSize < dinoSize && enemyHP < (enemyHPMax / 8)):
			Flee(source)
		elif(source.dinoSize == dinoSize && !source.isPlayer && enemyHP < (enemyHPMax * 0.8)):
			Flee(source)
		elif(source.dinoSize == dinoSize && source.isPlayer && enemyHP < (enemyHPMax * 0.3)):
			Flee(source)
		
	$HPBar.value = enemyHP
	$HPBar.show()
	if enemyHP <= 0:
		die(source)

func die(source):
	# Notify killer script that this enemy has been killed
	if source != null:
		source.enemy_killed(self)
	instantiate_food()
	queue_free()
	
func Flee(source):
	flee_timer.start()
	flee = true
	predator = source
	
func instantiate_food():
	var numFood = 1
	if(dinoSize == size.SMALL):
		numFood = 1
	elif(dinoSize == size.MEDIUM):
		numFood = 6
	elif(dinoSize == size.LARGE):
		numFood = 12
	elif(dinoSize == size.GARGANTUAN):
		numFood = 20

	for i in range(numFood):
		var food = FOOD.instantiate()
		food.position = position
		get_tree().root.call_deferred("add_child", food)

		# Set the food's velocity to make it fly off in a direction.
		var angle = i * 2 * PI / numFood  # Divide the circle into equal parts.
		var random_angle = randf_range(-PI/8, PI/8)  # Add a random angle between -22.5 and 22.5 degrees.
		angle += random_angle
		var foodDirection = Vector2(cos(angle), sin(angle))  # Calculate the direction vector.
		food.velocity = foodDirection * 20  # Set the velocity. The food will move 2 units per second.

func enemy_killed(enemy):
	# Enemy has been killed so remove it from enemies within range
	remove_enemy_from_enemies_within_range(enemy)


func _on_hurtbox_body_entered(body):
	if body.is_in_group("Enemy"):
		if body.dinoSize < dinoSize && body != self:
			enemiesWithinBiteRange.append(body)
	if body.is_in_group("Player"):
		if body.dinoSize <= dinoSize:
			enemiesWithinBiteRange.append(body)


func _on_hurtbox_body_exited(body):
	remove_enemy_from_enemies_within_range(body)


func remove_enemy_from_enemies_within_range(body):
	if body.is_in_group("Enemy") || body.is_in_group("Player"):
		enemiesWithinBiteRange.erase(body)


func _on_attack_timer_timeout():
	if !enemiesWithinBiteRange.is_empty():
		# Reset the Hunt Timer if the dino successfully bites something
		if !hunt_timer.is_stopped():
			hunt_timer.wait_time = hunt_time
		# Enemies cannot crit
		var crit = false
		enemiesWithinBiteRange[0].takeDamage(enemyStrength, self, crit)
		if(isPlayerWithinAudioRange):
			bite_sound.play()


func _on_detectionrange_body_entered(body):
	if body.is_in_group("Enemy") || body.is_in_group("Player"):
		if(body.is_in_group("Player")):
			isPlayerWithinAudioRange = true;
		
		if body.dinoSize > dinoSize:
			predatorsWithinDetectionRange.append(body)
		elif body.dinoSize < dinoSize:
			preyWithinDetectionRange.append(body)
		elif body.dinoSize == dinoSize && body.is_in_group("Player"):
			preyWithinDetectionRange.append(body)
	elif body.is_in_group("Food"):
		foodWithinDetectionRange.append(body)
		
	
		


func _on_detectionrange_body_exited(body):
	if body.is_in_group("Enemy") || body.is_in_group("Player"):
		if(body.is_in_group("Player")):
			isPlayerWithinAudioRange = false;
		
		if body.dinoSize > dinoSize:
			predatorsWithinDetectionRange.erase(body)
		elif body.dinoSize < dinoSize:
			preyWithinDetectionRange.erase(body)
	elif body.is_in_group("Food"):
		foodWithinDetectionRange.erase(body)
	
	


func chooseState():
	if !predatorsWithinDetectionRange.is_empty():
		behaviorState = state.FLEE
		stateLabel.text = "FLEE"
	elif flee && predator != null:
		behaviorState = state.FLEE
		stateLabel.text = "FLEE"
	elif !foodWithinDetectionRange.is_empty():
		behaviorState = state.EAT
		stateLabel.text = "EAT"
	elif !preyWithinDetectionRange.is_empty():
		behaviorState = state.HUNT
		stateLabel.text = "HUNT"
	else:
		behaviorState = state.IDLE
		stateLabel.text = "IDLE"

func setHuntTimer():
	if behaviorState == state.HUNT:
		if hunt_timer.is_stopped():
			hunt_timer.wait_time = hunt_time
			hunt_timer.start()
	else:
		hunt_timer.stop()

func checkForOutOfBounds():
	if position.x < (-GlobalVars.worldWidth/2) or position.x > (GlobalVars.worldWidth/2) or position.y < (-GlobalVars.worldHeight/2) or position.y > (GlobalVars.worldHeight/2):
		outOfBounds = true
	if $OutOfBoundsTimer.is_stopped() and outOfBounds == true:
		$OutOfBoundsTimer.start()


func checkForNullInArray():
	# Failsafe system that removes null references. I hope.
	if !enemiesWithinBiteRange.is_empty():
		for body in enemiesWithinBiteRange:
			if body == null:
				enemiesWithinBiteRange.erase(body)
	if !predatorsWithinDetectionRange.is_empty():
		for body in predatorsWithinDetectionRange:
			if body == null:
				predatorsWithinDetectionRange.erase(body)
	if !preyWithinDetectionRange.is_empty():
		for body in preyWithinDetectionRange:
			if body == null:
				preyWithinDetectionRange.erase(body)
	if !foodWithinDetectionRange.is_empty():
		for body in foodWithinDetectionRange:
			if body == null:
				foodWithinDetectionRange.erase(body)


func _on_flee_timer_timeout():
	#flee = false
	pass


func _on_out_of_bounds_timer_timeout():
	if outOfBounds == true:
		print("Removed OOB dino")
		queue_free()


func _on_hunt_timer_timeout():
	# If this much time has passed and the dino hasn't caught its prey, chase something else instead
	if behaviorState == state.HUNT:
		preyWithinDetectionRange.shuffle()
		prefferedPrey = null
		print("Couldn't catch prey...")

func getSlowed(slowAmount, slowTime):
	$SlowTimer.wait_time = slowTime
	slowdownAmount = slowAmount
	speedEffectMultiplier = speedEffectMultiplier * slowAmount
	
	$SlowTimer.start()

func _on_slow_timer_timeout():
	speedEffectMultiplier = speedEffectMultiplier / slowdownAmount

func getPoisoned():
	if poisonAmount <= GlobalVars.ABILITY_INFECTIOUSBITE_POISON_MAX_STACKS:
		poisonAmount += 1
	$HPBar.tint_progress = Color.ORANGE
	poisonHealTime = GlobalVars.ABILITY_INFECTIOUSBITE_POISON_DURATION
	$PoisonTimer.wait_time = GlobalVars.ABILITY_INFECTIOUSBITE_POISON_FREQUENCY
	$PoisonTimer.start()

func _on_poison_timer_timeout():
	takeDamage(GlobalVars.ABILITY_INFECTIOUSBITE_POISON_DAMAGE * poisonAmount, null, false)
	poisonHealTime -= 1
	if poisonHealTime == 0:
		poisonAmount = 0
		$HPBar.tint_progress = Color(0.0, 0.61, 0.0, 1.0)
		$PoisonTimer.stop()

func _on_foot_step_timer_timeout():
	if(isPlayerWithinAudioRange):
		print("Player in audio range for " + name)
		var sound
		if(dinoSize == size.SMALL):
			sound = small_footstep_sounds[randi() % small_footstep_sounds.size()]
		elif(dinoSize == size.MEDIUM):
			sound = med_footstep_sounds[randi() % med_footstep_sounds.size()]
		else:
			sound = lrg_footstep_sounds[randi() % lrg_footstep_sounds.size()]
		print("playing footstep for " + name)
		footstep_player.stream = sound
		footstep_player.play() # Replace with function body.
