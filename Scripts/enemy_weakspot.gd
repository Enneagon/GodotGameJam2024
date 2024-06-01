extends Area2D

var weakspotDistance = 10.0
var direction = Vector2.LEFT
var respawnTime = 1.5

@onready var respawnTimer = $RespawnTimer

func _ready():
	respawnTimer.wait_time = respawnTime
	if get_parent().get_parent().get_parent().dinoSize <= GlobalVars.playerSize:
		hide()
		process_mode = Node.PROCESS_MODE_DISABLED
	randomizePosition()

func criticallyHit():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	respawnTimer.start()

func randomizePosition():
	get_parent().progress_ratio = randf()


func _on_respawn_timer_timeout():
	randomizePosition()
	$CollisionShape2D.disabled = false
	show()
