#moving_platform.gd
extends AnimatableBody3D
class_name MovingPlatform

# Movement parameters you can set in the inspector
@export var move_direction: Vector3 = Vector3(0, 0, 0)  # Direction and distance
@export var speed: float = 1.0  # Units per second
@export var wait_time: float = 0.5  # Time to wait at endpoints in seconds

# Internal variables
var start_position: Vector3
var end_position: Vector3
var current_direction: int = 1
var is_waiting: bool = false
var wait_timer: float = 0.0
var t: float = 0.0  # Interpolation parameter

func _ready():
	# Store starting position
	start_position = global_position
	# Calculate end position
	end_position = start_position + move_direction

func _physics_process(delta):
	if is_waiting:
		# Handle waiting at endpoints
		wait_timer += delta
		if wait_timer >= wait_time:
			is_waiting = false
			wait_timer = 0.0
			current_direction *= -1  # Reverse direction
			# Reset interpolation parameter when changing direction
			t = 0.0
		return
	
	# Use interpolation for smoother movement
	t += delta * speed / move_direction.length()
	t = clamp(t, 0.0, 1.0)
	
	if current_direction > 0:
		global_position = start_position.lerp(end_position, t)
	else:
		global_position = end_position.lerp(start_position, t)
	
	# Check if we've reached an endpoint
	if t >= 1.0:
		# Snap to endpoint exactly
		global_position = end_position if current_direction > 0 else start_position
		is_waiting = true
		t = 0.0  # Reset interpolation parameter
