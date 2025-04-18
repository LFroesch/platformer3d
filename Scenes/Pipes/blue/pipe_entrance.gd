extends MovingPlatform

@export_group("Pipe Teleport")
@export var target_level: String = ''
@export var target_location = Vector3(0,2,0)
@export var debug_only: bool = false

@onready var area_3d: Area3D = $pipe_end_blue2/pipe_end_blue/StaticBody3D/Area3D


func _ready() -> void:
	super._ready()
	area_3d.body_entered.connect(_on_area_3d_body_entered)
	if debug_only and not OS.has_feature("editor"):
		# Hide the platform
		visible = false
		# Disable collision
		area_3d.monitoring = false
		area_3d.monitorable = false
		_disable_all_collision_shapes(self)

func _disable_all_collision_shapes(node):
	# Recursively find and disable all collision shapes
	for child in node.get_children():
		if child is CollisionShape3D or child is CollisionPolygon3D:
			child.disabled = true
		
		# Recurse through children
		if child.get_child_count() > 0:
			_disable_all_collision_shapes(child)

func _on_area_3d_body_entered(_body: Node3D) -> void:
	var current_scene = get_tree().current_scene
	current_scene.switch_level(target_level, target_location)
