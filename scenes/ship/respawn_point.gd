extends Marker2D
class_name RespawnPoint

func _ready() -> void:
	var screen_size := get_viewport_rect().size
	global_position = Vector2(screen_size.x / 2, screen_size.y / 2)
