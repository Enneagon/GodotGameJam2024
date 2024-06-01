extends Node

@export var treesAvailable: Array[PackedScene]
@export var shrubsAvailable: Array[PackedScene]

@export var eggsAvailable: Array[PackedScene]

@export var smallDinosAvailable: Array[PackedScene]
@export var mediumDinosAvailable: Array[PackedScene]
@export var largeDinosAvailable: Array[PackedScene]
@export var gargantuanDinosAvailable: Array[PackedScene]

var treesAlive = 0
var shrubsAlive = 0
var eggsAlive = 0

var smallDinosAlive = []
var mediumDinosAlive = []
var largeDinosAlive = []
var gargantuanDinosAlive = []

@export var treesMin = 0
@export var shrubsMin = 0
@export var eggsMin = 0


@export var smallDinosMin = 0
@export var mediumDinosMin = 0
@export var largeDinosMin = 0
@export var gargantuanDinosMin = 0

var player
var minDistanceFromPlayer = 200

var finaleStarted = false
signal bossSpawned

func _ready():
	player = get_tree().get_nodes_in_group("Player")
	player[0].bellyFull.connect(startFinale)
	for plant in get_tree().get_nodes_in_group("Foliage"):
		if plant.is_in_group("Tree"):
			treesAlive += 1
		elif plant.is_in_group("Shrub"):
			shrubsAlive += 1
	for dino in get_tree().get_nodes_in_group("Enemy"):
		if dino.dinoSize == 1:
			smallDinosAlive.append(dino)
		elif dino.dinoSize == 2:
			mediumDinosAlive.append(dino)
		elif dino.dinoSize == 3:
			largeDinosAlive.append(dino)
		elif dino.dinoSize == 4:
			gargantuanDinosAlive.append(dino)
	createFoliage()
	createEggs()

func fillMap():
	createDinos()

func createEggs():
	while eggsAlive < eggsMin:
		if eggsAvailable.is_empty():
			break
		var newEgg = eggsAvailable.pick_random().instantiate()
		placeDino(newEgg)
		eggsAlive += 1

func createFoliage():
	while treesAlive < treesMin:
		if treesAvailable.is_empty():
			break
		var newTree = treesAvailable.pick_random().instantiate()
		placeDino(newTree)
		treesAlive += 1
	while shrubsAlive < shrubsMin:
		if shrubsAvailable.is_empty():
			break
		var newShrub = shrubsAvailable.pick_random().instantiate()
		placeDino(newShrub)
		shrubsAlive += 1

func createDinos():
	while smallDinosAlive.size() < smallDinosMin:
		if smallDinosAvailable.is_empty():
			break
		var newSmallDino = smallDinosAvailable.pick_random().instantiate()
		placeDino(newSmallDino)
		smallDinosAlive.append(newSmallDino)
	while mediumDinosAlive.size() < mediumDinosMin:
		if mediumDinosAvailable.is_empty():
			break
		var newMediumDino = mediumDinosAvailable.pick_random().instantiate()
		placeDino(newMediumDino)
		mediumDinosAlive.append(newMediumDino)
	while largeDinosAlive.size() < largeDinosMin:
		if largeDinosAvailable.is_empty():
			break
		var newLargeDino = largeDinosAvailable.pick_random().instantiate()
		placeDino(newLargeDino)
		largeDinosAlive.append(newLargeDino)

func placeDino(dino):
	$"../YSort".call_deferred("add_child", dino)
	dino.position = Vector2(randi_range(-GlobalVars.worldWidth/2 + 50, GlobalVars.worldWidth/2 - 50), randi_range(-GlobalVars.worldHeight/2 + 100, GlobalVars.worldHeight/2 - 50.0))
	while dino.position.distance_to(player[0].position) < minDistanceFromPlayer:
		dino.position = Vector2(randi_range(-GlobalVars.worldWidth/2 + 50, GlobalVars.worldWidth/2 - 50), randi_range(-GlobalVars.worldHeight/2 + 100, GlobalVars.worldHeight/2 - 50.0))

func clearNullReferences():
	for dino in smallDinosAlive:
		if dino == null:
			smallDinosAlive.erase(dino)
	for dino in mediumDinosAlive:
		if dino == null:
			mediumDinosAlive.erase(dino)
	for dino in largeDinosAlive:
		if dino == null:
			largeDinosAlive.erase(dino)
	for dino in gargantuanDinosAlive:
		if dino == null:
			gargantuanDinosAlive.erase(dino)

func _on_timer_timeout():
	clearNullReferences()
	if finaleStarted == false:
		createDinos()
	else:
		
		$Timer.stop()
		gargantuanDinosMin = 1
		if gargantuanDinosAvailable.is_empty():
			return
		var newGargantuanDino = gargantuanDinosAvailable.pick_random().instantiate()
		placeDino(newGargantuanDino)
		gargantuanDinosAlive.append(newGargantuanDino)
		player[0].camera.zoom = Vector2(2,2)
		bossSpawned.emit(newGargantuanDino)
		print("It's here!", newGargantuanDino.position)
		

func startFinale():
	if GlobalVars.currentLevel == 3:
		finaleStarted = true
		$Timer.wait_time = 2.0
		$Timer.start()
