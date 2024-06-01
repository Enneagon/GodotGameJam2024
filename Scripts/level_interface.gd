extends Gameplay_Interface

@onready var hunger_text = $"Character/Hunger Text"
@onready var hunger_bar = $Character/HungerBar

@onready var sprint_energy = $Character/SprintEnergy

@onready var abilitiesPopup = $AbilitiesPopup

@onready var biteDisplay = $Skills/BiteDisplay
@onready var biteTimer = $Skills/BiteTimer

@onready var dinosaur_name = $Character/DinosaurName

@onready var predatorDisplay = $Skills/PredatorDisplay
@onready var scavengerDisplay = $Skills/ScavengerDisplay
@onready var spitDisplay = $Skills/SpitDisplay
@onready var tailwhipDisplay = $Skills/TailWhipDisplay
@onready var aggressorDisplay = $Skills/AggressorDisplay
@onready var groundslamDisplay = $Skills/GroundSlamDisplay
@onready var infectiousBiteDisplay = $Skills/InfectiousBiteDisplay
@onready var apexDashDisplay = $Skills/ApexDashDisplay
@onready var headbuttDisplay = $Skills/HeadbuttDisplay

@onready var ability1Timer = $Skills/Ability1Timer
@onready var ability2Timer = $Skills/Ability2Timer
@onready var ability3Timer = $Skills/Ability3Timer

@onready var button_touch = $ButtonTouch
@onready var button_select = $ButtonSelect

@onready var damage_indicator_overlay = $Control/DamageIndicatorOverlay

enum dinoType
{
	EORAPTOR = 1,
	GUANLONG = 2,
	COELURUS = 3,
	TREX = 4,
	VELOCIRAPTOR = 5,
	ARCHAEOPTERYX = 6
}

var flash_duration = 0.0
var is_flashing = false

var dinoChoice = 1
var player
var dinoManager

signal roundStarted(dinoChoice)

var size_names = {1: "SMALL", 2: "MEDIUM", 3: "LARGE", 4: "GARGANTUAN"}

func _ready():
	await get_tree().process_frame
	get_tree().paused = true
	player = get_tree().get_nodes_in_group("Player")
	dinoManager = get_tree().get_first_node_in_group("DinoManager")
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
				
	$Character/Portraits/EoraptorPortrait.visible = false
	$Character/Portraits/GuanlongPortrait.visible = false
	$Character/Portraits/CoelurusPortrait.visible = false
	$"Character/Portraits/T_Rex Portrait".visible = false
	$"Character/Portraits/Velociraptor Portrait".visible = false
	$"Character/Portraits/Archaeopteryx Portrait".visible = false
				
	


func _process(delta):
	
	hunger_bar.max_value = GlobalVars.hungerPointsMax
	hunger_bar.value = GlobalVars.hungerPoints
	hunger_text.text = str(GlobalVars.hungerPoints) + " \\ " + str(GlobalVars.hungerPointsMax)
	sprint_energy.max_value = GlobalVars.playerSprintEnergyMax
	sprint_energy.value = GlobalVars.playerSprintEnergy
	
	biteDisplay.value = biteTimer.time_left
	spitDisplay.value = ability1Timer.time_left
	tailwhipDisplay.value = ability2Timer.time_left
	groundslamDisplay.value = ability2Timer.time_left
	apexDashDisplay.value = ability3Timer.time_left
	headbuttDisplay.value = ability3Timer.time_left

	if (is_flashing):
		flash_duration -= delta
		if flash_duration > 0.5:
			damage_indicator_overlay.modulate.a = 2.0 - 2.0 * flash_duration  # Increase alpha
		else:
			damage_indicator_overlay.modulate.a = 2.0 * flash_duration  # Decrease alpha
		if flash_duration <= 0.0:
			is_flashing = false
			damage_indicator_overlay.modulate.a = 0.0  # Reset alpha
			
	if GlobalVars.playerType == dinoType.EORAPTOR:
		$Character/Portraits/EoraptorPortrait.visible = true
		dinosaur_name.text = "Eoraptor"
	elif GlobalVars.playerType == dinoType.GUANLONG:
		$Character/Portraits/GuanlongPortrait.visible = true
		dinosaur_name.text = "Guanlong"
	elif GlobalVars.playerType == dinoType.COELURUS:
		$Character/Portraits/CoelurusPortrait.visible = true
		dinosaur_name.text = "Coelurus"
	elif GlobalVars.playerType == dinoType.TREX:
		$"Character/Portraits/T_Rex Portrait".visible = true
		dinosaur_name.text = "T. Rex"
	elif GlobalVars.playerType == dinoType.VELOCIRAPTOR:
		$"Character/Portraits/Velociraptor Portrait".visible = true
		dinosaur_name.text = "Velociraptor"
	elif GlobalVars.playerType == dinoType.ARCHAEOPTERYX:
		$"Character/Portraits/Archaeopteryx Portrait".visible = true
		dinosaur_name.text = "Archaeopteryx"

func flash_damage_indicator_overlay():
	is_flashing = true
	flash_duration = 0.5


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
	apexDashDisplay.max_value = resetTime
	headbuttDisplay.max_value = resetTime
	ability3Timer.wait_time = resetTime
	ability3Timer.start()

func _on_round_start_button_pressed():
	$RoundStartPopup1.hide()
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()

func _on_dino_choice_1_btn_button_down():
	$RoundStartPopup2.hide()
	dinoChoice = 2
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()
	
func _on_dino_choice_2_btn_pressed():
	$RoundStartPopup2.hide()
	dinoChoice = 3
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()

func _on_dino_choice_3_btn_pressed():
	$RoundStartPopup3.hide() # T Rex
	dinoChoice = 4
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()

func _on_dino_choice_4_btn_pressed():
	$RoundStartPopup3.hide() # Velociraptor
	dinoChoice = 5
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()


func _on_dino_choice_5_btn_pressed():
	$RoundStartPopup4.hide()
	dinoChoice = 6
	roundStarted.emit(dinoChoice)
	abilitiesPopup.show()

func _on_dino_choice_6_btn_pressed():
	$RoundStartPopup4.hide()
	dinoChoice = 5
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
			apexDashDisplay.show()
		9:
			headbuttDisplay.show()
	abilitiesPopup.hide()
	get_tree().paused = false
	dinoManager.fillMap()


func roundEnded():
	if GlobalVars.currentLevel < 3:
		get_tree().paused = true
		$RoundEndedPopup.show()


func _on_round_end_button_pressed():
	GlobalVars.previousType = GlobalVars.playerType
	button_select.play()
	if GlobalVars.currentLevel == 1:
		GlobalVars.currentLevel = 2
		get_tree().change_scene_to_file("res://Scenes/level2.tscn")
	else:
		GlobalVars.currentLevel = 3
		get_tree().change_scene_to_file("res://Scenes/level3.tscn")


func startFinale():
	dinoManager = get_tree().get_nodes_in_group("DinoManager")
	dinoManager[0].gargantuanDinosMin = 1
	dinoManager[0].createDinos()
	dinoManager[0].finaleStarted = true


func _on_round_start_button_mouse_entered():
	button_touch.play()
