extends CharacterBody2D

func _ready() -> void:
	var noise = $Sprite2D.get_texture().get_noise()
	var t: Tween = get_tree().create_tween()
	t.tween_property(noise, "offset", Vector3.ONE * 100, 15.0)
	
