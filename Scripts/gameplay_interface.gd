extends Control

func _ready():
	var player = get_tree().get_nodes_in_group("Player")
	player[0].sizeUpPopup.connect(_sizeUpPopup)

func _process(_delta):
	$HPBar.max_value = GlobalVars.playerHPMax
	$HPBar.value = GlobalVars.playerHP
	$HungerBar.max_value = GlobalVars.hungerPointsMax
	$HungerBar.value = GlobalVars.hungerPoints
	$VBoxContainer/SizeLabel.text = "Size: " + str(GlobalVars.playerSize)
	$VBoxContainer/EVOLabel.text = "EVO points: " + str(GlobalVars.evoPoints)

func _sizeUpPopup():
	get_tree().paused = true
	$SizeUpPopup/Control/VBoxContainer/Label.text = "[center]You've reached size " + str(GlobalVars.playerSize) + "!\nSpend some EVO points?"
	if GlobalVars.playerSize == 3:
		$HungerBar.hide()
	$SizeUpPopup.show()


func _on_continue_button_pressed():
	$SizeUpPopup.hide()
	get_tree().paused = false
