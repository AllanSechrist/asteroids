extends Node2D
class_name GameManager

@export var starting_lives := 3
@export var asteroid_scene: PackedScene

@onready var ship: Ship = $Ship

var lives: int
var score := 0
var high_score := 1000
var current_level := 1
var max_asteroids = 10
var asteroids = 6

#UI
signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
# GAME OVER
signal game_over

func _ready () -> void:
	lives = starting_lives
	ship.hit.connect(_on_ship_hit)
	spawn_asteroids()

func spawn_asteroids() -> void:
	for i in asteroids:
		var asteroid := asteroid_scene.instantiate()
		asteroid.destroyed.connect(_on_asteroid_destroyed)
		add_child(asteroid)

func _on_asteroid_destroyed(asteroid: Area2D) -> void:
	score += Asteroid.STATS[asteroid.size].points
	score_changed.emit(score)
	if asteroid.size != Asteroid.Size.SMALL:
		for i in asteroid.asteroid_chunks:
			var chunk = asteroid.asteroid_scene.instantiate()
			chunk.size = asteroid.size + 1
			chunk.global_position = asteroid.global_position
			chunk.destroyed.connect(_on_asteroid_destroyed)
			add_child.call_deferred(chunk)
	asteroid.queue_free()
	
func _on_all_asteroids_cleared() -> void:
	current_level += 1
	spawn_asteroids()
	
func _on_ship_hit() -> void:
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		game_over.emit()
	
