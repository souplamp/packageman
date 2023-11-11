extends CharacterBody2D

const SPEED = 64.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.ZERO
var can_move = true # prevent change in direction/velocity while moving across tiles
var tile_position = Vector2.ZERO # actual position of player object is 8 pixels off so it'll have to be adjusted
var wall_in_way = false

@onready var raycast = $RayCast2D


func _physics_process(delta):
	
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# snap to integer
	position = Vector2i(position.x, position.y)
	tile_position = position - Vector2(8, 8)
	
	if direction.x == 0:
		direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	elif direction.y == 0:
		direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	direction = direction.normalized()
		
	# detect wall
	if direction != Vector2.ZERO:
		raycast.target_position = direction * 16
		raycast.force_raycast_update()
		
		wall_in_way = raycast.is_colliding()
	
	
	if velocity == Vector2.ZERO:
		can_move = true
		position = snapped(position, Vector2(8,8))
		
	if check_position_tile() and (not can_move):
		velocity = Vector2.ZERO

	if direction != Vector2.ZERO and can_move and (not wall_in_way):
			velocity = direction * SPEED
			if direction.x < 0 or direction.y < 0:
				velocity /= 2
			can_move = false


	move_and_slide()

# return true if position is multiple of 16 (centered on tile)
func check_position_tile():
	if fmod(tile_position.x, 16) == 0 and fmod(tile_position.y, 16) == 0:
		return true
	else:
		return false
