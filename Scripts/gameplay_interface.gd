extends Control

@onready var hunger_bar = $HungerBar
@onready var hp_bar = $HPBar
@onready var sprint_energy = $SprintEnergy


var size_names = {1: "SMALL", 2: "MEDIUM", 3: "LARGE", 4: "GARGANTUAN"}

func _ready():
	var player = get_tree().get_nodes_in_group("Player")
	player[0].sizeUpPopup.connect(_sizeUpPopup)

func _process(_delta):
	hp_bar.max_value = GlobalVars.playerHPMax
	hp_bar.value = GlobalVars.playerHP
	hunger_bar.max_value = GlobalVars.hungerPointsMax
	hunger_bar.value = GlobalVars.hungerPoints
	sprint_energy.max_value = GlobalVars.playerSprintEnergyMax
	sprint_energy.value = GlobalVars.playerSprintEnergy
	$VBoxContainer/SizeLabel.text = "Size: " + size_names[GlobalVars.playerSize]
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
