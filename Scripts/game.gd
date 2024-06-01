extends Node2D



func _ready():
	var player = get_tree().get_nodes_in_group("Player")
	player[0].bellyFull.connect(startFinale)
	$World/WorldTop.position.y = -GlobalVars.worldHeight/2
	$World/WorldBottom.position.y = GlobalVars.worldHeight/2 - 50.0 # Height of UI
	$World/WorldLeft.position.x = -GlobalVars.worldWidth/2
	$World/WorldRight.position.x = GlobalVars.worldWidth/2

func startFinale():
	var fadeMusic = create_tween()
	fadeMusic.tween_property($DinoMusic, "volume_db", -40, 2)
	await fadeMusic.finished
	$DinoMusic.stop()
	$BossMusic.play()
