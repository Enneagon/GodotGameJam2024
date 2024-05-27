extends Gameplay_Interface

@onready var hunger_bar = $HungerBar
@onready var hp_bar = $HPBar
@onready var sprint_energy = $SprintEnergy

signal roundStarted

var size_names = {1: "SMALL", 2: "MEDIUM", 3: "LARGE", 4: "GARGANTUAN"}

func _ready():
	await get_tree().process_frame
	get_tree().paused = true
	var player = get_tree().get_nodes_in_group("Player")
	player[0].sizeUpPopup.connect(_sizeUpPopup)
	match GlobalVars.currentLevel:
		1:
			$RoundStartPopup1.show()
		2:
			$RoundStartPopup2.show()
		3:
			$RoundStartPopup3.show()

func _process(_delta):
	hp_bar.max_value = GlobalVars.playerHPMax
	hp_bar.value = GlobalVars.playerHP
	hunger_bar.max_value = GlobalVars.hungerPointsMax
	hunger_bar.value = GlobalVars.hungerPoints
	sprint_energy.max_value = GlobalVars.playerSprintEnergyMax
	sprint_energy.value = GlobalVars.playerSprintEnergy
	$VBoxContainer/SizeLabel.text = "Size: " + size_names[GlobalVars.playerSize]
	$VBoxContainer/EVOLabel.text = "EVO points: " + str(GlobalVars.evoPoints)


func _on_round_start_button_pressed():
	$RoundStartPopup1.hide()
	$RoundStartPopup2.hide()
	$RoundStartPopup3.hide()
	roundStarted.emit()
	get_tree().paused = false

func _sizeUpPopup():
	get_tree().paused = true
	$SizeUpPopup/Control/VBoxContainer/Label.text = "[center]You've reached size " + str(GlobalVars.playerSize) + "!\nSpend some EVO points?"
	if GlobalVars.playerSize == 3:
		$HungerBar.hide()
	$SizeUpPopup.show()

func _on_continue_button_pressed():
	$SizeUpPopup.hide()
	get_tree().paused = false


func roundEnded():
	get_tree().paused = true
	$RoundEndedPopup.show()


func _on_round_end_button_pressed():
	if GlobalVars.currentLevel == 1:
		GlobalVars.currentLevel = 2
		get_tree().change_scene_to_file("res://Scenes/level2.tscn")
	else:
		GlobalVars.currentLevel = 3
		get_tree().change_scene_to_file("res://Scenes/level3.tscn")


func startFinale():
	var dinoManager = get_tree().get_nodes_in_group("DinoManager")
	dinoManager[0].gargantuanDinosMin = 1
	dinoManager[0].createDinos()
	dinoManager[0].finaleStarted = true
