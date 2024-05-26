extends Node

#Player Variables
var playerSize = 1
var playerSpeed = 150.0
var playerStrength = 1.0
var playerAttackRange = 1.0
var playerAttackSpeed = 1.0
var playerHP = 5.0
var playerHPMax = 5.0
var evoPoints = 0
var hungerPoints = 0
var hungerPointsMax = 5
var killedBy = "Nothing"

#Continue Variables: These are saved when a player clears a level, and restored when pressing Continue.
var playerSpeedContinue = 150.0
var playerStrengthContinue = 1.0
var playerAttackRangeContinue = 1.0
var playerAttackSpeedContinue = 1.0
var playerHPMaxContinue = 5.0
var evoPointsContinue = 0
var hungerPointsMaxContinue = 5

#Reset Variables: These are the original variables, which the active variables are reset to at the game start.
var playerSpeedReset = 150.0
var playerStrengthReset = 1.0
var playerAttackRangeReset = 1.0
var playerAttackSpeedReset = 1.0
var playerHPMaxReset = 5.0
var evoPointsReset = 0
var hungerPointsMaxReset = 3
