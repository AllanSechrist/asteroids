extends CharacterBody2D
class_name Ship

@onready var thruster_animation: AnimatedSprite2D = $ThrusterAnimation


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move"):
		thruster_animation.play("Thrust")
	else:
		thruster_animation.play("Idle")
