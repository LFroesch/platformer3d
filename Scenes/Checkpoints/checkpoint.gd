extends MovingPlatform
@export var height_offset: float = 1.0
@export var x_offset: float = 0.0
@export var z_offset: float = 0.5

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var spawn_position = global_position
		spawn_position.y += height_offset
		spawn_position.x += x_offset
		spawn_position.z += z_offset
		CheckpointManager.set_checkpoint(spawn_position)
