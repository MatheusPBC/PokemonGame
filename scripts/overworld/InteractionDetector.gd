extends Area2D


func try_interact() -> void:
	for area in get_overlapping_areas():
		if area.has_method("interact"):
			area.call("interact")
			return

	for body in get_overlapping_bodies():
		if body.has_method("interact"):
			body.call("interact")
			return
