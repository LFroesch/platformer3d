#double_blue.gd
extends MovingPlatform

@export_group("Rotation")
@export var target_sawblade: NodePath  # Path to the node to rotate
@export var target_sawblade2: NodePath  # Path to the node to rotate
@export var rotation_axis: Vector3 = Vector3(0, 1, 0)  # Y-axis by default
@export var rotation_speed: float = 5.0

@export var auto_start: bool = true
@export var reverse_direction: bool = false

var target_node: Node3D = null
var target_node2: Node3D = null
var is_rotating: bool = false

func _ready() -> void:
	super._ready()
	if not target_sawblade.is_empty():
		target_node = get_node(target_sawblade)
	if not target_sawblade2.is_empty():
		target_node2 = get_node(target_sawblade2)
		
	if auto_start and target_node:
		start_rotation()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if is_rotating and target_node:
		var rotation_amount = rotation_speed * delta
		if reverse_direction:
			rotation_amount = -rotation_amount
			
		target_node.rotate(rotation_axis.normalized(), rotation_amount)
		target_node2.rotate(rotation_axis.normalized(), rotation_amount)

func start_rotation() -> void:
	is_rotating = true
	
func stop_rotation() -> void:
	is_rotating = false
	
func toggle_rotation() -> void:
	is_rotating = not is_rotating
	
func set_speed(new_speed: float) -> void:
	rotation_speed = new_speed
	
func reverse() -> void:
	reverse_direction = not reverse_direction

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("reload_scene"):
		body.reload_scene()
