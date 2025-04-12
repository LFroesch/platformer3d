#cannon.gd
extends RotationObject
class_name Cannon

@export_group("Barrel Settings")
@export var barrel_object: NodePath
@export var barrel_tilt_speed: float = 0.5
@export var barrel_tilt_axis: Vector3 = Vector3(1, 0, 0)
@export var barrel_tilt_range: float = 15.0
@export var auto_start_barrel_tilt: bool = true
@export var reverse_barrel_tilt: bool = false

@export_group("Shooting Settings")
@export var auto_shoot: bool = true
@export var shoot_interval: float = 2.0
@export var bullet_speed: float = 20.0
@export var bullet_spawn_point: NodePath

var bullet_scene = preload("res://Scenes/Traps/Cannons/cannon_bullet.tscn")
var barrel_node: Node3D = null
var is_barrel_tilting: bool = false
var current_barrel_tilt: float = 0.0
var barrel_tilt_direction: int = 1
var shoot_timer: Timer = null
var spawn_point: Node3D = null

func _ready() -> void:
	super._ready()
	
	if not barrel_object.is_empty():
		barrel_node = get_node(barrel_object)
	
	if not bullet_spawn_point.is_empty():
		spawn_point = get_node(bullet_spawn_point)
	else:
		spawn_point = barrel_node
	
	shoot_timer = Timer.new()
	shoot_timer.one_shot = false
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shoot_timer)
	
	if auto_start_barrel_tilt and barrel_node:
		start_barrel_tilt()
		
	if auto_shoot:
		start_shooting()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_barrel_tilting and barrel_node:
		var tilt_amount = barrel_tilt_speed * delta * barrel_tilt_direction
		
		if reverse_barrel_tilt:
			tilt_amount = -tilt_amount

		var new_tilt = current_barrel_tilt + tilt_amount
		
		if abs(new_tilt) > deg_to_rad(barrel_tilt_range):
			barrel_tilt_direction = -barrel_tilt_direction
			tilt_amount = barrel_tilt_speed * delta * barrel_tilt_direction
			
			if reverse_barrel_tilt:
				tilt_amount = -tilt_amount
		
		barrel_node.rotate(barrel_tilt_axis.normalized(), tilt_amount)
		current_barrel_tilt += tilt_amount

func start_barrel_tilt() -> void:
	is_barrel_tilting = true
	
func stop_barrel_tilt() -> void:
	is_barrel_tilting = false
	
func toggle_barrel_tilt() -> void:
	is_barrel_tilting = not is_barrel_tilting
	
func set_barrel_tilt_speed(new_speed: float) -> void:
	barrel_tilt_speed = new_speed
	
func reverse_barrel_tilt_direction() -> void:
	reverse_barrel_tilt = not reverse_barrel_tilt

func start_shooting() -> void:
	if shoot_interval > 0:
		shoot_timer.wait_time = shoot_interval
		shoot_timer.start()
	
func stop_shooting() -> void:
	shoot_timer.stop()

func shoot() -> void:
	if not bullet_scene:
		push_error("No bullet scene assigned to cannon")
		return
	if not spawn_point:
		push_error("No spawn point available for bullet")
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = spawn_point.global_position
	var forward_direction: Vector3
	
	if spawn_point:
		forward_direction = spawn_point.global_transform.basis.z.normalized()
	else:
		forward_direction = barrel_node.global_transform.basis.z.normalized()
	
	if bullet is RigidBody3D:
		bullet.linear_velocity = forward_direction * bullet_speed
	elif bullet.has_method("apply_impulse"):
		bullet.apply_impulse(forward_direction * bullet_speed)
	elif bullet.has_method("launch"):
		bullet.launch(forward_direction, bullet_speed)
	elif bullet is Node3D:
		if bullet.has_meta("velocity"):
			bullet.set_meta("velocity", forward_direction * bullet_speed)
		else:
			bullet.set_meta("velocity", forward_direction * bullet_speed)
			push_warning("Added velocity as metadata to bullet, but it may not have code to use it")

func _on_shoot_timer_timeout() -> void:
	shoot()
