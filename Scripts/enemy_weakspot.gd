extends Area2D

var weakspotDistance = 8.0
var direction = Vector2.LEFT
var respawnTime = 0.5

func _ready():
	if get_parent().dinoSize <= GlobalVars.playerSize:
		queue_free()
	randomizePosition()

func criticallyHit():
	hide()
	set_deferred("monitorable", false)
	$"../WeakSpot/RespawnTimer".start()

func randomizePosition():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	direction = direction.normalized()
	position = direction * weakspotDistance


func _on_respawn_timer_timeout():
	randomizePosition()
	monitorable = true
	show()
