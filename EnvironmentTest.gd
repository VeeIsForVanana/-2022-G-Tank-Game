tool
extends Node2D


onready var environmentNode = $Environment


# Called when the node enters the scene tree for the first time.
func _ready():
	environmentNode.set_up_environment(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
