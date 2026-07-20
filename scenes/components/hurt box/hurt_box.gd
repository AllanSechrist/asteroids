extends Area2D
class_name HurtBox

@export var shape: Shape2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal hit

func _ready() -> void:
	collision_shape_2d.shape = shape

func _on_area_entered(area: Area2D) -> void:
	hit.emit(area)
