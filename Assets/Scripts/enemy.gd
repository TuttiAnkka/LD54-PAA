extends CharacterBody2D

var current_direction: Vector2 = Vector2.LEFT
@export var new_dir_time: float = 1.25
@export var rotation_speed: float = 0.045
var rotation_dir: int = 1 # 0 and 1 for left and right 
var can_turn: bool = true
@export var speed: float = 100
var crashing: bool = false
var can_shoot = true
var spread_amount = 0.05
@export var bullet_speed = 200
@export var turret_timer = 2

# 8 move dirs to choose from.
var directions = [Vector2.LEFT, Vector2.RIGHT, 
Vector2.UP, Vector2.DOWN, 
Vector2.RIGHT + Vector2.UP,
Vector2.RIGHT + Vector2.DOWN,
Vector2.LEFT + Vector2.UP,
Vector2.LEFT + Vector2.DOWN]

@onready var sprite = $Sprite2D
@onready var weapon_pivot = $WeaponPivot
@onready var bullet_spawn = $WeaponPivot/Gun/BulletSpawn
var player = null
var bullet = preload("res://Scenes/bullet.tscn")
var pickup = preload("res://Scenes/pickup.tscn")

func _enter_tree():
	player = get_node("/root/Main/Player")

func _physics_process(delta):
	
	#if position.distance_to(player.position) > 2000:
	#	position = get_node("/root/Main/GameManager").get_spawn_position()
	
	rotate_sprite()
	#sprite.position = position # This needs to be enabled once you get final sprites.	
	drive_randomly(delta)
	aim_at_player(delta)
	shoot()
	
func drive_randomly(delta):
	
	if not crashing:
		velocity = transform.x.normalized() * speed * delta * 100
	move_and_slide()
	
	# If we're not facing the currently selected direction, keep turning towards that direction.
	if transform.x.dot(current_direction) < 0.98 && can_turn: 
		rotation = get_rotation() + (rotation_dir * rotation_speed)
	elif transform.x.dot(current_direction) > 0.98 && can_turn:
		can_turn = false
		await get_tree().create_timer(new_dir_time * randf_range(0.85, 1.15)).timeout # Drive straight for a while.
		get_new_direction()
	

func aim_at_player(delta):
	weapon_pivot.look_at(player.position)

func get_new_direction():
	current_direction = directions[randi() % directions.size()] # Get a random direction from array.
	rotation_dir = 1 if coin_toss() else -1
	can_turn = true
	
func coin_toss() -> int:
	randomize()
	var value := randi() % 2 # will be 0 or 1
	return (value == 1)

func rotate_sprite():
	# Comparing our current forward direction to world right vector.
	if transform.x.dot(Vector2.RIGHT) < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
func backwards_force(boost, direction):
	var crash_velocity = 1250 if boost else 650
	crashing = true
	can_turn = false
	velocity = direction * 550
	await get_tree().create_timer(0.2).timeout # Drive straight for a while.
	crashing = false
	get_new_direction()
	

func shoot():
	if not can_shoot: return
	if position.distance_to(player.position) > 600: return
	can_shoot = false
	
	var b = bullet.instantiate()
	get_node("/root/Main/GameManager").add_child(b)
	b.damage_player = true
	b.speed = bullet_speed
	b.global_position = bullet_spawn.global_position
	var dir = (player.global_position - b.global_position).normalized()
	b.direction = dir ##+ (weapon_pivot.transform.y * randf_range(-spread_amount, spread_amount))
	
	await get_tree().create_timer(turret_timer * randf_range(0.85, 1.15)).timeout
	can_shoot = true
	
	

func _on_health_component_on_damage_taken():
	# Play some sound maybe, spawn particles etc.
	pass # Replace with function body.

func _on_health_component_on_death():
	# Randomized chance to spawn an upgrade, money or nothing.
	# Also particles.
	var p = pickup.instantiate()
	var random = randi_range(0, 4)
	match random:
		0:
			p.type = p.types.money
			print("money")
			pass
		1:
			p.type = p.types.speed
			print("speed")
			pass
		2:
			p.type = p.types.gas
			print("gas")
			pass
		3:
			p.type = p.types.shotgun
			print("shotgun")
			pass
		4:
			p.type = p.types.rifle
			print("rifle")
			pass
	
	get_node("/root/Main/GameManager").add_child(p) #get_tree().root.
	p.global_position = global_position
	
	queue_free()
	pass # Replace with function body.
