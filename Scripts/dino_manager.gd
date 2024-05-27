extends Node

@export var worldWidth = 1.0
@export var worldHeight = 1.0

@export var smallDinosAvailable: Array[PackedScene]
@export var mediumDinosAvailable: Array[PackedScene]
@export var largeDinosAvailable: Array[PackedScene]
@export var gargantuanDinosAvailable: Array[PackedScene]

var smallDinosAlive = []
var mediumDinosAlive = []
var largeDinosAlive = []
var gargantuanDinosAlive = []

@export var smallDinosMin = 0
@export var mediumDinosMin = 0
@export var largeDinosMin = 0
@export var gargantuanDinosMin = 0

var player
var minDistanceFromPlayer = 300

func _ready():
	player = get_tree().get_nodes_in_group("Player")
	for dino in get_children():
		if dino == $Timer:
			continue
		if dino.dinoSize == 1:
			smallDinosAlive.append(dino)
		elif dino.dinoSize == 2:
			mediumDinosAlive.append(dino)
		elif dino.dinoSize == 3:
			largeDinosAlive.append(dino)
		elif dino.dinoSize == 4:
			gargantuanDinosAlive.append(dino)
	createDinos()

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
	while gargantuanDinosAlive.size() < gargantuanDinosMin:
		if gargantuanDinosAvailable.is_empty():
			break
		var newGargantuanDino = smallDinosAvailable.pick_random().instantiate()
		placeDino(newGargantuanDino)
		gargantuanDinosAlive.append(newGargantuanDino)

func placeDino(dino):
	add_child(dino)
	dino.position = Vector2(randi_range(-worldWidth/2, worldWidth/2), randi_range(-worldHeight/2, worldHeight/2))
	while dino.position.distance_to(player[0].position) < minDistanceFromPlayer:
		dino.position = Vector2(randi_range(-worldWidth/2, worldWidth/2), randi_range(-worldHeight/2, worldHeight/2))

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
	createDinos()
