extends KinematicBody2D

export var starting_health = 10
export var default_speed = 15
export var default_rotation_speed = 20
export var default_gun_rotation_speed = 0.5
export var default_reload_time = 3.0
export var bullet : PackedScene = preload("res://Bullet.tscn")
export var barrel_animation : PackedScene = preload("res://BarrelAnimation.tscn")
export var explosion_animation : PackedScene = preload("res://Explosion.tscn")

var affiliation
var tank_sprite : Texture
var gun_sprite : Texture
var health
var current_velocity
var speed
var rotation_speed
var gun_rotation_speed
var reload_time
var reloaded : bool
var reload_timer
var current_bullets = []
var aimed = false
var rng = RandomNumberGenerator.new()

var director : Node
var gun : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	if tank_sprite != null:
		$TankSprite.texture = tank_sprite
	if gun_sprite != null:
		$GunSprite.texture = gun_sprite
	health = starting_health
	speed = default_speed
	rotation_speed = default_rotation_speed
	gun_rotation_speed = default_gun_rotation_speed
	reload_time = default_reload_time
	reloaded = false
	current_velocity = 0
	gun = $Gun
	director = $Director
	reload_timer = $ReloadTimer
	reload_timer.wait_time = reload_time
	reload_timer.start()
	affiliation = director.affiliation
	


# Called for each frame, delta stands for change in time
func _process(delta):
	rotation_degrees += handle_rotation() * delta
	current_velocity = handle_velocity(current_velocity)
	var velocity_vector = Vector2(
		cos(rotation),
		sin(rotation)
		) * current_velocity
	var _collision_data = move_and_collide(velocity_vector)
	gun.rotation += handle_gun_rotation() * delta
	gun.rotation = clamp_gun_rotation()
	if director.fire_order and reloaded:
		current_bullets.append(fire_bullet())
	handle_animation()
	if health <= 0:
		commit_die()


# Handles change in angle of the tank
func handle_rotation():
	var delta_angle = 0
	if director.movement["turn left"]:
		delta_angle -= 1
	if director.movement["turn right"]:
		delta_angle += 1
	return delta_angle * rotation_speed


# Handles the velocity based on user input
func handle_velocity(last_velocity):
	var forward_velocity = last_velocity / speed
	if director.movement["move forward"]:
		forward_velocity += 0.01
	elif director.movement["move backward"]:
		forward_velocity -= 0.01
	else:
		forward_velocity = sign(forward_velocity) * (abs(forward_velocity) - 0.025)
		if abs(forward_velocity) < 0.025:	# Prevents the velocity from oscillating near zero
			forward_velocity = 0
	
	forward_velocity = clamp(forward_velocity, -1, 1)
	
	return forward_velocity * speed


func handle_gun_rotation():
	var target_position = director.target
	var current_gun_rotation = gun.rotation
	var target_rotation = acos(target_position.normalized().x) * sign(target_position.y)
	var delta_theta = 0
	if abs(rad2deg(current_gun_rotation - target_rotation)) < 0.5:
		gun.rotation = target_rotation
		aimed = true
	else:
		aimed = false
		if target_rotation > current_gun_rotation:
			if current_gun_rotation < target_rotation - PI:
				delta_theta = -1
			else:
				delta_theta = 1
		elif target_rotation < current_gun_rotation:
			if current_gun_rotation > target_rotation + PI:
				delta_theta = 1
			else:
				delta_theta = -1
	return delta_theta * gun_rotation_speed
	
	
func clamp_gun_rotation():
	if gun.rotation > PI:
		return -PI
	elif gun.rotation < -PI:
		return PI
	return gun.rotation


func fire_bullet():
	reloaded = false
	var new_bullet = bullet.instance()
	var muzzle_flash = barrel_animation.instance()
	add_child(new_bullet)
	$Gun.add_child(muzzle_flash)
	new_bullet.position = Vector2(
		cos(gun.rotation), sin(gun.rotation)
	) * 165.5
	new_bullet.rotation = gun.rotation + PI / 2
	new_bullet.fire()
	reload_timer.start()
	handle_barrel_animation(muzzle_flash)
	$TankSprite.position.x -= 3
	$Gun/GunSprite.position.x -= 5
	yield(get_tree().create_timer(0.5), "timeout")
	$TankSprite.position.x += 3
	$Gun/GunSprite.position.x += 5
	return new_bullet


func handle_animation():
	if current_velocity > 0:
		$TankSprite.position.x = -(current_velocity / speed) * 5
		$RTrack.play("forward")
		$LTrack.play("forward")
	elif current_velocity < 0:
		$TankSprite.position.x = -(current_velocity / speed) * 5
		$RTrack.play("backward")
		$LTrack.play("backward")
	elif director.movement["turn left"]:
		$RTrack.play("forward")
		$LTrack.play("backward")
	elif director.movement["turn right"]:
		$RTrack.play("backward")
		$LTrack.play("forward")
	else:
		$TankSprite.position.x = 0
		$RTrack.stop()
		$LTrack.stop()


func handle_barrel_animation(animation_node : AnimatedSprite):
	animation_node.play()
	print("playing muzzle flash")
	animation_node.connect("animation_finished", self, "_on_barrel_animation_finished")


func commit_die():
	director.set_script(load("res://GenericDirector.gd"))
	var explosion
	for n in range(rng.randi_range(1, 3)):
		explosion = explosion_animation.instance()
		add_child(explosion)
		explosion.position = Vector2(
			rng.randi_range(-128, 128),
			rng.randi_range(-128, 128)
		)
		var ex_scale = rng.randf_range(0.125, 0.75)
		explosion.scale = Vector2(
			ex_scale,
			ex_scale
		)
		explosion.play()
		yield(get_tree().create_timer(rng.randf_range(1, 2)), "timeout")
	queue_free()
	

func _on_barrel_animation_finished():
	$Gun/BarrelAnimation.queue_free()


func _on_ReloadTimer_timeout():
	reloaded = true


func received_hit_from(hostile_tank : Node):
	print("Registered hit from hostile tank")
