extends Node2D
@onready var maze: TileMap = $maze
@onready var frog: CharacterBody2D = $frog

func _ready() -> void:
	maze.init()

func reset() -> void:
	frog.position = Vector2(56, 56)
	await maze.reset()
	
	maze.paused = false
	maze.init()

func _on_frog_died():
	reset()

func _on_frog_pause_maze():
	maze.paused = true
