extends RigidBody2D

const BulletAnimation = preload("res://BulletAnimation.tscn")
var TankClass

export var initial_bullet_velocity = 500
export var default_bullet_damage = 1
export var bullet_sprite : Texture

var rotation_on_hit

var parent_tank


# Called when the node enters the scene tree for the first time.
func _ready():
	TankClass = load("res://Tank.gd")
	parent_tank = get_parent()


func fire():
	$CollisionShape2D.disabled = true
	var relative_rotation = parent_tank.rotation + parent_tank.gun.rotation
	linear_velocity = initial_bullet_velocity * Vector2(cos(relative_rotation), sin(relative_rotation))
	yield(get_tree().create_timer(0.1), "timeout")
	$CollisionShape2D.disabled = false


func _on_Bullet_body_entered(body : Node):
	rotation_on_hit = rotation
	if body == parent_tank:
		return
	if body is TankClass:
		body.health -= 1
		print("Bonk " + String(body.health))
		body.received_hit_from(parent_tank)
	else:
		print("Hit not a tank")
	rotation = rotation_on_hit
	var hit_animation = BulletAnimation.instance()
	body.add_child(hit_animation)
	hit_animation.position = body.to_local(parent_tank.to_global(position))
	hit_animation.rotation = rotation - body.rotation
	hit_animation.play()
	queue_free()
