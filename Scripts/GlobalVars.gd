extends Node

enum size
{
	SMALL,
	MEDIUM,
	LARGE,
	GARGANTUAN
}

# Global Variables
const DAMAGE_REDUCTION_MULTIPLIER = 0.5
const DAMAGE_INCREASE_MULTIPLIER = 1.5

#Player Variables
var playerSize = size.SMALL
var playerSpeed = 100.0
var playerStrength = 1.0
var playerAttackRange = 1.0
var playerAttackSpeed = 1.0
var playerHP = 10.0
var playerHPMax = 10.0
var evoPoints = 0
var hungerPoints = 0
var hungerPointsMax = 25
var killedBy = "Nothing"

#Continue Variables: These are saved when a player clears a level, and restored when pressing Continue.
var playerSpeedContinue = 100.0
var playerStrengthContinue = 1.0
var playerAttackRangeContinue = 1.0
var playerAttackSpeedContinue = 1.0
var playerHPMaxContinue = 10.0
var evoPointsContinue = 0
var hungerPointsMaxContinue = 25

#Reset Variables: These are the original variables, which the active variables are reset to at the game start.
var playerSpeedReset = 100.0
var playerStrengthReset = 1.0
var playerAttackRangeReset = 1.0
var playerAttackSpeedReset = 1.0
var playerHPMaxReset = 10.0
var evoPointsReset = 0
var hungerPointsMaxReset = 25
