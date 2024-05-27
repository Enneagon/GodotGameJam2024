extends Node

enum size
{
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3,
	GARGANTUAN = 4
}

# Global Variables
const DAMAGE_REDUCTION_MULTIPLIER = 0.5
const DAMAGE_INCREASE_MULTIPLIER = 1.5
var currentLevel = 1

#Player Variables
var playerSprintSpeedMultiplier = 1.6
var playerSprintEnergy = 20.0
var playerSprintEnergyMax = 20.0
var playerSize = size.SMALL
var playerSpeed = 60.0
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
var playerSpeedContinue = 60.0
var playerStrengthContinue = 1.0
var playerAttackRangeContinue = 1.0
var playerAttackSpeedContinue = 1.0
var playerHPMaxContinue = 10.0
var evoPointsContinue = 0
var hungerPointsMaxContinue = 25

#Reset Variables: These are the original variables, which the active variables are reset to at the game start.
var playerSpeedReset = 60.0
var playerStrengthReset = 1.0
var playerAttackRangeReset = 1.0
var playerAttackSpeedReset = 1.0
var playerHPMaxReset = 10.0
var evoPointsReset = 0
var hungerPointsMaxReset = 25
