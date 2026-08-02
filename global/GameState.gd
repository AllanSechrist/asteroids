extends Node

var last_score: int
var high_score: int = 0
var current_level := 1

const SAVE_PATH := "user://highscore.save"

func _ready() -> void:
	load_high_score()
	
func load_high_score() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	high_score = file.get_var()
	file.close()
	
func save_high_score() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(high_score)
	file.close()
	
func try_update_high_score(new_score: int) -> void:
	if new_score > high_score:
		high_score = new_score
		save_high_score()
