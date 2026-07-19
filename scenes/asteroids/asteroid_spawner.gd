extends Node2D
class_name AsteroidSpawner

@export var asteroid_scene: PackedScene

var asteroids: int

signal all_asteroids_destroyed
signal asteroid_score(score: int)

func spawn_asteroids(amount: int) -> void:
	for i in amount:
		var asteroid := asteroid_scene.instantiate()
		asteroid.global_position = get_random_edge_position()
		asteroid.destroyed.connect(_on_asteroid_destroyed)
		add_child.call_deferred(asteroid)
		asteroids += 1
		
func get_random_edge_position() -> Vector2:
	var screen_size := get_viewport_rect().size
	var edge := randi() % 4
	
	match edge:
		0: return Vector2(randf_range(0, screen_size.x), 0)
		1: return Vector2(screen_size.x, randf_range(0,screen_size.y))
		2: return Vector2(randf_range(0, screen_size.x), screen_size.y)
		_: return Vector2(0, randf_range(0, screen_size.y))
	
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
