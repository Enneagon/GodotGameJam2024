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

	

	


func resetGlobalVariables():
	GlobalVars.currentLevel = 1
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


func _on_options_back_button_pressed():
	$Blocker.hide()
	$OptionsOverlay.hide()
	get_tree().set_group("MainMenuButtons", "focus_mode", FOCUS_ALL)


func _on_options_back_button_mouse_entered():
	$"Button Hovered".play()


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_ambience_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), value)


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_credits_back_button_mouse_entered():
	$"Button Hovered".play()


func _on_credits_back_button_pressed():
	$Blocker.hide()
	$CreditsOverlay.hide()
	get_tree().set_group("MainMenuButtons", "focus_mode", FOCUS_ALL)


func _on_jamie_website_linked_meta_clicked(_meta):
	OS.shell_open("https://jamiesullphill.wixstudio.io/jsullivanphillips")


func _on_griffin_website_meta_clicked(_meta):
	OS.shell_open("https://artinnoise.com/")


func _on_tiny_bard_website_meta_clicked(_meta):
	OS.shell_open("https://www.tinybard.art/")


func _on_nine_website_meta_clicked(_meta):
	OS.shell_open("https://enneagon.itch.io//")


func _on_check_box_toggled(toggled_on):
	GlobalVars.isScreenshakeEnabled = toggled_on


func _on_rich_text_description_meta_clicked(meta):
	OS.shell_open("https://store.steampowered.com/app/2497910/Into_the_Dungeon/")
