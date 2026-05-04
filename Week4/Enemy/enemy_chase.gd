extends State
class_name EnemyChaseState

@export var enemy: BasicEnemy

# Menyimpan referensi ke player
var target_player: CharacterBody2D = null

func enter() -> void:
	# Cari player saat masuk state ini
	# Mengasumsikan hanya ada satu node di dalam grup "player"
	var players = get_tree().get_nodes_in_group("Player")
	print(players)
	if players.size() > 0:
		target_player = players[0]
	else:
		push_warning("EnemyChase: Player tidak ditemukan di scene!")

func physics_update(delta: float) -> void:
	# Jika player tidak ada atau sudah hancur (misal: game over), kembali ke idle
	if not is_instance_valid(target_player):
		state_transition.emit(self, "idlestate")
		return

	# Hitung jarak dan arah
	var jarak_ke_player = enemy.global_position.distance_to(target_player.global_position)
	var arah_ke_player = enemy.global_position.direction_to(target_player.global_position)

	# Bergerak menuju player
	enemy.velocity = arah_ke_player * enemy.speed
	enemy.move_and_slide()

	# Transisi ke attack state jika sudah cukup dekat
	if jarak_ke_player < 50.0:
		state_transition.emit(self, "attackstate")
