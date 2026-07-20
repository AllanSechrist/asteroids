extends Area2D
class_name Asteroid

enum Size { BIG, MEDIUM, SMALL }

@export_category("Asteroid Stats")
@export var size: Size = Size.BIG
@export var sprite_variants: Array[Texture2D] = []
@export var speed: float = 100.0
@export var rotation_speed: float = 1.0
@export var asteroid_chunks := 2

@export_category("Asteroid Chunks")
@export var asteroid_scene: PackedScene

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var velocity: Vector2 = Vector2.ZERO

const STATS := {
	Size.BIG: { speed = 60.0, points = 20 },
	Size.MEDIUM: { speed = 100.0, points = 50 },
	Size.SMALL: { speed = 150.0, points = 100}
}

signal destroyed(asteroid: Area2D)

func _ready() -> void:
	add_to_group("Asteroids")
	var stats = STATS[size]
	speed = stats.speed
	if sprite_variants.size() > 0:
		sprite_2d.texture = sprite_variants.pick_random()
	sprite_2d.flip_h = randi() % 2 == 0 # randomly flips sprite.
	
	var angle := randf_range(0, TAU)
	velocity = Vector2.RIGHT.rotated(angle) * speed
	rotation_speed *= [-1, 1].pick_random()
	
	
func _physics_process(delta: float) -> void:
	position += velocity * delta
	rotation += rotation_speed * delta
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


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		area.queue_free()
		destroyed.emit(self)
