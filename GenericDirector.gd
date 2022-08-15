extends Node2D


enum {PLAYER, NEUTRAL, HOSTILE}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tank
var movement = {
	"turn left" : false,
	"turn right" : false,
	"move forward" : false,
	"move backward" : false,
}
var target : Vector2
var fire_order : bool
var affiliation = NEUTRAL


# Called when the node enters the scene tree for the first time.
func _ready():
	target = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
