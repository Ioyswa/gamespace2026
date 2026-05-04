extends Node2D

var spawn_location: Vector2

@export var bullet_scene: PackedScene = null


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				spawn_location = get_global_mouse_position()
				var bullet = bullet_scene.instantiate()
				bullet.global_position = spawn_location; bullet.global_position.y -= 400
				add_child(bullet)
