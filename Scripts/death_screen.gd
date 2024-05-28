extends Control

func _ready():
	$KilledByLabel.text = "[center]You were killed by...\n%s![/center]" % GlobalVars.killedBy

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
