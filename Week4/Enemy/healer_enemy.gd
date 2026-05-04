extends Enemy
class_name HealerEnemy

func take_damage(amount: float) -> void:
	# Panggil fungsi take_damage asli dari Enemy untuk tetap mengurangi health
	super.take_damage(amount) 
	
