extends Area2D

@onready var frontShape = $FrontShape
@onready var backShape = $BackShape

func _ready():
	get_parent().ability2Used.connect(tailwhipUsed)

func _process(_delta):
	var target_position = self.get_parent().position
	var direction = (get_global_mouse_position() - target_position).normalized()
	frontShape.position = direction * GlobalVars.playerAttackRange + $"../BiteHurtbox".visualOffset
	backShape.position = -direction * GlobalVars.playerAttackRange + $"../BiteHurtbox".visualOffset

func tailwhipUsed(_time):
	if GlobalVars.abilityTailWhip:
		print("Tail Whip used!")
		var damage = GlobalVars.playerStrength + GlobalVars.ABILITY_TAILWHIP_DAMAGE_BONUS
		var targets = get_overlapping_bodies()
		for target in targets:
			if target.is_in_group("Enemy"):
				target.takeDamage(damage, get_parent(), false)
