extends CPUParticles2D
class_name Bullet_FX

func _ready() -> void:
	emitting = false
	one_shot = true
	finished.connect(queue_free)
