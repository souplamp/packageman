extends Node2D
@onready var maze: TileMap = $maze
func _ready() -> void: maze.init()
