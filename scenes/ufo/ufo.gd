extends Area2D
class_name UFO

enum Size { BIG, SMALL }

@export var min_lifetime := 10.0
@export var max_lifetime := 15.0
@export var attack_interval := 2.0
@export_category("Effects")
@export var death_fx: PackedScene
@export var death_sound: AudioStream
@export var gun_sound: AudioStream
@export_category("Scenes")
@export var bullet_scene: PackedScene

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var ufo_sprite: Sprite2D = $UFOSprite
@onready var movement_timer: Timer = $MovementTimer
@onready var despawn_timer: Timer = $DespawnTimer
@onready var attack_timer: Timer = $AttackTimer

var size: Size = Size.BIG
var velocity: Vector2 = Vector2.ZERO
var speed: float
var speed_multiplier := 1.0

signal destroyed(points: int)

const STATS := {
	Size.BIG: { speed = 250.0, points = 500 },
	Size.SMALL: { speed = 280.0, points = 1000 }
}

const SPREAD := deg_to_rad(15)

func _ready() -> void:
	var stats = STATS[size]
	speed = stats.speed * speed_multiplier
	pick_new_direction()
	movement_timer.start(randf_range(0.75, 1.5))
	despawn_timer.start(randf_range(min_lifetime, max_lifetime))
	attack_timer.start(randf_range(0.5, attack_interval))

func pick_new_direction() -> void:
	var angle := randf_range(-PI / 4, PI / 4)
	velocity = Vector2.RIGHT.rotated(angle) * speed
	
func _physics_process(delta: float) -> void:
	position += velocity * delta
	wrap_screen()

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

func spawn_death_effects() -> void:
	var effect := death_fx.instantiate()
	SoundManager.play(death_sound)
	get_parent().add_child(effect)
	effect.global_position = global_position
	if effect is CPUParticles2D:
		effect.emitting = true
		effect.one_shot = true
		effect.finished.connect(effect.queue_free)

func _on_area_entered(_area: Area2D) -> void:
	die()
	
func die() -> void:
	spawn_death_effects()
	destroyed.emit(STATS[size].points)
	queue_free()

func _on_movement_timer_timeout() -> void:
	pick_new_direction()
	movement_timer.start(randf_range(0.75, 1.5))


func _on_despawn_timer_timeout() -> void:
	queue_free()

func shoot() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	var direction = (player.global_position - global_position).normalized()
	direction = direction.rotated(randf_range(-SPREAD, SPREAD))

	SoundManager.play(gun_sound)
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.source = Bullet.Source.ENEMY
	var spawn_offset = direction * (collision_shape_2d.shape.radius + 4.0)
	bullet.global_position = global_position + spawn_offset
	bullet.rotation = direction.angle()
	get_tree().current_scene.add_child(bullet)

func _on_attack_timer_timeout() -> void:
	shoot()
	attack_timer.start(randf_range(0.5, attack_interval))
