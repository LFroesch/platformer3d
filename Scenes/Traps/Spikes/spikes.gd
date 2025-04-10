# spikes.gd
extends MovingPlatform

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("detected")
	if body.has_method("reload_scene"):
		body.reload_scene()
