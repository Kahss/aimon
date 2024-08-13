extends CharacterBody2D

var moving = false
var current_move_time = 0
var target_move_time = 0.25
var delta_pos = 16

var start_x = 0
var start_y = 0

var START_X = 0
var START_Y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.animation = "walking_down"
	START_X = position.x
	START_Y = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)


func move(delta):
	if moving:
		update_position(delta)
		
	if (not moving or current_move_time == target_move_time):
		if (Input.is_action_pressed("down")):
			start_move("walking_down", Vector2i(0, 1))
		elif (Input.is_action_pressed("up")):
			start_move("walking_up", Vector2i(0, -1))
		elif (Input.is_action_pressed("left")):
			start_move("walking_left", Vector2i(-1, 0))
		elif (Input.is_action_pressed("right")):
			start_move("walking_right", Vector2i(1, 0))
		else:
			moving = false
			$Sprite.stop()

func blocked(delta: Vector2i):
	var map: TileMap = get_parent().get_node("GroundTiles")
	var charac_pos: Vector2i = map.local_to_map(Vector2(position.x, position.y))
	var tile_data: TileData = map.get_cell_tile_data(0, charac_pos + delta)
	return tile_data != null and tile_data.get_collision_polygons_count(0) > 0
			
func start_move(move_str: String, delta: Vector2i):
	if blocked(delta):
		$Sprite.animation = move_str
		$Sprite.pause()
		moving = false
	else:
		current_move_time = 0
		moving = true
		start_x = position.x
		start_y = position.y
		if ($Sprite.animation != move_str):
			$Sprite.frame = 1
		$Sprite.play(move_str)
		
func update_position(delta):
	var ratio = min(current_move_time + delta, target_move_time) / target_move_time
	var step = floor(ratio * delta_pos)
	if ($Sprite.animation == "walking_down"):
		position.y = start_y + step
	if ($Sprite.animation == "walking_up"):
		position.y = start_y - step
	if ($Sprite.animation == "walking_left"):
		position.x = start_x - step
	if ($Sprite.animation == "walking_right"):
		position.x = start_x + step
		
	current_move_time += delta
	current_move_time = min(current_move_time, target_move_time)
