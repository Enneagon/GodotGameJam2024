extends Gameplay_Interface

@onready var hunger_bar = $Character/HungerBar
@onready var hp_bar = $Character/HPBar
@onready var sprint_energy = $Character/SprintEnergy

@onready var biteDisplay = $Skills/BiteDisplay
@onready var biteTimer = $Skills/BiteTimer
var dinoChoice = 1
var player

signal roundStarted(dinoChoice)

var size_names = {1: "SMALL", 2: "MEDIUM", 3: "LARGE", 4: "GARGANTUAN"}

func _ready():
	await get_tree().process_frame
	get_tree().paused = true
	player = get_tree().get_nodes_in_group("Player")
	player[0].bellyFull.connect(roundEnded)
	player[0].skillUsedBite.connect(skillUsedBite)
	print(GlobalVars.playerType)
	match GlobalVars.currentLevel:
		1:
			$RoundStartPopup1.show()
		2:
			$RoundStartPopup2.show()
		3:
			if GlobalVars.playerType == 2:
				$RoundStartPopup3.show()
			else:
				$RoundStartPopup4.show()

func _process(_delta):
	hp_bar.max_value = GlobalVars.playerHPMax
	hp_bar.value = GlobalVars.playerHP
	hunger_bar.max_value = GlobalVars.hungerPointsMax
	hunger_bar.value = GlobalVars.hungerPoints
	sprint_energy.max_value = GlobalVars.playerSprintEnergyMax
	sprint_energy.value = GlobalVars.playerSprintEnergy
	
	biteDisplay.value = biteTimer.time_left


func skillUsedBite(resetTime):
	biteDisplay.max_value = resetTime
	biteTimer.wait_time = resetTime
	print(resetTime)
	biteTimer.start()


func _on_round_start_button_pressed():
	$RoundStartPopup1.hide()
	roundStarted.emit(dinoChoice)
	get_tree().paused = false

func _on_dino_choice_1_pressed():
	$RoundStartPopup2.hide()
	dinoChoice = 2
	roundStarted.emit(dinoChoice)
	get_tree().paused = false


func _on_dino_choice_2_pressed():
	$RoundStartPopup2.hide()
	dinoChoice = 3
	roundStarted.emit(dinoChoice)
	get_tree().paused = false


func _on_dino_choice_11_pressed():
	$RoundStartPopup3.hide()
	dinoChoice = 4
	roundStarted.emit(dinoChoice)
	get_tree().paused = false


func _on_dino_choice_12_pressed():
	$RoundStartPopup3.hide()
	dinoChoice = 5
	roundStarted.emit(dinoChoice)
	get_tree().paused = false


func _on_dino_choice_21_pressed():
	$RoundStartPopup4.hide()
	dinoChoice = 5
	roundStarted.emit(dinoChoice)
	get_tree().paused = false


func _on_dino_choice_22_pressed():
	$RoundStartPopup4.hide()
	dinoChoice = 6
	roundStarted.emit(dinoChoice)
	get_tree().paused = false


func roundEnded():
	if GlobalVars.currentLevel < 3:
		get_tree().paused = true
		$RoundEndedPopup.show()


func _on_round_end_button_pressed():
	GlobalVars.previousType = GlobalVars.playerType
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

