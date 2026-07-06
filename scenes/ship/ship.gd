extends CharacterBody2D
class_name Ship

@export var turn_speed := 0.05
@export var thrust_speed := 50.0
@export var drag := 5.0 

@onready var thruster_animation: AnimatedSprite2D = $ThrusterAnimation

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move"):
		thruster_animation.play("Thrust")
	else:
		thruster_animation.play("Idle")
	
	if Input.is_action_pressed("turn_left"):
		rotate(-turn_speed)
	if Input.is_action_pressed("turn_right"):
		rotate(turn_speed)
