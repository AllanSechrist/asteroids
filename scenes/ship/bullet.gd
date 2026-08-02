extends Area2D
class_name Bullet

enum Source { PLAYER, ENEMY }

@export var bullet_speed := 800.0
@export var bullet_lifetime := 1.5
@export var bullet_fx_scene: PackedScene
@export var source := Source.PLAYER

@onready var bullet_timer: Timer = $BulletTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var velocity := Vector2.ZERO
var fx: CPUParticles2D

signal destroyed

func _ready() -> void:
	match source:
		Source.PLAYER:
			set_collision_layer_value(4, true) # player bullet
			set_collision_mask_value(2, true) # Asteroid
			set_collision_mask_value(3, true) # UFO
		Source.ENEMY:
			set_collision_layer_value(5, true) # Enemy Bullet
			set_collision_mask_value(1, true) # Player
			bullet_speed = 450.0
			modulate = Color("#39FF14")
	
	fx = bullet_fx_scene.instantiate()
	get_tree().current_scene.add_child(fx)
	bullet_timer.wait_time = bullet_lifetime
	bullet_timer.start()
	velocity = Vector2.RIGHT.rotated(rotation) * bullet_speed

func _physics_process(delta: float) -> void:
	position += velocity * delta
	wrap_screen()

func _on_bullet_timer_timeout() -> void:
	destroyed.emit()
	queue_free()
	
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


func _on_area_entered(_area: Area2D) -> void:
	fx.global_position = global_position
	fx.emitting = true
	destroyed.emit()
	queue_free()
