extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent

#func damage(attack: Attack):
func damage(amount: float):
	if health_component:
		health_component.damage(amount)
	else:
		push_warning("No health component defined")
