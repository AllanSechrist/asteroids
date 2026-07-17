extends Control
class_name MenuBase

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var quit_button: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	if GameState.last_score > 0:
		setup("GAME OVER", GameState.last_score)
	else:
		setup("ASTEROIDS")

func setup(text: String, score: int = -1) -> void:
	title_label.text = text
	score_label.visible = score >= 0
	if score >= 0:
		score_label.text = "Score: %d" % score
		
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
