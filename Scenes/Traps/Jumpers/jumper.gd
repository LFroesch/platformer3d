extends MovingPlatform
class_name JumpPlatform

@export var jump_force: float = 50.0
@export var jump_direction: Vector3 = Vector3(0, 1, 0)  # Default: straight up
@onready var jump_area: Area3D = $button_base_blue2/button_base_blue/StaticBody3D/Area3D

func _ready():
	super._ready()
	jump_area.body_entered.connect(_on_jump_area_body_entered)
	jump_direction = jump_direction.normalized()

func _on_jump_area_body_entered(body):
	if body is CharacterBody3D:
		if "velocity" in body:
			body.velocity = jump_direction * jump_force
