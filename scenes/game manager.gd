extends Node2D
class_name GameManager

@export var starting_lives := 3
var lives: int
var score := 0
var high_score := 1000
var current_level := 1


#UI
signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
# GAME OVER
signal game_over

func _ready () -> void:
	lives = starting_lives
	spawn_asteroids()

func spawn_asteroids() -> void:
	pass # spawns asteroids into the level

func _on_asteroid_destroyed(points: int) -> void:
	score += points
	score_changed.emit(score)
	
func _on_all_asteroids_cleared() -> void:
	current_level += 1
	spawn_asteroids()
	
func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		game_over.emit()
	
