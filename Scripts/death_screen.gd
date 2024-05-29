extends Control
@onready var outline = $Outline

func _ready():
	$KilledByLabel.text = "[center]You were killed by...\n%s![/center]" % GlobalVars.killedBy
	outline.text = $KilledByLabel.text
	
	match GlobalVars.currentLevel:
		1:
			if GlobalVars.abilityScavenger:
				GlobalVars.playerSprintEnergyMax = GlobalVars.playerSprintEnergyMaxReset
			GlobalVars.abilityPredator = false
			GlobalVars.abilityScavenger = false
			GlobalVars.abilitySpit = false
		2:
			GlobalVars.abilityTailWhip = false
			GlobalVars.abilityAggressor = false
			GlobalVars.abilityGroundSlam = false
		3:
			GlobalVars.abilityInfectiousBite = false
			GlobalVars.abilityApexPredator = false
			GlobalVars.abilityHeadbutt = false

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_continue_button_pressed():
	GlobalVars.playerType = GlobalVars.previousType
	match GlobalVars.currentLevel:
		1:
			get_tree().change_scene_to_file("res://Scenes/level1.tscn")
		2:
			get_tree().change_scene_to_file("res://Scenes/level2.tscn")
		3:
			get_tree().change_scene_to_file("res://Scenes/level3.tscn")
