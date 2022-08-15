extends "res://GenericDirector.gd"

#  Variable orders for children


# Called when the node enters the scene tree for the first time.
func _ready():
	target = Vector2.ZERO
	tank = get_parent()
	affiliation = PLAYER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	movement = handle_movement()
	target = acquire_target()
	fire_order = Input.is_action_just_pressed("fire_gun")


func handle_movement():
	return {
		"turn left" : Input.is_action_pressed("turn_left"),
		"turn right" : Input.is_action_pressed("turn_right"),
		"move forward" : Input.is_action_pressed("move_forward"),
		"move backward" : Input.is_action_pressed("move_backward")
	}
	

func acquire_target():
	return tank.to_local(get_global_mouse_position())
