extends Area2D
class_name HurtBox

signal hit



func _on_area_entered(area: Area2D) -> void:
	hit.emit(area)
