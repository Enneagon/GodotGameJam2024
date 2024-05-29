extends Gameplay_Interface

@onready var hunger_text = $"Character/Hunger Text"
@onready var hunger_bar = $Character/HungerBar
@onready var hp_bar = $Character/HPBar
@onready var sprint_energy = $Character/SprintEnergy

@onready var abilitiesPopup = $AbilitiesPopup

@onready var biteDisplay = $Skills/BiteDisplay
@onready var biteTimer = $Skills/BiteTimer

@onready var predatorDisplay = $Skills/PredatorDisplay
@onready var scavengerDisplay = $Skills/ScavengerDisplay
@onready var spitDisplay = $Skills/SpitDisplay
@onready var tailwhipDisplay = $Skills/TailWhipDisplay
@onready var aggressorDisplay = $Skills/AggressorDisplay
@onready var groundslamDisplay = $Skills/GroundSlamDisplay
@onready var infectiousBiteDisplay = $Skills/InfectiousBiteDisplay
@onready var apexPredatorDisplay = $Skills/apexPredatorDisplay
@onready var headbuttDisplay = $Skills/HeadbuttDisplay

@onready var ability1Timer = $Skills/Ability1Timer
@onready var ability2Timer = $Skills/Ability2Timer
@onready var ability3Timer = $Skills/Ability3Timer

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
	player[0].ability1Used.connect(ability1Used)
	player[0].ability2Used.connect(ability2Used)
	player[0].ability3Used.connect(ability3Used)
	abilitiesPopup.abilityChosen.connect(roundBegin)
	if GlobalVars.abilityPredator:
		predatorDisplay.show()
	elif GlobalVars.abilityScavenger:
		scavengerDisplay.show()
	elif GlobalVars.abilitySpit:
		spitDisplay.show()
	if GlobalVars.abilityTailWhip:
		tailwhipDisplay.show()
	elif GlobalVars.abilityAggressor:
		aggressorDisplay.show()
	elif GlobalVars.abilityGroundSlam:
		groundslamDisplay.show()
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
	hunger_text.text = str(GlobalVars.hungerPoints) + " \\ " + str(GlobalVars.hungerPointsMax)
	sprint_energy.max_value = GlobalVars.playerSprintEnergyMax
	sprint_energy.value = GlobalVars.playerSprintEnergy
	
	biteDisplay.value = biteTimer.time_left
	spitDisplay.value = ability1Timer.time_left
	tailwhipDisplay.value = ability2Timer.time_left
	groundslamDisplay.value = ability2Timer.time_left
	headbuttDisplay.value = ability3Timer.time_left


func skillUsedBite(resetTime):
	biteDisplay.max_value = resetTime
	biteTimer.wait_time = resetTime
	biteTimer.start()

func ability1Used(resetTime):
	spitDisplay.max_value = resetTime
	ability1Timer.wait_time = resetTime
	ability1Timer.start()

func ability2Used(resetTime):
	tailwhipDisplay.max_value = resetTime
	groundslamDisplay.max_value = resetTime
	ability2Timer.wait_time = resetTime
	ability2Timer.start()

func ability3Used(resetTime):
	headbuttDisplay.max_value = resetTime
	ability3Timer.wait_time = resetTime
	ability3Timer.start()

func _on_round_start_button_pressed():
	$RoundStartPopup1.hide()
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()

func _on_dino_choice_1_pressed():
	$RoundStartPopup2.hide()
	dinoChoice = 2
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()


func _on_dino_choice_2_pressed():
	$RoundStartPopup2.hide()
	dinoChoice = 3
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()


func _on_dino_choice_11_pressed():
	$RoundStartPopup3.hide()
	dinoChoice = 4
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()


func _on_dino_choice_12_pressed():
	$RoundStartPopup3.hide()
	dinoChoice = 5
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()


func _on_dino_choice_21_pressed():
	$RoundStartPopup4.hide()
	dinoChoice = 5
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()


func _on_dino_choice_22_pressed():
	$RoundStartPopup4.hide()
	dinoChoice = 6
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()


func roundBegin(abilityChoice):
	match abilityChoice:
		1:
			predatorDisplay.show()
		2:
			scavengerDisplay.show()
		3:
			spitDisplay.show()
		4:
			tailwhipDisplay.show()
		5:
			aggressorDisplay.show()
		6:
			groundslamDisplay.show()
		7:
			infectiousBiteDisplay.show()
		8:
			apexPredatorDisplay.show()
		9:
			headbuttDisplay.show()
	abilitiesPopup.hide()
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

