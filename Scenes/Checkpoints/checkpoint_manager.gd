extends Node

var respawn_position: Vector3 = Vector3.ZERO

func set_checkpoint(position: Vector3) -> void:
	respawn_position = position
	print("Checkpoint set at: ", position)
