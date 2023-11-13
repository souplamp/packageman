extends Node2D

var is_picked_up: bool = false
var is_delivered: bool = true

@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _on_timer_timeout():
	print("yo!")
