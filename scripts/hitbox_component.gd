extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent

#func damage(attack: Attack):
func damage(amount: float):
	print(get_parent().name)
	if health_component:
		health_component.damage(amount)
	else:
		print("No health component")
