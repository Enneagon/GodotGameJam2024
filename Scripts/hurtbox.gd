extends Area2D

var attackRange = GlobalVars.playerAttackRange
var animated_sprite
var weakSpotInRange = false
var visualOffset = 0.0

@onready var drop_shadow = $"../DropShadow"

enum size
{
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3,
	GARGANTUAN = 4
}

@onready var angle_visualizer = $"../AngleVisualizer"

func _ready():
	get_parent().dinoSpriteChoice.connect(chooseSprite)

func chooseSprite(dinoChoice):
	animated_sprite = dinoChoice
	visualOffset = Vector2(0, animated_sprite.position.y)
	attackRange = GlobalVars.playerAttackRange

func _process(_delta):
	if animated_sprite != null:
		var target_position = self.get_parent().position
		var direction = (get_global_mouse_position() - target_position).normalized()
		position = direction * attackRange + visualOffset
		
		var new_angle = atan2(direction.y, direction.x) - PI / 2
		angle_visualizer.rotation = new_angle
		
		if(direction.x < 0):
			animated_sprite.flip_h = false
			drop_shadow.position.x = 5
		else:
			animated_sprite.flip_h = true
			if(GlobalVars.playerSize == size.SMALL):
				drop_shadow.position.x = -1
			elif(GlobalVars.playerSize == size.MEDIUM):
				drop_shadow.position.x = -10
			elif(GlobalVars.playerSize == size.LARGE):
				drop_shadow.position.x = -15

func _physics_process(_delta):
	weakSpotInRange = false
	for area in get_overlapping_areas():
		if area.is_in_group("WeakSpot"):
			weakSpotInRange = true
