extends Node2D



func _on_pad_body_entered(body: Node2D) -> void:
	if body.has_method("toggle_gravity"):
		body.toggle_gravity()
