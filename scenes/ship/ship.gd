extends CharacterBody2D
class_name Ship

@export var turn_speed := 5.0
@export var thrust_speed := 200.0
@export var drag := 5.0
@export var max_speed := 300.0


@onready var thruster_animation: AnimatedSprite2D = $ThrusterAnimation
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move"):
		var forward_direction = Vector2.RIGHT.rotated(rotation)
		velocity += forward_direction * thrust_speed * delta
		velocity = velocity.limit_length(max_speed)
		thruster_animation.play("Thrust")
	else:
		thruster_animation.play("Idle")
	position += velocity * delta
	
	if Input.is_action_pressed("turn_left"):
		rotate(-turn_speed * delta)
	if Input.is_action_pressed("turn_right"):
		rotate(turn_speed * delta)
		
	wrap_screen()
	move_and_slide()
	
func wrap_screen() -> void:
	var screen_size = get_viewport_rect().size
	var radius = collision_shape_2d.shape.radius
	
	if position.x < -radius:
		position.x = screen_size.x + radius
	elif position.x > screen_size.x + radius:
		position.x = -radius
		
	if position.y < -radius:
		position.y = screen_size.y + radius
	elif position.y > screen_size.y + radius:
		position.y = -radius
