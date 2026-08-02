extends Node
class_name GameManager

@export var starting_lives := 4
@export var starting_asteroids := 6
@export var spawn_buffer := 1.0


@onready var ship: Ship = $Ship

var lives: int
var score := 0
var max_asteroids = 10
var asteroids: int

#LEVEL CHANGE
signal level_changed(new_level: int)
#SPAWN
signal spawn_wave_requested(amount: int)
#UI
signal score_changed(new_score: int)
signal lives_changed(new_lives: int)

func _ready () -> void:
	lives = starting_lives
	ship.death.connect(_on_ship_death)
	
func start_game() -> void:
	spawn_wave_requested.emit(starting_asteroids)
	
func _on_score_change(points: int) -> void:
	score += points
	score_changed.emit(score)
	
func _on_all_asteroids_destoryed() -> void:
	GameState.current_level += 1
	level_changed.emit(GameState.current_level)
	starting_asteroids = clampi(starting_asteroids + 2, 0, 10)
	await get_tree().create_timer(spawn_buffer).timeout
	spawn_wave_requested.emit(starting_asteroids)
	
func _on_ship_death() -> void:
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		GameState.last_score = score
		GameState.try_update_high_score(score)
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file.call_deferred("res://scenes/UI/menu_base.tscn")
