extends EnemyUnit
class_name EnemyTank

@onready var turret_sprite = $TurretSprite
@onready var muzzle_flash= $TurretSprite/MuzzleFlashSprite
@onready var muzzle_flash_timer = $MuzzleFlashTimer
@export var muzzle_flash_delay: float = 0.2

func _ready():
	super._ready()
	muzzle_flash_timer.timeout.connect(_on_muzzle_flash_timeout)

func _on_muzzle_flash_timeout():
	muzzle_flash.hide()

func attack(pos: Vector2):
	super.attack(pos)
	muzzle_flash.show()
	muzzle_flash_timer.start(muzzle_flash_delay)
