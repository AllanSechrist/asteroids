extends Node2D
class_name Main

@onready var asteroid_spawner: AsteroidSpawner = $AsteroidSpawner
@onready var game_manager: GameManager = $GameManager

func _ready() -> void:
	game_manager.level_changed.connect(asteroid_spawner._on_level_changed)
	game_manager.spawn_wave_requested.connect(asteroid_spawner.spawn_asteroids)
	asteroid_spawner.all_asteroids_destroyed.connect(game_manager._on_all_asteroids_destoryed)
	asteroid_spawner.asteroid_score.connect(game_manager._on_score_change)
	game_manager.start_game()
