extends Node2D

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _ready():
	$World/WorldTop.position.y = -GlobalVars.worldHeight/2
	$World/WorldBottom.position.y = -GlobalVars.worldHeight/2
	$World/WorldLeft.position.x = -GlobalVars.worldWidth/2
	$World/WorldRight.position.x = GlobalVars.worldWidth/2
