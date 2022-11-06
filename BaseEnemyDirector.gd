extends "res://GenericDirector.gd"

var previous_m_target_location : Vector2

var movement_target : Vector2	# Location of final destination
var path_target : Vector2		# Location of movement target along path to destination

var known_enemy_tanks = []
var target_tank : Node2D
var nav_agent : NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready():
	tank = get_parent()
	target = Vector2.ZERO
	affiliation = HOSTILE
	nav_agent = $EnemyNavAgent
	known_enemy_tanks = get_tree().get_nodes_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(known_enemy_tanks) <= 0:
		return
	target_tank = known_enemy_tanks[0]
	handle_targeting_object(target_tank)
	movement_target = target_tank.position
	handle_fire_order()
	update_navigation()
	handle_navigation()
	movement = handle_movement()
	pass


# Handles targeting and processing of target location relative to local position
# for processing by tank's gun targeting
func handle_targeting_object(target_node : Node2D):
	target = tank.to_local(target_node.global_position)
	

# Handles ordering the tank to fire when reloaded and aimed 
# then restoring fire order to false
func handle_fire_order():
	if tank.aimed and tank.reloaded:
		fire_order = true
	else:
		fire_order = false

# Handles updating path target based on changing movement_target
func update_navigation():
	if not nav_agent.is_target_reachable() or nav_agent.is_target_reached():
		return
	nav_agent.set_target_location(movement_target)
	pass
	

# Handles obtaining new waypoints for navigation and ending further navigation
func handle_navigation():
	# if nav_agent.distance_to_target() <= 1:
	#	path_target = global_position
	path_target = nav_agent.get_next_location()


# Handles movement orders (forward, backward, left turn, right turn)
func handle_movement():
	var local_path_position = to_local(path_target)
	return movement
	

func can_find_target():
	print(movement_target)
	print(nav_agent.is_target_reachable())
