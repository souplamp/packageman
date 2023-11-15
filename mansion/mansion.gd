extends Control

@onready var maze: TileMap = $maze
@onready var frog: CharacterBody2D = $frog
@onready var count: RichTextLabel = $canvas/hbox/count

var current_receive

var lives: int = 3

func _ready() -> void:
	maze.init()
	spawn_package()
	spawn_receive()

func reset() -> void:
	frog.position = Vector2(56, 56)
	frog.alive = true
	
	await maze.reset()
	
	maze.paused = false
	maze.init()

func spawn_package() -> void:
	var cells = maze.get_used_cells(2)
	var cell = cells.pick_random()
	
	var p = load("res://packages/package.tscn")
	var pack = p.instantiate()
	add_child(pack)
	#pack.position = (cell) * 16
	pack.position = 16 * (Vector2(cell) + Vector2(1.5, 2.5))

func spawn_receive() -> void:
	var cells = maze.get_used_cells(2)
	var cell = cells.pick_random()
	
	var r = load("res://packages/receive.tscn")
	var rec = r.instantiate()
	add_child(rec)
	rec.position = 16 * (Vector2(cell) + Vector2(1.5, 2.5))
	current_receive = rec

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

func _on_frog_package_received():
	await current_receive.call_deferred("queue_free")
	spawn_package()
	spawn_receive()
