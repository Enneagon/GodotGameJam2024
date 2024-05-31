extends Control

@onready var nameLabel = $Control/MarginContainer/VBoxContainer/Label
@onready var descriptionLabel = $Control/MarginContainer/VBoxContainer/Label2

signal abilityChosen

func _ready():
	match GlobalVars.currentLevel:
		1:
			$Control/MarginContainer/VBoxContainer/HBoxContainer/PredatorButton.show()
			$Control/MarginContainer/VBoxContainer/HBoxContainer/ScavengerButton.show()
			$Control/MarginContainer/VBoxContainer/HBoxContainer/SpitButton.show()
		2:
			$Control/MarginContainer/VBoxContainer/HBoxContainer/TailWhipButton.show()
			$Control/MarginContainer/VBoxContainer/HBoxContainer/AggressorButton.show()
			$Control/MarginContainer/VBoxContainer/HBoxContainer/GroundSlamButton.show()
		3:
			$Control/MarginContainer/VBoxContainer/HBoxContainer/InfectiousBiteButton.show()
			$Control/MarginContainer/VBoxContainer/HBoxContainer/ApexDashButton.show()
			$Control/MarginContainer/VBoxContainer/HBoxContainer/HeadbuttButton.show()

func resetLabels():
	nameLabel.text = "Choose an Ability!"
	descriptionLabel.text = " \n "

func _on_button_mouse_exited():
	resetLabels()

func _on_predator_button_mouse_entered():
	nameLabel.text = "PREDATOR"
	descriptionLabel.text = "Increase basic Bite damage by 25%\n "


func _on_predator_button_pressed():
	abilityChosen.emit(1)


func _on_scavenger_button_mouse_entered():
	nameLabel.text = "SCAVENGER"
	descriptionLabel.text = "Increase speed, stamina, and stamina regen rate by 25%\n "


func _on_scavenger_button_pressed():
	abilityChosen.emit(2)


func _on_spit_button_mouse_entered():
	nameLabel.text = "SPIT"
	descriptionLabel.text = "Press 1 to launch a blob\nof corrosive goo"


func _on_spit_button_pressed():
	abilityChosen.emit(3)


func _on_tail_whip_button_mouse_entered():
	nameLabel.text = "TAIL WHIP"
	descriptionLabel.text = "Press 2 to powerfully attack\nin front of and behind you"


func _on_tail_whip_button_pressed():
	abilityChosen.emit(4)


func _on_aggressor_button_mouse_entered():
	nameLabel.text = "AGGRESSOR"
	descriptionLabel.text = "Extends the range of your bite, and\nyou can now hit two foes at once"


func _on_aggressor_button_pressed():
	abilityChosen.emit(5)


func _on_ground_slam_button_mouse_entered():
	nameLabel.text = "GROUND SLAM"
	descriptionLabel.text = "Press 2 to attack all foes around\nyou and slow them for a short time"


func _on_ground_slam_button_pressed():
	abilityChosen.emit(6)


func _on_infectious_bite_button_mouse_entered():
	nameLabel.text = "INFECTIOUS BITE"
	descriptionLabel.text = "Your bites inflict a stacking,\nfast-damaging poison"


func _on_infectious_bite_button_pressed():
	abilityChosen.emit(7)


func _on_apex_predator_button_mouse_entered():
	nameLabel.text = "APEX DASH"
	descriptionLabel.text = "Gain extreme speed momentarily, allowing\nyou to dash straight through enemies"


func _on_apex_predator_button_pressed():
	abilityChosen.emit(8)


func _on_headbutt_button_mouse_entered():
	nameLabel.text = "HEADBUTT"
	descriptionLabel.text = "Press 3 to attack and temporarily\nstun all enemies in front of you"


func _on_headbutt_button_pressed():
	abilityChosen.emit(9)
