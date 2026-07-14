extends CanvasLayer
class_name UI

#@onready var lives_label: Label = %LivesLabel
@onready var score_label: Label = %ScoreLabel
@onready var high_label: Label = %HighLabel
@onready var lives_container: HBoxContainer = %LivesContainer

@export var life_icon_scene: PackedScene

func _ready() -> void:
	var game_manager := get_parent() as GameManager
	game_manager.score_changed.connect(_on_score_changed)
	game_manager.lives_changed.connect(_on_lives_changed)
	game_manager.game_over.connect(_on_game_over)
	
	# Set labels based on game manager data
	_on_score_changed(game_manager.score)
	_on_lives_changed(game_manager.starting_lives)
	
func _on_score_changed(new_score: int) -> void:
	score_label.text = "SCORE: %d" % new_score
	
func _on_lives_changed(new_lives: int) -> void:
	for child in lives_container.get_children():
		child.queue_free()
	for i in new_lives:
		var icon = life_icon_scene.instantiate()
		lives_container.add_child.call_deferred(icon)
	
func _on_game_over() -> void:
	pass
