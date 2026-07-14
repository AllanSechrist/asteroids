extends Node2D
class_name GameManager

@export var starting_lives := 3
@export var asteroid_scene: PackedScene
@export var starting_asteroids := 2

@onready var ship: Ship = $Ship

var lives: int
var score := 0
var high_score := 1000
var current_level := 1
var max_asteroids = 10
var asteroids: int

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
	for i in starting_asteroids:
		var asteroid := asteroid_scene.instantiate()
		asteroid.destroyed.connect(_on_asteroid_destroyed)
		add_child.call_deferred(asteroid)
		asteroids += 1

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
			asteroids += 1
	asteroid.remove_from_group("Asteroids")
	asteroid.queue_free()
	asteroids -= 1
	print(asteroids)
	if asteroids == 0:
		all_asteroids_cleared()
	
	
func all_asteroids_cleared() -> void:
	current_level += 1
	starting_asteroids = clampi(starting_asteroids + 2, 0, 10)
	spawn_asteroids()
	var clear_message = "Level %d cleared!" % (current_level - 1)
	print(clear_message)
	
func _on_ship_hit() -> void:
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		game_over.emit()
	
