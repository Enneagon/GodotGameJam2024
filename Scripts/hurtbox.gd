extends Area2D

var attackRange = GlobalVars.playerAttackRange
var animated_sprite
var weakSpotInRange = false
@onready var bite_visual = $"../BiteVisual"
@onready var drop_shadow = $"../DropShadow"


func _ready():
	get_parent().dinoSpriteChoice.connect(chooseSprite)

func chooseSprite(dinoChoice):
	animated_sprite = dinoChoice

func _process(_delta):
	if animated_sprite != null:
		var target_position = self.get_parent().position
		var direction = (get_global_mouse_position() - target_position).normalized()
		position = direction * attackRange
		bite_visual.look_at(get_global_mouse_position())
		bite_visual.rotate(-1.65)
		if(direction.x < 0):
			animated_sprite.flip_h = false
			drop_shadow.position.x = 5
		else:
			animated_sprite.flip_h = true
			drop_shadow.position.x = -1

func _physics_process(_delta):
	weakSpotInRange = false
	for area in get_overlapping_areas():
		if area.is_in_group("WeakSpot"):
			weakSpotInRange = true
