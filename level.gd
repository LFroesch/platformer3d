extends Node3D

var pause_menu_scene: PackedScene = preload("res://Scenes/UI/simpe_pause_menu.tscn")
var fade_rect: ColorRect
const scenes = {
	'level1': "res://Scenes/Levels/level_1.tscn"
}
# Static variable to store where we're going
static var next_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	var pause_menu = pause_menu_scene.instantiate()
	add_child(pause_menu)
	
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 10
	add_child(canvas_layer)
	
	fade_rect = ColorRect.new()
	fade_rect.color = Color(0, 0, 0, 1) # Start black
	fade_rect.anchor_right = 1.0
	fade_rect.anchor_bottom = 1.0
	fade_rect.grow_horizontal = Control.GROW_DIRECTION_BOTH
	fade_rect.grow_vertical = Control.GROW_DIRECTION_BOTH
	canvas_layer.add_child(fade_rect)
	
	call_deferred("fade_in")

func fade_out():
	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 0.5)
	return tween  # Make sure to return the tween

func fade_in():
	fade_rect.color = Color(0, 0, 0, 1)  # Start black
	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 0.5)

func switch_level(target: String, pos: Vector3):
	# Store where the player should appear
	next_position = pos
	
	# Fade out to black
	fade_out()
	await get_tree().create_timer(0.5).timeout
	fade_rect.color = Color(0, 0, 0, 1)
	get_tree().change_scene_to_file(scenes[target])
