extends Control

func _on_start_button_pressed():
	$"Button Pressed".play()
	resetGlobalVariables()
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


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
	GlobalVars.currentLevel = 1
	GlobalVars.playerSize = GlobalVars.size.SMALL
	GlobalVars.playerSpeed = GlobalVars.playerSpeedReset
	GlobalVars.playerStrength = GlobalVars.playerStrengthReset
	GlobalVars.playerAttackRange = GlobalVars.playerAttackRangeReset
	GlobalVars.playerAttackSpeed = GlobalVars.playerAttackSpeedReset
	GlobalVars.playerHPMax = GlobalVars.playerHPMaxReset
	GlobalVars.playerHP = GlobalVars.playerHPMax
	GlobalVars.evoPoints = 0
	GlobalVars.hungerPoints = 0
	GlobalVars.hungerPointsMax = GlobalVars.hungerPointsMaxReset


func _on_start_button_mouse_entered():
	$"Button Hovered".play()
