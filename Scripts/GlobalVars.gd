extends Node

enum size
{
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3,
	GARGANTUAN = 4
}

enum dinoType
{
	EORAPTOR = 1,
	GUANLONG = 2,
	COELURUS = 3,
	TREX = 4,
	VELOCIRAPTOR = 5,
	ARCHAEOPTERYX = 6
}

# Settings
var isScreenshakeEnabled = true

# Global Variables
const DAMAGE_REDUCTION_MULTIPLIER = 0.5
const DAMAGE_INCREASE_MULTIPLIER = 1.5
const CRITICAL_DAMAGE_MULTIPLIER = 2.0
const ABILITY_PREDATOR_DAMAGE_MULTIPLIER = 1.25
const ABILITY_SCAVENGER_SPEED_MULTIPLIER = 1.25
const ABILITY_SPIT_SPITSPEED = 200.0
const ABILITY_SPIT_SPITDAMAGE = 1.0
const ABILITY_SPIT_SPITDURATION = 1.0
const ABILITY_SPIT_SPITCOOLDOWN = 3.0
const ABILITY_TAILWHIP_DAMAGE_BONUS = 5.0
const ABILITY_TAILWHIP_COOLDOWN = 4.0
const ABILITY_AGGRESSOR_HURTBOX_SCALE_MULTIPLIER = 1.2
const ABILITY_AGGRESSOR_HURTBOX_RANGE_EXTENSION = 10.0
const ABILITY_GROUNDSLAM_SLOW_AMOUNT = 0.2
const ABILITY_GROUNDSLAM_SLOW_TIME = 6.0
const ABILITY_GROUNDSLAM_COOLDOWN = 8.0
const ABILITY_INFECTIOUSBITE_POISON_FREQUENCY = 0.25
const ABILITY_INFECTIOUSBITE_POISON_DAMAGE = 0.5
const ABILITY_INFECTIOUSBITE_POISON_DURATION = 5
const ABILITY_INFECTIOUSBITE_POISON_MAX_STACKS = 5
const ABILITY_APEXDASH_SPEED = 300.0
const ABILITY_APEXDASH_TIME = 0.5
const ABILITY_APEXDASH_COOLDOWN = 4.0
const ABILITY_HEADBUTT_SLOW_AMOUNT = 0.01
const ABILITY_HEADBUTT_SLOW_TIME = 2.0
const ABILITY_HEADBUTT_COOLDOWN = 8.0
var worldWidth = 3200.0
var worldHeight = 1900.0
var currentLevel = 1
var previousType = dinoType.EORAPTOR

#Player Variables
var playerSprintSpeedMultiplier = 1.6
var playerSprintEnergy = 40.0
var playerSprintEnergyMax = 40.0
var playerSize = size.SMALL
var playerSpeed = 60.0
var playerStrength = 1.0
var playerAttackRange = 15.0
var playerAttackSpeed = 1.0
var playerHP = 10.0
var playerHPMax = 10.0
var evoPoints = 0
var hungerPoints = 0
var hungerPointsMax = 5
var killedBy = "Nothing"
var playerType = dinoType.EORAPTOR

#Abilities
var abilityPredator = false
var abilityScavenger = false
var abilitySpit = false

var abilityTailWhip = false
var abilityAggressor = false
var abilityGroundSlam = false

var abilityInfectiousBite = false
var abilityApexPredator = false
var abilityHeadbutt = true

#Reset Variables: These are the original variables, which the active variables are reset to at the game start.
var playerSpeedReset = 60.0
var playerStrengthReset = 1.0
var playerAttackRangeReset = 15.0
var playerAttackSpeedReset = 1.0
var playerHPMaxReset = 10.0
var playerSprintEnergyMaxReset = 40.0
var hungerPointsMaxReset = 5
var playerTypeReset = dinoType.EORAPTOR
