extends Area2D

func _ready():
	get_parent().ability2Used.connect(groundslamUsed)

func _process(_delta):
	$FrontShape.position = $"../BiteHurtbox".visualOffset

func groundslamUsed(_time):
	if GlobalVars.abilityGroundSlam:
		print("Ground Slam used!")
		var damage = GlobalVars.playerStrength
		var targets = get_overlapping_bodies()
		for target in targets:
			if target.is_in_group("Enemy"):
				target.takeDamage(damage, get_parent(), false)
				target.getSlowed(GlobalVars.ABILITY_GROUNDSLAM_SLOW_AMOUNT, GlobalVars.ABILITY_GROUNDSLAM_SLOW_TIME)
