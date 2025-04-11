# collectibles.gd
extends MovingPlatform

class_name Collectible

# Properties for floating animation
@export var float_height: float = 0.3
@export var float_speed: float = 2.0
@export var rotation_speed: float = 1.0
@export var pickup_enabled: bool = true

# Internal variables for floating effect
var base_y_position: float = 0.0
var time: float = 0.0

func _ready():
	super._ready()
	base_y_position = global_position.y
	add_to_group("collectibles")

func _physics_process(delta):
	super._physics_process(delta)

	if float_height > 0:
		time += delta
		var current_pos = global_position
		current_pos.y += sin(time * float_speed) * float_height
		global_position = current_pos
	
	if rotation_speed > 0:
		rotate_y(rotation_speed * delta)

func collect():
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		collect()
