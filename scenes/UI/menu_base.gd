extends Control
class_name MenuBase

@export var title_text: String = "ASTEROIDS"
@export var show_score: bool = false

@onready var title_label: Label = $TitleLabel
@onready var score_label: Label = $ScoreLabel
@onready var start_button: Button = $StartButton

func setup(text: String, score: int = -1) -> void:
	title_label.text = text
	score_label.visible = score >= 0
	if score >= 0:
		score_label.text = "Score: %d" % score
		
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
