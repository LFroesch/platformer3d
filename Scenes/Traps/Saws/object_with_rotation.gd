#object_with_rotation.gd
extends MovingPlatform
class_name RotationObject

@export_group("Rotation")
@export var target_object: NodePath
@export var rotation_axis: Vector3 = Vector3(0, 1, 0)
@export var rotation_speed: float = 5.0
@export var auto_start_rotation: bool = true
@export var reverse_rotation: bool = false
@export var initial_delay: float = 0.0

@export_group("Partial Rotation")
@export_enum("Continuous", "Half Circle", "Quarter Circle", "Eighth Turn") var rotation_type: int = 0
@export var wait_time_between_rotations: float = 0.0
@export var bounce_back: bool = true

var target_node: Node3D = null
var is_rotating: bool = false
var current_rotation_amount: float = 0
var partial_rotation_complete: bool = false
var rotation_timer: Timer = null

func _ready() -> void:
	super._ready()
	
	if not target_object.is_empty():
		target_node = get_node(target_object)
	
	rotation_timer = Timer.new()
	rotation_timer.one_shot = true
	rotation_timer.timeout.connect(_on_rotation_timer_timeout)
	add_child(rotation_timer)
	
	if auto_start_rotation and target_node:
		await get_tree().create_timer(initial_delay).timeout
		start_rotation()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if is_rotating and target_node and not partial_rotation_complete:
		var rotation_amount = rotation_speed * delta
		if reverse_rotation:
			rotation_amount = -rotation_amount
		
		if rotation_type > 0:
			current_rotation_amount += abs(rotation_amount)
			var target_rotation
			
			if rotation_type == 1:
				target_rotation = PI
			elif rotation_type == 2:
				target_rotation = PI / 2
			else:
				target_rotation = PI / 4
			
			if current_rotation_amount >= target_rotation:
				var excess = current_rotation_amount - target_rotation
				var final_rotation = rotation_amount
				if abs(rotation_amount) > excess:
					final_rotation = rotation_amount - (sign(rotation_amount) * excess)
				
				target_node.rotate(rotation_axis.normalized(), final_rotation)
				partial_rotation_complete = true
				
				if bounce_back:
					reverse_rotation = not reverse_rotation
				
				if wait_time_between_rotations > 0:
					rotation_timer.start(wait_time_between_rotations)
				else:
					_reset_rotation_cycle()
			else:
				target_node.rotate(rotation_axis.normalized(), rotation_amount)
		else:
			target_node.rotate(rotation_axis.normalized(), rotation_amount)

func _on_rotation_timer_timeout() -> void:
	_reset_rotation_cycle()

func _reset_rotation_cycle() -> void:
	current_rotation_amount = 0
	partial_rotation_complete = false

func start_rotation() -> void:
	is_rotating = true
	partial_rotation_complete = false
	current_rotation_amount = 0
	
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
