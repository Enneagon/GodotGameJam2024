extends CharacterBody2D

@export var enemySize = 1
var enemySpeed = 20.0
var enemyStrength = 1.0
var enemyHP = 3.0
var randomDir = Vector2.ZERO

func _ready():
	# if the enemy is smaller than the player, remove the hurtbox component
	# ::: This will prevent this enemy from being able to attack other enemies. 
	# ToDo: Modify the hurtbox code so that it checks when a body enters it whether or not the entering body is 
	# smaller or larger than the hurtbox owner, then do logic accordingly. 
	if enemySize < GlobalVars.playerSize:
		$Hurtbox.queue_free()
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


func takeDamage(damage):
	enemyHP -= damage
	if enemyHP <= 0:
		die()

func die():
	var player = get_tree().get_nodes_in_group("Player")
	player[0].enemy_killed(self)
	queue_free()
