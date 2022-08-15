extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export var worldSizeX = 100
export var worldSizeY = 100
export var defaultWorldTileIndex = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	for y in range(worldSizeY):
		for x in range(worldSizeX):
			set_cell(x, y, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
