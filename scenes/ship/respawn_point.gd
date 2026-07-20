extends Marker2D
class_name RespawnPoint

func _ready() -> void:
	global_position = get_viewport_rect().size / 2
