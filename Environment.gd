extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Measures world size in tiles
export var world_x = 20
export var world_y = 20

var environment_tiles : TileMap
var blocker_tiles : TileMap
var environment_rng : RandomNumberGenerator 

# An array of dictionaries containing Vector2's 
# indexed "start" and "end" for start and end of box respectively
var walled_boxes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	environment_tiles = $EnvironmentTileMap
	blocker_tiles = $BlockerTileMap
	environment_rng = RandomNumberGenerator.new()
	environment_rng.randomize()
	set_up_environment(1)


# Loops through all floor tiles to set up initial conditions
func set_up_environment(default_floor_tile : int):
	# Set up floor tiles depending on world size variables
	for x in range(world_x):
		for y in range(world_y):
			environment_tiles.set_cell(x, y, default_floor_tile)
			
	# Set up walls around world, depending again on world size variables
	create_walled_box(0, 0, world_x, world_y)


# Generates a wall around an empty rectangular area, dimensions sizeX and sizeY
func create_walled_box(start_x : int, start_y : int, size_x : int, size_y : int):
	if size_x < 3 or size_y < 3:
		print_debug("Walled area too small!")
		return null
	if start_x > world_x or start_y > world_y or start_x + size_x > world_x or start_y + size_y > world_y:
		print_debug("Area is out of world bounds!")
		return null
	else:
		for x in range(start_x - 1, start_x + size_x + 1):
			for y in range(start_y - 1, start_y + size_y + 1):
				if x <= start_x or x >= start_x + size_x - 1 or y <= start_y or y >= start_y + size_y - 1:
					blocker_tiles.set_cell(x, y, 0)
		blocker_tiles.update_bitmask_region(Vector2(start_x, start_y), Vector2(start_x + size_x, start_y + size_y))
		return WalledBox.new(Vector2(start_x, start_y), Vector2(size_x, size_y))
	


# Creates openings in a walled box, exit_size is an integer representing the 
# width of the exit
func create_walled_box_exit(walled_box : WalledBox, exit_size : int):
	var length = walled_box.size.x
	var height = walled_box.size.y
	
	if exit_size > length and exit_size > height:
		print_debug("Larger exit than any existing wall!")
		return
	
	environment_rng.randomize()
	var random_length = environment_rng.randi_range(exit_size, length - exit_size)
	var random_height = environment_rng.randi_range(exit_size, height - exit_size)
	var choice_array = [
		Vector3(-1, random_height, 0),			# left wall
		Vector3(length - 2, random_height, 0),	# right wall
		Vector3(random_length, -1, 1),			# top wall
		Vector3(random_length, height - 2, 1)	# bottom wall
	]
	var wall_selector = environment_rng.randi_range(0, 3)
	var choice : Vector3
	
	if exit_size > height:
		choice = choice_array[wall_selector % 2]
	elif exit_size > length:
		choice = choice_array[2 + (wall_selector % 2)]
	else:
		choice = choice_array[wall_selector]
		
	print(wall_selector)
	print(choice.x)
	print(choice.y)
	
	var x_bound
	var y_bound
	
	if choice.z == 1:	# If the exit_size will be applied along the y axis
		x_bound = choice.x + 1
		y_bound = choice.y + exit_size
	else:				# If the exit_size will be applied along the x axis
		x_bound = choice.x + exit_size
		y_bound = choice.y + 1
		
	for x in range(choice.x, x_bound):
		for y in range(choice.y, y_bound):
			blocker_tiles.set_cell(walled_box.start.x + x, walled_box.start.y + y, -1)
	
	blocker_tiles.update_bitmask_region(walled_box.start, walled_box.end)

# Class for walled boxes
class WalledBox:
	
	
	# Inner area dimensions
	var start	: Vector2
	var size	: Vector2
	var end		: Vector2
	
	
	# Initializes a box using its start and size
	func _init(in_start : Vector2, in_size : Vector2):
		start = in_start
		size = in_size
		end = Vector2(in_start.x + in_size.x, in_start.y + in_size.y)
		return self
