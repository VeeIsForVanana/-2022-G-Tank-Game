extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const TankClass = preload("res://Tank.gd")
const loading1	= preload("res://assets/crosshairs/crosshair087a.png")
const loading2	= preload("res://assets/crosshairs/crosshair087b.png")
const loading3	= preload("res://assets/crosshairs/crosshair087c.png")
const loaded	= preload("res://assets/crosshairs/crosshair087.png")
const aimed		= preload("res://assets/crosshairs/crosshair094.png")

var tank : TankClass
var cursor_image = loaded
var default_hotspot = Vector2(32, 32)
var loading_image_list = [loading3, loading2, loading1, loaded]

# Called when the node enters the scene tree for the first time.
func _ready():
	tank = get_parent().get_parent()
	Input.set_custom_mouse_cursor(cursor_image, 0, default_hotspot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var reloaded = tank.reloaded
	var b_aimed = tank.aimed
	if reloaded:
		if b_aimed:
			cursor_image = aimed
		else:
			cursor_image = loaded
	else:
		cursor_image = loading_image_list[
			floor((tank.reload_timer.time_left / tank.reload_time) * 3)
		]
		
	Input.set_custom_mouse_cursor(cursor_image, 0, default_hotspot)
