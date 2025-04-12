#cannon_bullet.gd
extends Area3D
class_name CannonBullet

@export var speed: float = 20.0
@export var lifetime: float = 3.0
@export var damage: int = 1

var velocity: Vector3 = Vector3.ZERO
var life_timer: Timer

func _ready() -> void:
	life_timer = Timer.new()
	life_timer.one_shot = true
	life_timer.wait_time = lifetime
	life_timer.timeout.connect(func(): queue_free())
	add_child(life_timer)
	life_timer.start()

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func launch(direction: Vector3, launch_speed: float = -1.0) -> void:
	if launch_speed > 0:
		speed = launch_speed
	velocity = direction.normalized() * speed
	look_at(global_position + direction)
	rotate_object_local(Vector3.UP, PI)
	
func _on_body_entered(body: Node3D) -> void:
	if body.has_method("reload_scene"):
		body.reload_scene()
		queue_free()
