# collectibles.gd
extends MovingPlatform

class_name Collectible

enum CollectibleType {
	STAR = 1,
	HEART = 2,
	DIAMOND = 3,
	POWER = 4
}

# Export the type as an enum
@export var collectible_type: CollectibleType = CollectibleType.STAR

# Properties for floating animation
@export var float_height: float = 0.3
@export var float_speed: float = 2.0
@export var rotation_speed: float = 1.0
@export var pickup_enabled: bool = true

# Internal variables for floating effect
var base_y_position: float = 0.0
var time: float = 0.0
var collected: bool = false

func _ready():
	super._ready()
	base_y_position = global_position.y
	add_to_group("collectibles")
	call_deferred("check_collected_state")

func check_collected_state():
	# Wait for all nodes to be ready
	await get_tree().process_frame
	
	var id
	if name != "":
		id = name
	else:
		id = str(get_instance_id())
		
	if CollectibleManager.collected_ids.has(id):
		apply_collected_state()

func apply_collected_state():
	collected = true
	visible = false
	call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)

func _physics_process(delta):
	super._physics_process(delta)
	add_to_group("collectibles")
	if float_height > 0:
		time += delta
		var current_pos = global_position
		current_pos.y += sin(time * float_speed) * float_height
		global_position = current_pos
	
	if rotation_speed > 0:
		rotate_y(rotation_speed * delta)

func collect():
	# Call different methods based on the type
	match collectible_type:
		CollectibleType.STAR:
			collect_star()
		CollectibleType.HEART:
			collect_heart()
		CollectibleType.DIAMOND:
			collect_diamond()
		CollectibleType.POWER:
			collect_power()
	CollectibleManager.register_collected(self)
	apply_collected_state()

func collect_star():
	# Add your star collection logic here
	print("Star collected!")
	StatsManager.increase_modifier(1.0)

func collect_heart():
	# Add your heart collection logic here
	print("Heart collected!")

func collect_diamond():
	# Add your diamond collection logic here
	print("Diamond collected!")

func collect_power():
	# Add your power collection logic here
	print("Power collected!")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		collect()
