extends CharacterBody2D

@export var tile_size: int = 32 * 4
@export var move_duration: float = 0.1
@export var map_manager: Node
@export var beat_manager: Node

signal beat_miss   # buat di world.gd

var grid_position: Vector2i
var is_moving: bool = false
var beat_active: bool = false
var beat_lock: int = 0


func _ready():
	grid_position = Vector2i(
		round(global_position.x / tile_size),
		round(global_position.y / tile_size)
	)
	
	global_position = grid_to_world(grid_position)
	
	if beat_manager:
		beat_manager.beat.connect(_on_beat)


func _physics_process(delta: float) -> void:
	if is_moving:
		return
	
	var direction := Vector2i.ZERO
	
	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2i.UP
	elif Input.is_action_just_pressed("ui_down"):
		direction = Vector2i.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		direction = Vector2i.RIGHT
	
	if direction == Vector2i.ZERO:
		return
	
	# Kalau tekan di luar beat miss
	if not beat_active:
		handle_miss()
		return
	
	try_move(direction)
	beat_active = false


func _on_beat():
	if beat_lock > 0:
		beat_lock -= 1
		return
	
	beat_active = true
	
	await get_tree().create_timer(0.2).timeout
	
	beat_active = false


func handle_miss():
	beat_lock = 1 #kasihkan delay 1 beat abangku
	emit_signal("beat_miss")


func try_move(direction: Vector2i):
	var target_position = grid_position + direction
	
	
	grid_position = target_position
	move_to_tile(grid_position)
	
	
func move_to_tile(target_grid_pos: Vector2i):
	is_moving = true
	
	var world_pos = grid_to_world(target_grid_pos)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", world_pos, move_duration)
	tween.tween_callback(Callable(self, "_on_move_finished"))
	
	
func _on_move_finished():
	is_moving = false
	
	
func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(
		grid_pos.x * tile_size,
		grid_pos.y * tile_size
	)
