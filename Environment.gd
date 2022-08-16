extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Measures world size in tiles
export var worldX = 20
export var worldY = 20

var environmentTiles : TileMap
var blockerTiles : TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	environmentTiles = $EnvironmentTileMap
	blockerTiles = $BlockerTileMap
	set_up_environment(1)


# Loops through all floor tiles to set up initial conditions
func set_up_environment(defaultFloorTile : int):
	# Set up floor tiles depending on world size variables
	for x in range(worldX):
		for y in range(worldY):
			environmentTiles.set_cell(x, y, defaultFloorTile)
			
	# Set up walls around world, depending again on world size variables
	create_walled_box(0, 0, worldX, worldY)
	create_walled_box(5, 5, 10, 7)
	


# Generates a wall around an empty rectangular area, dimensions sizeX and sizeY
func create_walled_box(startX : int, startY : int, sizeX : int, sizeY : int):
	if sizeX < 3 or sizeY < 3:
		print_debug("Walled area too small!")
		return
	if startX > worldX or startY > worldY or startX + sizeX > worldX or startY + sizeY > worldY:
		print_debug("Area is out of world bounds!")
		return
	else:
		for x in range(startX - 1, startX + sizeX + 1):
			for y in range(startY - 1, startY + sizeY + 1):
				if x <= startX or x >= startX + sizeX - 1 or y <= startY or y >= startY + sizeY - 1:
					blockerTiles.set_cell(x, y, 0)
		blockerTiles.update_bitmask_region(Vector2(startX, startY), Vector2(startX + sizeX, startY + sizeY))
	
