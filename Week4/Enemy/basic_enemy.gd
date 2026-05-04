extends Enemy
class_name BasicEnemy


func take_damage(amount: float) -> void:
	super.take_damage(amount) 


func receive_heal(amount: float) -> void:
	super.receive_heal(amount)
	print("Aku heal")
