extends RigidBody3D

@export var damping: float = 0.5

# This method will be called from the player to apply an impulse with custom damping
func knock(normal: Vector3) -> void:
	apply_central_impulse(normal * damping)

func free() -> void:
	queue_free()
