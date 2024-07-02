extends Node

enum Team { PLAYER, ENEMY }
enum UnitType { AIR, GROUND }

const PhysicsLayers = {
	"world": 1,
	"player_units": 2,
	"player_projectiles": 3,
	"enemy_units": 2,
	"enemy_projectiles": 3,
}