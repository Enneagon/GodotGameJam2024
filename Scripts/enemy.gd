class_name Enemy extends CharacterBody2D

#Functions similarly to the player attack script, but with a check for relative size
var enemiesWithinRange = []

@export var enemyName = "an unnamed dinosaur"
@export var enemySize = 1
@export var enemySpeed = 20.0
@export var enemyStrength = 1.0
var enemyHP
@export var enemyHPMax = 1.0
@export var enemyAttackSpeed = 1.0
@export var enemyRangeMultipler = 1.0
var randomDir = Vector2.ZERO



enum size
{
	SMALL,
	MEDIUM,
	LARGE,
	GARGANTUAN
}

const FOOD = preload("res://Scenes/food.tscn")

var dinoSize = size.SMALL

func _ready():
	enemyHP = enemyHPMax
	$HPBar.max_value = enemyHPMax
	$HPBar.value = enemyHP
	$HPBar.hide()
	$AttackTimer.wait_time = enemyAttackSpeed
	# if the enemy is smaller than the player, hide the hurtbox from the player
	if enemySize < GlobalVars.playerSize:
		$Hurtbox.hide()
	_on_direction_timer_timeout()

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	
	move_and_slide()

func _on_direction_timer_timeout():
	randomDir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	randomDir = randomDir.normalized()
	velocity = randomDir * enemySpeed

func eat_food():
	print("ate food")

func takeDamage(damage, source):
	enemyHP -= damage
	$HPBar.value = enemyHP
	$HPBar.show()
	if enemyHP <= 0:
		die(source)

func die(source):
	# Notify killer script that this enemy has been killed
	instantiate_food()
	source.enemy_killed(self)
	queue_free()

func instantiate_food():
	var numFood = 1
	if(dinoSize == size.SMALL):
		numFood = 2
	elif(dinoSize == size.MEDIUM):
		numFood = 4
	elif(dinoSize == size.LARGE):
		numFood = 8
	elif(dinoSize == size.GARGANTUAN):
		numFood = 15

	for i in range(numFood):
		var food = FOOD.instantiate()
		food.position = position
		get_tree().root.add_child(food)

		# Set the food's velocity to make it fly off in a direction.
		var angle = i * 2 * PI / numFood  # Divide the circle into equal parts.
		var random_angle = randf_range(-PI/8, PI/8)  # Add a random angle between -22.5 and 22.5 degrees.
		angle += random_angle
		var direction = Vector2(cos(angle), sin(angle))  # Calculate the direction vector.
		food.velocity = direction * 20  # Set the velocity. The food will move 2 units per second.

func enemy_killed(enemy):
	#Heal by nomming monsters!
	enemyHP += enemy.enemySize
	if enemyHP > enemyHPMax:
		enemyHP = enemyHPMax
	# Enemy has been killed so remove it from enemies within range
	remove_enemy_from_enemies_within_range(enemy)


func _on_hurtbox_body_entered(body):
	if body.is_in_group("Enemy"):
		if body.enemySize < enemySize:
			enemiesWithinRange.append(body)
	if body.is_in_group("Player"):
		if GlobalVars.playerSize <= enemySize:
			enemiesWithinRange.append(body)


func _on_hurtbox_body_exited(body):
	remove_enemy_from_enemies_within_range(body)


func remove_enemy_from_enemies_within_range(body):
	if body.is_in_group("Enemy") || body.is_in_group("Player"):
		enemiesWithinRange.erase(body)


func _on_attack_timer_timeout():
	if !enemiesWithinRange.is_empty():
		enemiesWithinRange[0].takeDamage(enemyStrength, self)
