extends TextureProgressBar

@export var baseUI = Gameplay_Interface
var roundTime = 180

func _ready():
	$Timer.wait_time = roundTime

func _process(_delta):
	value = roundTime - $Timer.time_left

func roundStart():
	$Timer.start()

func _on_timer_timeout():
	baseUI.roundEnded()
