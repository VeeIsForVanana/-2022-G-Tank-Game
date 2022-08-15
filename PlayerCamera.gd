extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_camera_position()



func handle_camera_position():
	var mouse_position = get_local_mouse_position()
	position = mouse_position * 0.25
