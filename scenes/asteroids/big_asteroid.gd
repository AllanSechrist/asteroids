extends Area2D
class_name BigAsteroid

@export var sprite_variants: Array[Texture2D] = []

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if sprite_variants.size() > 0:
		sprite_2d.texture = sprite_variants.pick_random()
	sprite_2d.flip_h = randi() % 2 == 0 # randomly flips sprite.
