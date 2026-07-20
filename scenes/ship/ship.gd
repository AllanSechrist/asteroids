extends CharacterBody2D
class_name Ship

enum ShipState { ALIVE, DEAD, INVULNERABLE }

@export_category("Ship Stats")
@export var turn_speed := 5.0
@export var thrust_speed := 200.0
@export var drag := 5.0
@export var max_speed := 300.0
@export var respawn_time := 1.0
@export var invulernability_length := 2.0


@export_category("Child Scenes")
@export var bullet_scene: PackedScene

@onready var muzzle: Marker2D = $Muzzle
@onready var thruster_animation: AnimatedSprite2D = $ThrusterAnimation
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var invulnerability_timer: Timer = $InvulnerabilityTimer

var state: ShipState = ShipState.ALIVE

signal death


func _physics_process(delta: float) -> void:
	match state:
		ShipState.ALIVE, ShipState.INVULNERABLE:
			handle_input(delta)
			move_and_slide()
		ShipState.DEAD:
			velocity = Vector2.ZERO
	wrap_screen()
	
func handle_input(delta: float) -> void:
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
		
	if Input.is_action_just_pressed("fire"):
		fire()
	
	if Input.is_action_just_pressed("clear_debug"):
		var asteroids = get_tree().get_nodes_in_group("Asteroids")
		for asteroid in asteroids:
			asteroid.queue_free()
	
func fire() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.global_rotation = global_rotation
	get_tree().current_scene.add_child(bullet)
	
func _on_hit() -> void:
	if state != ShipState.ALIVE:
		pass
	state = ShipState.DEAD
	velocity = Vector2.ZERO
	collision_shape_2d.set_deferred("disabled", true)
	death.emit()	
	await get_tree().create_timer(respawn_time).timeout
	_respawn()
	
func _respawn() -> void:
	global_position = get_viewport_rect().size / 2
	rotation = 0
	collision_shape_2d.set_deferred("disabled", false)
	state = ShipState.INVULNERABLE
	invulnerability_timer.start(invulernability_length)

func _on_invulnerability_timer_timeout() -> void:
	state = ShipState.ALIVE
	
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
