extends AnimatedSprite2D

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
	animation = "walking_down"
	START_X = position.x
	START_Y = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	print(int(START_X - position.x) % delta_pos)
	print(int(START_Y - position.y) % delta_pos)

func move(delta):
	if moving:
		update_position(delta)
		
	if (not moving or current_move_time == target_move_time):
		if (Input.is_action_pressed("down")):
			start_move("walking_down")
		elif (Input.is_action_pressed("up")):
			start_move("walking_up")
		elif (Input.is_action_pressed("left")):
			start_move("walking_left")
		elif (Input.is_action_pressed("right")):
			start_move("walking_right")
		else:
			moving = false
			stop()
			
func start_move(move_str):
	current_move_time = 0
	moving = true
	start_x = position.x
	start_y = position.y
	if (animation != move_str):
		frame = 1
	play(move_str)
		
func update_position(delta):
	var ratio = min(current_move_time + delta, target_move_time) / target_move_time
	var step = floor(ratio * delta_pos)
	if (animation == "walking_down"):
		position.y = start_y + step
	if (animation == "walking_up"):
		position.y = start_y - step
	if (animation == "walking_left"):
		position.x = start_x - step
	if (animation == "walking_right"):
		position.x = start_x + step
		
	current_move_time += delta
	current_move_time = min(current_move_time, target_move_time)
