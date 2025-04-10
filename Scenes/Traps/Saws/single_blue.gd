#single_blue.gd
extends MovingPlatform

@export_group("Rotation")
@export var target_sawblade: NodePath  # Path to the node to rotate
@export var rotation_axis: Vector3 = Vector3(0, 1, 0)  # Y-axis by default
@export var rotation_speed: float = 5.0
@export var auto_start_rotation: bool = true
@export var reverse_rotation: bool = false

var target_node: Node3D = null
var is_rotating: bool = false

func _ready() -> void:
	super._ready()
	
	if not target_sawblade.is_empty():
		target_node = get_node(target_sawblade)

	if auto_start_rotation and target_node:
		start_rotation()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_rotating and target_node:
		var rotation_amount = rotation_speed * delta
		if reverse_rotation:
			rotation_amount = -rotation_amount
		target_node.rotate(rotation_axis.normalized(), rotation_amount)

func start_rotation() -> void:
	is_rotating = true
	
func stop_rotation() -> void:
	is_rotating = false
	
func toggle_rotation() -> void:
	is_rotating = not is_rotating
	
func set_rotation_speed(new_speed: float) -> void:
	rotation_speed = new_speed
	
func reverse_rotation_direction() -> void:
	reverse_rotation = not reverse_rotation

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("reload_scene"):
		body.reload_scene()
