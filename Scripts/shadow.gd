extends CanvasLayer

var meteorhits = false
var player

func _ready():
	player = get_tree().get_nodes_in_group("Player")
	player[0].bellyFull.connect(startFinale)
	var dinoManager = get_tree().get_nodes_in_group("DinoManager")
	dinoManager[0].bossSpawned.connect(bossConnect)

func bossConnect(boss):
	boss.bossKilled.connect(meteorFalls)

func startFinale():
	if GlobalVars.currentLevel == 3:
		show()
		$AnimationPlayer.play("swoop")

func meteorFalls():
	$Timer.start()

func _on_timer_timeout():
	if meteorhits == false:
		meteorhits = true
		$MeteorSound.play()
		$AnimationPlayer.play("meteorFalls")
		$Timer.wait_time = 8.0
		$Timer.start()
		player[0].start_shake(8, 1)
	else:
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
