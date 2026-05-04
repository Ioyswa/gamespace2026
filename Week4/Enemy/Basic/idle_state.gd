extends State
class_name EnemyIdleState

@export var enemy: BasicEnemy
@export var detection_range: float = 300.0 # Jarak pandang musuh untuk mulai mengejar

var target_player: Node2D = null

func enter() -> void:
	# Berhenti bergerak saat masuk mode idle
	enemy.velocity = Vector2.ZERO
	
	# Mencari referensi player saat state dimulai
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		target_player = players[0]

func physics_update(_delta: float) -> void:
	# Jika player tidak ada atau sudah hancur, abaikan pengecekan
	if not is_instance_valid(target_player):
		return
		
	# Hitung jarak antara musuh dan player
	var distance_to_player = enemy.global_position.distance_to(target_player.global_position)
	
	# Jika player masuk ke dalam jangkauan deteksi, pindah ke ChaseState
	if distance_to_player <= detection_range:
		# Pastikan nama string "chasestate" sesuai dengan key yang ada di dictionary StateMachine Anda
		state_transition.emit(self, "chasestate")
