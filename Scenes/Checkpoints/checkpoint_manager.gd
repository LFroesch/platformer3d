#checkpoint_manager.gd (autoload)
extends Node

var respawn_position: Vector3 = Vector3.ZERO
var respawn_direction: float = 0.0
var is_respawning: bool = false

func _ready():
	get_tree().root.connect("ready", _on_scene_changed)

func set_checkpoint(position: Vector3, direction: float = 0.0) -> void:
	respawn_position = position
	respawn_direction = direction
	print("Checkpoint set at: ", position, " facing: ", direction)

func respawn() -> void:
	if is_respawning:
		return
	is_respawning = true
	StatsManager.record_death()
	get_tree().call_group("bullets", "queue_free")
	# Get the current scene root
	var current_scene = get_tree().current_scene
	
	# Call fade_out on the current scene
	if current_scene.has_method("fade_out"):
		current_scene.fade_out()
	
	# Create a timer for deferred scene reload
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	timer.timeout.connect(func():
		get_tree().reload_current_scene.call_deferred()
		is_respawning = false
		timer.queue_free()
	)

func _on_scene_changed():
	# Wait for all nodes to be ready
	await get_tree().process_frame
	# Let CollectibleManager know the scene has changed
	CollectibleManager.register_all_collectibles()
