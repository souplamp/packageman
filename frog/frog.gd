extends CharacterBody2D

signal ask_for_tile(location: Vector2i)
signal pause_maze()
signal frog_died()
signal package_received()

var alive: bool = true

const DEFAULT_SPEED = 64.0
var current_speed = DEFAULT_SPEED

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.ZERO
var can_move = true # prevent change in direction/velocity while moving across tiles
var tile_position = Vector2.ZERO # actual position of player object is 8 pixels off so it'll have to be adjusted
var wall_in_way = false
var last_direction = Vector2(1,0) # used for setting idle animation direction

@onready var raycast = $RayCast2D
@onready var animsprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var anim_player = $AnimationPlayer
@onready var package: Sprite2D = $package

var color: Color

func _ready() -> void:
	camera.make_current()

func die() -> void:
	if !alive: return
	alive = false
	
	$die.play()
	
	can_move = false
	velocity = Vector2.ZERO
	
	anim_player.play("die")
	await anim_player.animation_finished
	anim_player.play("RESET")
	
	emit_signal("frog_died")

func _physics_process(delta):
	
	#print(position)
	emit_signal("ask_for_tile", position)
	
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
		
		last_direction = direction # for anims
		
		wall_in_way = raycast.is_colliding()
	
	# snap to tile when not moving
	if velocity == Vector2.ZERO:
		can_move = true
		position = snapped(position, Vector2(8, 8))
	
	# stop moving when tile_position is multiple of 16 (the tile size) and is currently moving
	if check_position_tile() and (not can_move):
		velocity = Vector2.ZERO

	# move when not moving (when can_move is true) and no wall is in way of raycast2d
	if direction != Vector2.ZERO and can_move and (not wall_in_way):
			velocity = direction * current_speed
			if direction.x < 0 or direction.y < 0:
				velocity /= 2
			can_move = false
			if !$hop.is_playing(): 
				$hop.stop()
				$hop.play()
	
	# animation
	if velocity.x > 0:
		animsprite.animation = "hop_right"
	elif velocity.x < 0:
		animsprite.animation = "hop_left"
	
	if velocity.y > 0:
		animsprite.animation = "hop_down"
	elif velocity.y < 0:
		animsprite.animation = "hop_up"
		
		# idles
	if can_move:
		animsprite.pause()
		animsprite.animation = "idle"
		if last_direction == Vector2(1,0):
			animsprite.frame = 0
		elif last_direction == Vector2(-1, 0):
			animsprite.frame = 1
		elif last_direction == Vector2(0,1):
			animsprite.frame = 2
		elif last_direction == Vector2(0,-1):
			animsprite.frame = 3
			
	else:
		animsprite.play()
	
	move_and_slide()

# return true if tile_position is multiple of 16 (centered on tile)
func check_position_tile():
	if fmod(tile_position.x, 16) == 0 and fmod(tile_position.y, 16) == 0:
		return true
	else:
		return false

func _on_maze_tile_snake(state):
	if state:
		emit_signal("pause_maze")
		die()

func _on_area_area_entered(area):
	match area.name:
		"package":
			package.show()
		"receive":
			if package.visible:
				package.hide()
				emit_signal("package_received")
