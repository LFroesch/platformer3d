extends MovingPlatform
class_name JumpPlatform

@export var jump_force: float = 50.0
@export var jump_direction: Vector3 = Vector3(0, 1, 0)
@export var debug_only: bool = false

@onready var jump_area: Area3D = $button_base_blue2/button_base_blue/StaticBody3D/Area3D

func _ready():
	super._ready()
	jump_area.body_entered.connect(_on_jump_area_body_entered)
	jump_direction = jump_direction.normalized()
	
	if debug_only and not OS.has_feature("editor"):
		# Hide the platform
		visible = false
		# Disable collision
		jump_area.monitoring = false
		jump_area.monitorable = false
		_disable_all_collision_shapes(self)

func _disable_all_collision_shapes(node):
	# Recursively find and disable all collision shapes
	for child in node.get_children():
		if child is CollisionShape3D or child is CollisionPolygon3D:
			child.disabled = true
		
		# Recurse through children
		if child.get_child_count() > 0:
			_disable_all_collision_shapes(child)
			
func _on_jump_area_body_entered(body):
	if body is CharacterBody3D:
		if "velocity" in body:
			body.velocity = jump_direction * jump_force
