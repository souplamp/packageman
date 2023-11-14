extends Control
@onready var maze: TileMap = $maze
@onready var frog: CharacterBody2D = $frog
@onready var count: RichTextLabel = frog.get_node("hbox/count")

var lives: int = 3

func _ready() -> void:
	maze.init()

func reset() -> void:
	frog.position = Vector2(56, 56)
	frog.alive = true
	
	await maze.reset()
	
	maze.paused = false
	maze.init()

func game_over() -> void:
	pass

func _on_frog_died():
	reset()
	if lives == 0:
		
		return
	lives -= 1
	count.text = str(lives)

func _on_frog_pause_maze():
	maze.paused = true
