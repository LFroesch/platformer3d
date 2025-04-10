#object_with_rotation.gd
extends MovingPlatform

@export_group("Rotation")
@export var target_object: NodePath  # Path to the node to rotate
@export var rotation_axis: Vector3 = Vector3(0, 1, 0)  # Y-axis by default
@export var rotation_speed: float = 5.0
@export var auto_start_rotation: bool = true
@export var reverse_rotation: bool = false
@export var initial_delay: float = 0.0

@export_group("Partial Rotation")
@export_enum("Continuous", "Half Circle", "Quarter Circle") var rotation_type: int = 0
@export var wait_time_between_rotations: float = 0.0
@export var bounce_back: bool = true  # Whether to reverse direction after partial rotation

var target_node: Node3D = null
var is_rotating: bool = false
var current_rotation_amount: float = 0
var partial_rotation_complete: bool = false
var rotation_timer: Timer = null

func _ready() -> void:
	super._ready()
	
	if not target_object.is_empty():
		target_node = get_node(target_object)
	
	# Set up timer for wait between rotations
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
		
		# For partial rotations, we need to track how far we've rotated
		if rotation_type > 0:  # Half or Quarter circle
			current_rotation_amount += abs(rotation_amount)
			var target_rotation
			
			# Set target rotation based on rotation type
			if rotation_type == 1:  # Half circle
				target_rotation = PI  # 180 degrees
			else:  # Quarter circle
				target_rotation = PI / 2  # 90 degrees
			
			# Check if we've reached or exceeded the target rotation
			if current_rotation_amount >= target_rotation:
				# Calculate how much we've exceeded by
				var excess = current_rotation_amount - target_rotation
				# Adjust the rotation amount for this frame
				var final_rotation = rotation_amount
				if abs(rotation_amount) > excess:
					final_rotation = rotation_amount - (sign(rotation_amount) * excess)
				
				target_node.rotate(rotation_axis.normalized(), final_rotation)
				partial_rotation_complete = true
				
				if bounce_back:
					reverse_rotation = not reverse_rotation
				
				# Start the wait timer
				if wait_time_between_rotations > 0:
					rotation_timer.start(wait_time_between_rotations)
				else:
					_reset_rotation_cycle()
			else:
				# Normal rotation if we haven't reached the target yet
				target_node.rotate(rotation_axis.normalized(), rotation_amount)
		else:
			# Continuous rotation (original behavior)
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
