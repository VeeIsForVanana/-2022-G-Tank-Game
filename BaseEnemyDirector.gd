extends "res://GenericDirector.gd"

var previous_target_location : Vector2

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
	handle_fire_order()
	previous_target_location = target
	pass


# Handles targeting and processing of target location relative to local position
# for processing by tank's gun targeting
func handle_targeting_object(target_node : Node2D):
	target = tank.to_local(target_node.global_position)
	

# Handles ordering the tank to fire when reloaded and aimed 
# then restoring fire order to false
func handle_fire_order():
	if tank.aimed and tank.reloaded:
		print("Issuing fire order!")
		fire_order = true
	else:
		fire_order = false

# Handles obtaining movement target
func handle_navigation():
	nav_agent.set_target_location(movement_target)
	pass
