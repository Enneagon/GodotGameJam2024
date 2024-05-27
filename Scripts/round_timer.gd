extends TextureProgressBar

@export var baseUI = Gameplay_Interface
var roundTime = 45
var finaleStarted = false

func _ready():
	$Timer.wait_time = roundTime
	baseUI.roundStarted.connect(_roundStart)

func _process(_delta):
	max_value = roundTime
	value = roundTime - $Timer.time_left
	if GlobalVars.currentLevel == 3 and $Timer.time_left < 30 and finaleStarted == false:
		tint_progress = Color.CRIMSON
		baseUI.startFinale()
		finaleStarted = true

func _roundStart():
	$Timer.start()

func _on_timer_timeout():
	baseUI.roundEnded()
