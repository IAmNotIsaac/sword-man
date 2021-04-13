extends Enemy


func _physics_process(delta : float) -> void:
	translation.z += 5 * delta


func knockback(vigor : float) -> void:
	translation.z -= 5 * (vigor / 100.0)
	damage(1 * (vigor / 100.0))
