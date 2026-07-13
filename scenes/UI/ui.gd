extends Control
class_name UI

@onready var lives: Label = $MarginContainer/HBoxContainer/Lives
@onready var score: Label = $MarginContainer/HBoxContainer/Score
@onready var high_score: Label = $MarginContainer/HBoxContainer/HighScore


func _ready() -> void:
	pass
	
func update_label(label: Label) -> void:
	pass
