extends Node2D

@onready var particles: CPUParticles2D = $particles
@onready var shimmer: AudioStreamPlayer2D = $shimmer
@onready var sprite: Sprite2D = $sprite
@onready var light: PointLight2D = $light

func collect() -> void:
	particles.emitting = true
	sprite.hide()
	
	var t: Tween = get_tree().create_tween()
	t.tween_property(light, "color", Color(0, 0, 0, 1), 1.0)
	await t.finished
	
	call_deferred("queue_free")

func _on_area_area_entered(area):
	collect()
