extends CharacterBody2D
class_name Ship

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move"):
		print("moving")
		
