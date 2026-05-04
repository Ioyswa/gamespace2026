extends CharacterBody2D

@onready var attack_box: Area2D = $AttackBox

const SPEED = 300.0

# Variabel Serangan
var attack_cooldown: float = 0.5 # Waktu tunggu sebelum bisa menyerang lagi
var current_cooldown: float = 0.0
var attack_duration: float = 0.2 # Berapa lama visual serangan bertahan
var is_attacking: bool = false
var last_direction: Vector2 = Vector2.RIGHT # Menyimpan arah hadap terakhir

func _ready() -> void:
	# Pastikan visual attack box tersembunyi saat game dimulai
	attack_box.visible = false

func _physics_process(delta: float) -> void:
	# 1. Menangani Cooldown Timer
	if current_cooldown > 0:
		current_cooldown -= delta
		
		# Sembunyikan visual attack box setelah attack_duration selesai
		if is_attacking and current_cooldown <= (attack_cooldown - attack_duration):
			attack_box.visible = false
			is_attacking = false

	# 2. Menangani Pergerakan dan Arah
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction:
		velocity = direction * SPEED
		last_direction = direction # Simpan arah pergerakan terakhir
		
		# Putar posisi attack_box sesuai arah hadap player
		attack_box.rotation = last_direction.angle()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()
	
	# 3. Menangani Input Serangan
	# Menggunakan ui_accept (biasanya Spasi atau Enter)
	if Input.is_action_just_pressed("ui_accept") and current_cooldown <= 0.0:
		perform_attack()

func perform_attack() -> void:
	current_cooldown = attack_cooldown
	is_attacking = true
	
	attack_box.visible = true
	
	var overlapping_bodies = attack_box.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("Enemies"):
			if body.has_method("take_damage"):
				body.take_damage(20.0)
