extends Control

@onready var maze: TileMap = $maze
@onready var frog: CharacterBody2D = $frog
@onready var count: RichTextLabel = $canvas/hbox/count

var lives: int = 3

func _ready() -> void:
	maze.init()
	spawn_package()

func reset() -> void:
	frog.position = Vector2(56, 56)
	frog.alive = true
	
	await maze.reset()
	
	maze.paused = false
	maze.init()

func spawn_package() -> void:
	var cells = maze.get_used_cells(2)
	var cell = cells.pick_random()
	#var cell = cells[0]
	
	var p = load("res://packages/package.tscn")
	var pack = p.instantiate()
	add_child(pack)
	#pack.position = (cell) * 16
	pack.position = 16 * (Vector2(cell) + Vector2(1.5, 2.5))
	
# cell = player.position / 16 - V(0, 1)
# cell * 16 = player.position - V(0, 16)
# player.position = -V(0,16) - cell*16
# -player.position = V(0,16) + cell*16

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
