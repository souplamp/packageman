extends TileMap

signal tile_snake(state: bool)

@onready var timer: Timer = $move
@onready var slither: AudioStreamPlayer2D = $slither
@onready var light: PointLight2D = $light

var current_head: Vector2i = Vector2i(12, 10)

var current_difficulty: int = 0

var length: int = 5
var tiles: Array[Vector2i] = [current_head]

var dir: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]
enum DIR { UP, DOWN, RIGHT, LEFT }

var paused: bool = false

func init() -> void:
	timer.start()
	set_cell(1, current_head, 1, Vector2i.ZERO)

func reset() -> void:
	timer.stop()
	for t in tiles: erase_cell(1, t)
	current_head = Vector2i(12, 10)
	tiles = [current_head]

func add_difficulty() -> void:
	timer.wait_time -= 0.025
	current_difficulty += 1

func move() -> void:
	if paused: return
	
	var temp_dir: Array[Vector2i] = dir.duplicate()
	var next_head: Vector2i = current_head + temp_dir.pick_random()
	
	var invalid: bool = !validate_tile(next_head)
	
	while invalid:
		var random_dir: Vector2i 
		if temp_dir: random_dir = current_head + temp_dir.pick_random()
		
		var index = temp_dir.find(random_dir)
		if index != -1: temp_dir.remove_at(index)
		
		next_head = random_dir
		invalid = !validate_tile(next_head)
		
		await get_tree().process_frame
	
	current_head = next_head
	update_tiles()

func validate_tile(head: Vector2i) -> bool:
	var ctd: TileData = get_cell_tile_data(0, head)
	var std: TileData = get_cell_tile_data(1, head)
	return !(ctd != null or std != null)

func update_tiles() -> void:
	if len(tiles) >= length:
		erase_cell(1, tiles[0])
		tiles.remove_at(0)
	tiles.append(current_head)
	set_cell(1, current_head, 1, Vector2i.ZERO)

func _on_move_timeout():
	if !slither.is_playing(): slither.play()
	var current_head_position = 16 * (Vector2(current_head))
	slither.position = current_head_position
	light.position = current_head_position
	move()

func _on_frog_ask_for_tile(location):
	var pos = Vector2i(location) / 16 - Vector2i.ONE
	var std: TileData = get_cell_tile_data(1, pos)
	emit_signal("tile_snake", std != null)
