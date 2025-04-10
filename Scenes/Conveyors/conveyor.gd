extends Node3D

@export var conveyor_speed = 0.5
@export var conveyor_direction = Vector3(0, 0, -1)  # Default direction - adjust as needed

var tread_material: ShaderMaterial
var bodies_on_conveyor = []

func _ready():
	for child in get_children():
		if child is MeshInstance3D:
			tread_material = child.get_surface_override_material(1)
			break
	
	if tread_material:
		tread_material.set_shader_parameter("scroll_speed", conveyor_speed)
	var conveyor_area = find_child("ConveyorArea")
	conveyor_area.connect("body_entered", _on_conveyor_area_body_entered)
	conveyor_area.connect("body_exited", _on_conveyor_area_body_exited)
	
func _process(_delta):
	if tread_material:
		tread_material.set_shader_parameter("scroll_speed", conveyor_speed)
		
func _physics_process(_delta):
	# Apply force to all bodies on the conveyor
	for body in bodies_on_conveyor:
		if body is CharacterBody3D:
			# Apply conveyor effect
			var conveyor_effect = conveyor_direction.normalized() * conveyor_speed * 5.7
			body.velocity.x = conveyor_effect.x
			body.velocity.z = conveyor_effect.z

func _on_conveyor_area_body_entered(body):
	if body is CharacterBody3D and not body in bodies_on_conveyor:
		bodies_on_conveyor.append(body)

func _on_conveyor_area_body_exited(body):
	if body in bodies_on_conveyor:
		bodies_on_conveyor.erase(body)
