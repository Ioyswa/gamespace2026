extends State
class_name HealerIdleState

@export var enemy: HealerEnemy
@export var follow_distance: float = 200.0 # Jarak maksimal sebelum healer mulai mengejar teman
@export var stop_distance: float = 80.0    # Jarak berhenti agar healer tidak menabrak temannya

var target_ally: Node2D = null

func enter() -> void:
	target_ally = get_nearest_ally()

func physics_update(_delta: float) -> void:
	if not is_instance_valid(target_ally):
		enemy.velocity = Vector2.ZERO
		target_ally = get_nearest_ally() # Coba cari lagi
		return

	# Hitung jarak ke teman terdekat
	var distance_to_ally = enemy.global_position.distance_to(target_ally.global_position)

	# Jika teman terlalu jauh, bergerak mendekati teman
	if distance_to_ally > follow_distance:
		var direction = enemy.global_position.direction_to(target_ally.global_position)
		enemy.velocity = direction * enemy.speed
		enemy.move_and_slide()
		
	# Jika jarak sudah ideal (tidak terlalu jauh, tidak terlalu dekat), berhenti
	elif distance_to_ally < stop_distance:
		enemy.velocity = Vector2.ZERO

	# Opsional: Di sini Anda bisa menambahkan logika transisi
	if target_ally.health < target_ally.max_health:
		state_transition.emit(self, "healstate")

# Fungsi pembantu untuk mencari teman terdekat dari grup "enemies"
func get_nearest_ally() -> Node2D:
	var all_enemies = get_tree().get_nodes_in_group("Enemies")
	var nearest = null
	var min_distance = INF # Set ke jarak tidak terhingga di awal

	for ally in all_enemies:
		# Pastikan healer tidak menargetkan dirinya sendiri sebagai teman
		if ally != enemy:
			var dist = enemy.global_position.distance_to(ally.global_position)
			if dist < min_distance:
				min_distance = dist
				nearest = ally

	return nearest
