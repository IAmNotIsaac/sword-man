extends Spatial
class_name Enemy


export var health := 1


func damage(amount : int) -> void:
	health -= amount
	health = max(0, health)
