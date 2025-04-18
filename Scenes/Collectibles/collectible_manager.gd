# collectible_manager.gd
extends Node

# Signal emitted when game is reset
signal game_reset

# Store unique IDs of collected collectibles
var collected_ids = {}

# Called when the scene changes to register all collectibles
func register_all_collectibles():
	var collectibles = get_tree().get_nodes_in_group("collectibles")
	for collectible in collectibles:
		# If this collectible was previously collected, mark it as collected
		if collected_ids.has(collectible.get_instance_id()) or collected_ids.has(collectible.name):
			collectible.apply_collected_state()

func register_collected(collectible):
	# Store either the instance ID or the name as a unique identifier
	var id = collectible.name if collectible.name != "" else collectible.get_instance_id()
	collected_ids[id] = true

func reset_collectibles():
	# Clear the collected list
	collected_ids.clear()
	# Emit signal to reset all collectibles
	emit_signal("game_reset")
