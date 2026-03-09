#world.gd
extends Node2D

@export var camera: Camera2D
@export var flash_rect: ColorRect
@export var player: Node

var shake_strength: float = 0.0


func _ready():
	player.beat_miss.connect(_on_player_miss)


func _process(delta):
	if shake_strength > 0:
		camera.offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake_strength = lerp(shake_strength, 0.0, 8 * delta)
	else:
		camera.offset = Vector2.ZERO


func _on_player_miss():
	do_screenshake()
	do_red_flash()


func do_screenshake():
	shake_strength = 12.0


func do_red_flash():
	flash_rect.modulate.a = 0.6
	
	var tween = create_tween()
	tween.tween_property(flash_rect, "modulate:a", 0.0, 0.25)
