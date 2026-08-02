extends Node
class_name UFOManager

@export var ufo_scene: PackedScene
@export var base_spawn_interval := 20.0
@export var min_spawn_interval := 8.0
@export var interval_decay_per_wave := 1.5

@onready var spawn_timer: Timer = $SpawnTimer

var active_ufo: UFO = null
var rescale := Vector2(0.25, 0.25)

signal ufo_score(points: int)

func _ready() -> void:
	spawn_timer.one_shot = true
	spawn_timer.start(get_spawn_interval())
	
func get_spawn_interval() -> float:
	var interval := base_spawn_interval - (GameState.current_level * interval_decay_per_wave)
	return clampf(interval, min_spawn_interval, base_spawn_interval)
	
	
func spawn_ufo() -> void:
	var ufo: UFO = ufo_scene.instantiate()
	ufo.size = UFO.Size.BIG if randf() < 0.6 else UFO.Size.SMALL
	
	if ufo.size == UFO.Size.SMALL:
		ufo.scale = ufo.scale - rescale
	
	var screen_size := get_viewport().get_visible_rect().size
	var from_left := randf() < 0.5
	ufo.position = Vector2(0.0 if from_left else screen_size.x, randf_range(0, screen_size.y))
	
	add_child(ufo)
	ufo.tree_exited.connect(func(): active_ufo = null)
	ufo.destroyed.connect(_on_ufo_destroyed)
	
	active_ufo = ufo
	
func _on_ufo_destroyed(points: int) -> void:
	ufo_score.emit(points)
	
func _on_spawn_timer_timeout() -> void:
	if active_ufo == null:
		spawn_ufo()
	spawn_timer.start(get_spawn_interval())
