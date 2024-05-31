extends Control

func _on_start_button_pressed():
	$"Button Pressed".play()
	resetGlobalVariables()
	get_tree().change_scene_to_file("res://Scenes/level3.tscn")


func _on_credits_button_pressed():
	$Blocker.show()
	$CreditsOverlay.show()
	get_tree().set_group("MainMenuButtons", "focus_mode", FOCUS_NONE)


func _on_options_button_pressed():
	$Blocker.show()
	$OptionsOverlay.show()
	get_tree().set_group("MainMenuButtons", "focus_mode", FOCUS_NONE)


func _on_credits_back_button_pressed():
	$Blocker.hide()
	$CreditsOverlay.hide()
	get_tree().set_group("MainMenuButtons", "focus_mode", FOCUS_ALL)


func _on_options_back_button_pressed():
	$Blocker.hide()
	$OptionsOverlay.hide()
	get_tree().set_group("MainMenuButtons", "focus_mode", FOCUS_ALL)


func resetGlobalVariables():
	GlobalVars.currentLevel = 3
	GlobalVars.playerSize = GlobalVars.size.SMALL
	GlobalVars.playerSpeed = GlobalVars.playerSpeedReset
	GlobalVars.playerStrength = GlobalVars.playerStrengthReset
	GlobalVars.playerAttackRange = GlobalVars.playerAttackRangeReset
	GlobalVars.playerAttackSpeed = GlobalVars.playerAttackSpeedReset
	GlobalVars.playerHPMax = GlobalVars.playerHPMaxReset
	GlobalVars.playerHP = GlobalVars.playerHPMax
	GlobalVars.hungerPoints = 0
	GlobalVars.hungerPointsMax = GlobalVars.hungerPointsMaxReset
	GlobalVars.playerSprintEnergyMax = GlobalVars.playerSprintEnergyMaxReset
	GlobalVars.playerSprintEnergy = GlobalVars.playerSprintEnergyMaxReset
	GlobalVars.abilityPredator = false
	GlobalVars.abilityScavenger = false
	GlobalVars.abilitySpit = false
	GlobalVars.abilityTailWhip = false
	GlobalVars.abilityAggressor = false
	GlobalVars.abilityGroundSlam = false
	GlobalVars.abilityInfectiousBite = false
	GlobalVars.abilityApexPredator = false
	GlobalVars.abilityHeadbutt = false


func _on_start_button_mouse_entered():
	$"Button Hovered".play()
