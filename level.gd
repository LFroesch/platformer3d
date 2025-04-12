extends Node3D

var fade_rect: ColorRect

func _ready() -> void:
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	fade_rect = ColorRect.new()
	fade_rect.color = Color(0, 0, 0, 0) # Start transparent
	fade_rect.anchor_right = 1.0
	fade_rect.anchor_bottom = 1.0
	fade_rect.grow_horizontal = Control.GROW_DIRECTION_BOTH
	fade_rect.grow_vertical = Control.GROW_DIRECTION_BOTH
	canvas_layer.add_child(fade_rect)
	
	call_deferred("fade_in")

func fade_out():
	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 0.5)

func fade_in():
	fade_rect.color = Color(0, 0, 0, 1)  # Start black
	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 0.5)
