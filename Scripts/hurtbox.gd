extends Area2D

var biteRange = 15.0
var animated_sprite
var weakSpotInRange = false

func _ready():
	get_parent().dinoSpriteChoice.connect(chooseSprite)

func chooseSprite(dinoChoice):
	animated_sprite = dinoChoice

func _process(_delta):
	if animated_sprite != null:
		var direction = (get_global_mouse_position() - self.get_parent().position).normalized()
		position = biteRange * direction
		if(direction.x < 0):
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true

func _physics_process(_delta):
	weakSpotInRange = false
	for area in get_overlapping_areas():
		if area.is_in_group("WeakSpot"):
			weakSpotInRange = true
