extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Measures world size in tiles
export var world_x = 20
export var world_y = 20

var environment_tiles : TileMap
var blocker_tiles : TileMap

# An array of dictionaries containing Vector2's 
# indexed "start" and "end" for start and size of box respectively
var walled_boxes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	environment_tiles = $EnvironmentTileMap
	blocker_tiles = $BlockerTileMap
	set_up_environment(1)


# Loops through all floor tiles to set up initial conditions
func set_up_environment(default_floor_tile : int):
	# Set up floor tiles depending on world size variables
	for x in range(world_x):
		for y in range(world_y):
			environment_tiles.set_cell(x, y, default_floor_tile)
			
	# Set up walls around world, depending again on world size variables
	create_walled_box(0, 0, world_x, world_y)
	var sample_box = create_walled_box(5, 5, 10, 7)
	if sample_box != null:
		walled_boxes.append_array(sample_box)
	


# Generates a wall around an empty rectangular area, dimensions sizeX and sizeY
func create_walled_box(start_x : int, start_y : int, size_x : int, size_y : int):
	if size_x < 3 or size_y < 3:
		print_debug("Walled area too small!")
		return null
	if start_x > world_x or start_y > world_y or start_x + size_x > world_x or start_y + size_y > world_y:
		print_debug("Area is out of world bounds!")
		return null
	else:
		for x in range(start_x - 1, start_x + size_y + 1):
			for y in range(start_y - 1, start_y + size_y + 1):
				if x <= start_x or x >= start_x + size_x - 1 or y <= start_y or y >= start_y + size_y - 1:
					blocker_tiles.set_cell(x, y, 0)
		blocker_tiles.update_bitmask_region(Vector2(start_x, start_y), Vector2(start_x + size_x, start_y + size_y))
		return {"start": Vector2(start_x, start_y), "size": Vector2(size_x + start_x, size_y + start_y)}
	
