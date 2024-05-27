extends Area2D

@export var baseEnemy = Enemy
@export var stompStrength = 1.0
var enemiesWithinStompRange = []

func _process(_delta):
	checkForNullInArray()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		if body.dinoSize < baseEnemy.dinoSize:
			enemiesWithinStompRange.append(body)
	if body.is_in_group("Player"):
		if body.dinoSize <= baseEnemy.dinoSize:
			enemiesWithinStompRange.append(body)


func _on_body_exited(body):
	remove_enemy_from_enemies_within_range(body)


func remove_enemy_from_enemies_within_range(body):
	if body.is_in_group("Enemy") || body.is_in_group("Player"):
		enemiesWithinStompRange.erase(body)

func checkForNullInArray():
	# Failsafe system that removes null references. I hope.
	if !enemiesWithinStompRange.is_empty():
		for body in enemiesWithinStompRange:
			if body == null:
				enemiesWithinStompRange.erase(body)

func _on_timer_timeout():
	if !enemiesWithinStompRange.is_empty():
		for enemy in enemiesWithinStompRange:
			enemy.takeDamage(stompStrength, self)
