# player.gd
extends CharacterBody3D

@export var jump_height : float = 5.0
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak) * -1.0
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent) * -1.0

@export var base_speed := 4.5
@export var run_speed := 8.0
var speed_modifier := 1.0
var movement_input := Vector2.ZERO

@onready var camera = $CameraController/Camera3D

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	move_and_slide()
	
func move_logic(delta) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	var vel_2d = Vector2(velocity.x, velocity.z)
	var is_running: bool = Input.is_action_pressed("run")
	
	if movement_input != Vector2.ZERO:
		var speed = run_speed if is_running else base_speed
		var target_vel = Vector2(movement_input.x * speed, movement_input.y * speed) * speed_modifier
		vel_2d = vel_2d.lerp(target_vel, 0.8) # Adjust between .3-1.0 for snappier adjusting
	else:
		vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * 5.0 * delta)
		
	velocity.x = vel_2d.x
	velocity.z = vel_2d.y
func jump_logic(delta) -> void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("menu"):
		reload_scene()

func _on_area_3d_body_entered(body: Node3D) -> void:
	reload_scene()

func reload_scene() -> void:
	var parent = get_parent()
	parent.fade_out()
	
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	timer.timeout.connect(func(): 
		get_tree().reload_current_scene.call_deferred()
		timer.queue_free()
	)
