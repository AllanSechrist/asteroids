extends Node2D
class_name GameManager

@export var starting_lives := 4
@export var starting_asteroids := 6


@onready var ship: Ship = $Ship
@onready var asteroid_spawner: AsteroidSpawner = $AsteroidSpawner
@onready var respawn_point: RespawnPoint = $RespawnPoint

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
	ship.death.connect(_on_ship_death)
	asteroid_spawner.all_asteroids_destroyed.connect(_on_all_asteroids_destoryed)
	asteroid_spawner.asteroid_score.connect(_on_score_change)
	asteroid_spawner.spawn_asteroids(starting_asteroids)
	
func _on_score_change(points: int) -> void:
	score += points
	score_changed.emit(score)
	
func _on_all_asteroids_destoryed() -> void:
	current_level += 1
	starting_asteroids = clampi(starting_asteroids + 2, 0, 10)
	asteroid_spawner.spawn_asteroids(starting_asteroids)
	var clear_message = "Level %d cleared!" % (current_level - 1)
	print(clear_message)
	
func _on_ship_death() -> void:
	lives -= 1
	lives_changed.emit(lives)
	#await get_tree().create_timer(respawn_time).timeout
	#ship.global_position = respawn_point.global_position
	if lives <= 0:
		GameState.last_score = score
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file.call_deferred("res://scenes/UI/menu_base.tscn")
