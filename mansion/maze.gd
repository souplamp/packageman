extends TileMap

@onready var timer: Timer = $move

var current_head: Vector2i = Vector2i(6, 5)

var last_dir: Vector2i

var dir: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]
enum DIR { UP, DOWN, RIGHT, LEFT }

func _ready() -> void:
	timer.start()
	set_cell(1, current_head, 1, Vector2i.ZERO)

func move() -> void:
	var next_head: Vector2i = current_head + dir.pick_random()
	var ctd: TileData = get_cell_tile_data(0, next_head)
	var std: TileData = get_cell_tile_data(1, next_head)
	if ctd != null or std != null: move()
	else:
		set_cell(1, next_head, 1, Vector2i.ZERO)
		current_head = next_head

#func move() -> void:
#	var invalid: bool = true
#	var next_head: Vector2i
#	var random_dir: Vector2i
#
#	while invalid:
#
#		random_dir = dir.pick_random()
#		next_head = current_head + random_dir
#
#		var ctd: TileData = get_cell_tile_data(0, next_head)
#		#var std: TileData = get_cell_tile_data(1, next_head)
#
#		invalid = ctd != null
#		await get_tree().process_frame
#
#	last_dir = random_dir
#
#	set_cell(1, next_head, 1, Vector2i.ZERO)
#	current_head = next_head

func verify_tile(next_position: Vector2i) -> bool:
	var b: bool = false
	
	
	
	return b

func pick_direction() -> Vector2i:
	var invalid: bool = true
	var picked_dir: Vector2i
	
	while invalid:
		picked_dir = dir.pick_random()
		var difference = last_dir - picked_dir
		
		invalid = difference == Vector2i.ZERO
		await get_tree().process_frame
	
	return picked_dir

func _on_move_timeout():
	move()
