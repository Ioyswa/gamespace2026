extends CharacterBody2D
class_name Enemy

@export var health: float = 100.0
@export var max_health: float = 100.0
@export var speed: float = 5.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# --- Fungsi yang sudah ada (take_damage) ---
func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		queue_free()

func receive_heal(amount: float) -> void:
	health += amount
	if health > max_health:
		health = max_health
	
	flash_green()

func flash_green() -> void:
	if has_node("Sprite2D"):
		var sprite = $Sprite2D
		sprite.modulate = Color.GREEN
		
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.5)
