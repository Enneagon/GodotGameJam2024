extends Control
@onready var outline = $Outline
@onready var winText = $WinText
@onready var timer = $Timer
@onready var animator = $AnimationPlayer

func _ready():
	timer.start()
	await timer.timeout
	$WinMusic.play()
	timer.wait_time = 10.0
	if GlobalVars.playerType == 4:
		tRexEnding()
	elif GlobalVars.playerType == 5:
		velociraptorEnding()
	else:
		pigeonEnding()

func tRexEnding():
	$KingEnding.show()
	winText.text = "[center]You did it. You triumphed over all others and became the biggest, baddest dinosaur in the land."
	outline.text = winText.text
	animator.play("fade_out")
	await animator.animation_finished
	timer.start()
	await timer.timeout
	animator.play("fade_in")
	await animator.animation_finished
	$KingEnding.hide()
	$MeteorEnding.show()
	winText.text = "[center]At least, until the meteor hit. Your massive bulk was unable to escape the impact. At least you died a king!"
	outline.text = winText.text
	animator.play("fade_out")
	await animator.animation_finished
	timer.wait_time = 2.0
	timer.start()
	await timer.timeout
	$MenuButton.show()

func velociraptorEnding():
	$MeteorEnding.show()
	winText.text = "[center]Your victory as top predator was short-lived. The arrival of a meteor spread devastation across the land."
	outline.text = winText.text
	animator.play("fade_out")
	await animator.animation_finished
	timer.start()
	await timer.timeout
	animator.play("fade_in")
	await animator.animation_finished
	$MeteorEnding.hide()
	$Velociraptor1.show()
	winText.text = "[center]With your incredible speed, you managed to escape the impact. With all the bigger dinosaurs gone, the world was yours for the taking!"
	outline.text = winText.text
	animator.play("fade_out")
	await animator.animation_finished
	timer.start()
	await timer.timeout
	animator.play("fade_in")
	await animator.animation_finished
	$Velociraptor1.hide()
	$Velociraptor2.show()
	winText.text = "[center]Unfortunately, with the ecosystem in disarray, supplies of food began to run low..."
	outline.text = winText.text
	animator.play("fade_out")
	await animator.animation_finished
	timer.start()
	await timer.timeout
	animator.play("fade_in")
	await animator.animation_finished
	$Velociraptor2.hide()
	$Velociraptor3.show()
	winText.text = "[center]In the end, you perished like the rest, unable to sustain your diet. If only you'd been a little bit smaller..."
	outline.text = winText.text
	animator.play("fade_out")
	await animator.animation_finished
	timer.wait_time = 2.0
	timer.start()
	await timer.timeout
	$MenuButton.show()

func pigeonEnding():
	$MeteorEnding.show()
	winText.text = "[center]Your victory as top predator was short-lived. The arrival of a meteor spread devastation across the land."
	outline.text = winText.text
	animator.play("fade_out")
	await animator.animation_finished
	timer.start()
	await timer.timeout
	animator.play("fade_in")
	await animator.animation_finished
	$MeteorEnding.hide()
	$Pigeon1.show()
	winText.text = "[center]With wings spread wide, you watched the destruction from afar. Your small size would be a boon in the days to come."
	outline.text = winText.text
	animator.play("fade_out")
	await animator.animation_finished
	timer.start()
	await timer.timeout
	animator.play("fade_in")
	await animator.animation_finished
	$Pigeon1.hide()
	$Pigeon2.show()
	winText.text = "[center]And one day... your descendants would come to rule the world."
	outline.text = winText.text
	animator.play("fade_out")
	await animator.animation_finished
	timer.wait_time = 2.0
	timer.start()
	await timer.timeout
	$MenuButton.show()

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

