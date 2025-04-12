#moving_platform.gd
extends AnimatableBody3D
class_name MovingPlatform

@export_group("Movement")
@export var move_direction: Vector3 = Vector3(0, 0, 0)
@export var speed: float = 1.0
@export var wait_time: float = 0.5

var start_position: Vector3
var end_position: Vector3
var current_direction: int = 1
var is_waiting: bool = false
var wait_timer: float = 0.0
var t: float = 0.0

func _ready():
	start_position = global_position
	end_position = start_position + move_direction

func _physics_process(delta):
	if is_waiting:
		wait_timer += delta
		if wait_timer >= wait_time:
			is_waiting = false
			wait_timer = 0.0
			current_direction *= -1
			t = 0.0
		return
	
	t += delta * speed / move_direction.length()
	t = clamp(t, 0.0, 1.0)
	
	if current_direction > 0:
		global_position = start_position.lerp(end_position, t)
	else:
		global_position = end_position.lerp(start_position, t)
	
	if t >= 1.0:
		global_position = end_position if current_direction > 0 else start_position
		is_waiting = true
		t = 0.0
