extends Control

func _process(_delta):
	$HPBar.max_value = GlobalVars.playerHPMax
	$HPBar.value = GlobalVars.playerHP
	$VBoxContainer/SizeLabel.text = "Size: " + str(GlobalVars.playerSize)
	$VBoxContainer/EVOLabel.text = "EVO points: " + str(GlobalVars.evoPoints)
	
