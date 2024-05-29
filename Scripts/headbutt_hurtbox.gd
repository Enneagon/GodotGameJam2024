extends Area2D

@onready var frontShape = $FrontShape

func _ready():
	get_parent().ability3Used.connect(headbuttUsed)

func _process(_delta):
	var target_position = self.get_parent().position
	var direction = (get_global_mouse_position() - target_position).normalized()
	frontShape.position = direction * GlobalVars.playerAttackRange

func headbuttUsed(_time):
	if GlobalVars.abilityHeadbutt:
		print("Headbutt used!")
		var damage = GlobalVars.playerStrength
		var targets = get_overlapping_bodies()
		for target in targets:
			if target.is_in_group("Enemy"):
				target.takeDamage(damage, get_parent(), false)
				target.getSlowed(GlobalVars.ABILITY_HEADBUTT_SLOW_AMOUNT, GlobalVars.ABILITY_HEADBUTT_SLOW_TIME)
