extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


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
