extends Area2D

var weakspotDistance = 8.0
var direction = Vector2.LEFT
var respawnTime = 1.5

@onready var respawnTimer = $RespawnTimer

func _ready():
	respawnTimer.wait_time = respawnTime
	if get_parent().dinoSize <= GlobalVars.playerSize:
		queue_free()
	randomizePosition()

func criticallyHit():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	respawnTimer.start()

func randomizePosition():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	direction = direction.normalized()
	$CollisionShape2D.position = direction * weakspotDistance
	$Sprite2D.rotation = direction.angle() - deg_to_rad(90)


func _on_respawn_timer_timeout():
	randomizePosition()
	$CollisionShape2D.disabled = false
	show()
