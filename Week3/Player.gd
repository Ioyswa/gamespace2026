extends CharacterBody2D

var checkpoint_position: Vector2i

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 100

var wait_time: float = 1.0
var is_waiting: bool = false
var spawn_point: Sprite2D

@onready var label = get_parent().get_node("CanvasLayer").get_node("Label")

func _ready() -> void:
	checkpoint_position = get_parent().get_node("DefaultSpawnPosition").global_position
	spawn_point = get_parent().get_node("SpawnPoint")
	spawn_point.global_position = checkpoint_position
	$ProgressBar.value = health

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	if Input.is_action_just_pressed("checkpoint"):
		checkpoint_position = global_position
		spawn_point.position = checkpoint_position

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func hit_by_spike():
	if not is_waiting:
		health -= 25
		$ProgressBar.value = health
		is_waiting = true
		get_tree().create_timer(wait_time).timeout
		is_waiting = false
	
	
	if health <= 0:
		label.show()
	
	#position = checkpoint_position
