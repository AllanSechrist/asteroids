extends Area2D
class_name Bullet

@export var bullet_speed := 800.0
@export var bullet_lifetime := 1.5
@export var bullet_fx_scene: PackedScene

@onready var bullet_timer: Timer = $BulletTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var velocity := Vector2.ZERO
var fx: CPUParticles2D

signal destroyed

func _ready() -> void:
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


func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		fx.global_position = global_position
		fx.emitting = true
		destroyed.emit()
		queue_free()
