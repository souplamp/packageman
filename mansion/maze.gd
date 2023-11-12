extends TileMap

@onready var timer: Timer = $move
@onready var snake_tick: AudioStreamPlayer = $snake_tick

var current_head: Vector2i = Vector2i(12, 10)

var length: int = 5
var tiles: Array[Vector2i] = [current_head]

var dir: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]
enum DIR { UP, DOWN, RIGHT, LEFT }

func init() -> void:
	timer.start()
	set_cell(1, current_head, 1, Vector2i.ZERO)

func move() -> void:
	var invalid: bool = true
	var next_head: Vector2i = current_head + dir.pick_random()
	
	while invalid:
		next_head = current_head + dir.pick_random()
		var ctd: TileData = get_cell_tile_data(0, next_head)
		var std: TileData = get_cell_tile_data(1, next_head)
		
		invalid = ctd != null or std != null
		await get_tree().process_frame
	
	current_head = next_head
	
	if len(tiles) >= length:
		erase_cell(1, tiles[0])
		tiles.remove_at(0)
	tiles.append(current_head)
	set_cell(1, current_head, 1, Vector2i.ZERO)
	
func _on_move_timeout():
	snake_tick.play()
	move()
