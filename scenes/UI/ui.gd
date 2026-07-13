extends CanvasLayer
class_name UI

@onready var lives_label: Label = %LivesLabel
@onready var score_label: Label = %ScoreLabel
@onready var high_label: Label = %HighLabel



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
	lives_label.text = "LIVES: %d" % new_lives
	
func _on_game_over() -> void:
	pass
