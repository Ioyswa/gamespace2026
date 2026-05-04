extends State

# Referensi spesifik ke HealerEnemy
@export var enemy: HealerEnemy
@export var heal_amount: float = 25.0

var heal_timer: float = 0.0

func enter() -> void:
	heal_timer = 0.0
	enemy.velocity = Vector2.ZERO
	
	if enemy.has_node("HealArea"):
		enemy.get_node("HealArea").visible = true

func update(delta: float) -> void:
	heal_timer += delta
	
	if heal_timer >= 2.0:
		execute_heal()
		state_transition.emit(self, "idlestate")

func execute_heal() -> void:
	if not enemy.has_node("HealArea"):
		return
		
	var heal_area = enemy.get_node("HealArea") as Area2D
	
	var overlapping_bodies = heal_area.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("Enemies") and body != enemy:
			if body.has_method("receive_heal"):
				body.receive_heal(heal_amount)

func exit() -> void:
	if enemy.has_node("HealArea"):
		enemy.get_node("HealArea").visible = false
