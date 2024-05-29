extends CharacterBody2D

var spitOwner

func _ready():
	$DeathTimer.wait_time = GlobalVars.ABILITY_SPIT_SPITDURATION
	$DeathTimer.start()

func _process(_delta):
	velocity = -Vector2.from_angle(rotation - deg_to_rad(90)) * GlobalVars.ABILITY_SPIT_SPITSPEED
	move_and_slide()

func _on_body_entered(body):
	print(body, spitOwner)
	if (body.is_in_group("Player") or body.is_in_group("Enemy")) and body != spitOwner:
		var weakSpotHit = false
		var damage = GlobalVars.ABILITY_SPIT_SPITDAMAGE
		for area in $Area2D.get_overlapping_areas():
			if area.is_in_group("WeakSpot"):
				weakSpotHit = true
				damage = damage * GlobalVars.CRITICAL_DAMAGE_MULTIPLIER
		body.takeDamage(damage, spitOwner, weakSpotHit)
		queue_free()


func _on_death_timer_timeout():
	queue_free()
