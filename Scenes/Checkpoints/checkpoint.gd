#checkpoint.gd
extends MovingPlatform
@export var checkpoint_number: int = 0  # Add this to track checkpoint order
@export_group("Checkpoint")
@export var height_offset: float = 1.0
@export var x_offset: float = 0.0
@export var z_offset: float = 0.5

@export var facing_direction: float = 0.0

@export_group("Finish Line")
@export var target_level: String = ''
@export var target_location = Vector3(0,2,0)

#checkpoints
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var spawn_position = global_position
		spawn_position.y += height_offset
		spawn_position.x += x_offset
		spawn_position.z += z_offset
		CheckpointManager.set_checkpoint(spawn_position, facing_direction)
		StatsManager.set_checkpoint(checkpoint_number)
		
#finishlines
func _on_finish_line_body_entered(_body: Node3D) -> void:
	var current_scene = get_tree().current_scene
	current_scene.switch_level(target_level, target_location)
	if target_level != '':
		StatsManager.increase_level()
	StatsManager.set_checkpoint(0)
