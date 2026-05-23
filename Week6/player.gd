extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const PUSH_FORCE = 20.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var push_dir = -collision.get_normal()
			push_dir.y = 0 
			collider.apply_central_impulse(push_dir.normalized() * PUSH_FORCE)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Objek"):
		body.gravity_scale = -1.0
