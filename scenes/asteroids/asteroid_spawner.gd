extends Node2D
class_name AsteroidSpawner

@onready var top: Marker2D = $Top
@onready var right: Marker2D = $Right
@onready var bottom: Marker2D = $Bottom
@onready var left: Marker2D = $Left
@onready var positions := [top, right, bottom, left]

@export var asteroid_scene: PackedScene

var asteroids: int

signal all_asteroids_destroyed
signal asteroid_score(score: int)

func spawn_asteroids(amount: int) -> void:
	for i in amount:
		var variance := Vector2(randf_range(1,10), randf_range(1,10))
		var asteroid := asteroid_scene.instantiate()
		var spawn_position = positions.pick_random()
		asteroid.global_position = spawn_position.global_position
		asteroid.destroyed.connect(_on_asteroid_destroyed)
		add_child.call_deferred(asteroid)
		asteroids += 1
	
func _on_asteroid_destroyed(asteroid: Area2D) -> void:
	
	asteroid_score.emit(Asteroid.STATS[asteroid.size].points)
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
		all_asteroids_destroyed.emit()
