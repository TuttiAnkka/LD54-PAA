extends CharacterBody2D

var current_direction: Vector2 = Vector2.LEFT
@export var new_dir_time: float = 1.25
@export var rotation_speed: float = 0.045
var rotation_dir: int = 1 # 0 and 1 for left and right 
var can_turn: bool = true
@export var speed: float = 100
var crashing: bool = false
var can_shoot = false
var spread_amount = 0.05
@export var bullet_speed = 200
@export var turret_timer = 2

# 8 move dirs to choose from.
var directions = [
Vector2.LEFT, Vector2.RIGHT, 
Vector2.UP, Vector2.DOWN, 
Vector2.RIGHT + Vector2.UP,
Vector2.RIGHT + Vector2.DOWN,
Vector2.LEFT + Vector2.UP,
Vector2.LEFT + Vector2.DOWN]

@onready var drop_shadow = $AnimationPivot/DropShadow
@onready var mesh2d = $AnimationPivot/Enemy_Pete
@onready var animation_pivot = $AnimationPivot
@onready var sprite = $Sprite2D
@onready var weapon_pivot = $WeaponPivot
@onready var bullet_spawn = $WeaponPivot/Gun/BulletSpawn
var player = null
var bullet = preload("res://Scenes/bullet.tscn")
var pickup = preload("res://Scenes/pickup.tscn")
var dying = false
@onready var gun_sound = $AudioStreamPlayer2D
@onready var smoke_emitter = $SmokeEmitter
var explosion = preload("res://Scenes/explosion.tscn")

var spawned = false
@onready var ray1 = $Rays/RayCast2D
@onready var ray2 = $Rays/RayCast2D2
@onready var ray3 = $Rays/RayCast2D3
@onready var ray4 = $Rays/RayCast2D4

var tween = null
var tween_speed = 0.15

func _ready():
	tween_bopping(true)

func _enter_tree():
	player = get_node("/root/Main/Player")
	
	var normalised_directions = directions
	#print("not normal ", normalised_directions)
	for i in range(normalised_directions.size()):
		normalised_directions[i] = normalised_directions[i].normalized()
	#print("normal ", normalised_directions)
	directions = normalised_directions
	#print("new dirs ", directions)
	
	spawned = true
	await get_tree().create_timer(0.15).timeout # Just to make sure raycasts are getting through
	spawned = false
	mesh2d.visible = true
	weapon_pivot.visible = true
	smoke_emitter.visible = true
	drop_shadow.visible = true
	await get_tree().create_timer(1.75).timeout # Just to make sure raycasts are getting through
	can_shoot = true

func _physics_process(delta):
	
	if global_position.distance_to(player.global_position) > 2500:
		global_position = get_node("/root/Main/GameManager").get_spawn_position()
	
	rotate_sprite()
	animation_pivot.position = position # This needs to be enabled once you get final sprites.	
	drive_randomly(delta)
	aim_at_player(delta)
	shoot()
	
	if spawned:
		#print("asd")
		if ray1.is_colliding():
			#print("asd2")
			if ray1.get_collider() is TileMap:
				print("Stuck")
				position = get_node("/root/Main/GameManager").get_spawn_position()
				return
		if ray2.is_colliding():
			#print("asd2")
			if ray2.get_collider() is TileMap:
				print("Stuck")
				position = get_node("/root/Main/GameManager").get_spawn_position()
				return
		if ray3.is_colliding():
			#print("asd2")
			if ray3.get_collider() is TileMap:
				print("Stuck")	
				position = get_node("/root/Main/GameManager").get_spawn_position()
				return
		if ray4.is_colliding():
			#print("asd2")
			if ray4.get_collider() is TileMap:
				position = get_node("/root/Main/GameManager").get_spawn_position()
				return
				print("Stuck")
				
func tween_bopping(reverse: bool):
	tween = create_tween() # Creates a new tween
	if reverse:
		tween.tween_property(mesh2d, "position:y", 2, tween_speed)
	else:
		tween.tween_property(mesh2d, "position:y", 0, tween_speed)
	
	await get_tree().create_timer(tween_speed).timeout
	tween_bopping(!reverse)
	
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
	#if transform.x.dot(Vector2.RIGHT) < 0:
	#	sprite.flip_h = true
	#else:
	#	sprite.flip_h = false
		
	var shadermat = mesh2d.material
	match get_closest_direction_vector():
		0:
			shadermat.set_shader_parameter("Direction", 4)
			drop_shadow.frame = 4
			#print("left")
		1:
			shadermat.set_shader_parameter("Direction", 0)
			drop_shadow.frame = 0
			#print("right")
		2:
			shadermat.set_shader_parameter("Direction", 6)
			drop_shadow.frame = 6
			#print("up")
		3:
			shadermat.set_shader_parameter("Direction", 2)
			drop_shadow.frame = 2
			#print("down")
		4:
			shadermat.set_shader_parameter("Direction", 7)
			drop_shadow.frame = 7
			#print("right up")
			pass
		5:
			shadermat.set_shader_parameter("Direction", 1)
			drop_shadow.frame = 1
			#print("right down")
			pass
		6:
			shadermat.set_shader_parameter("Direction", 5)
			drop_shadow.frame = 5
			#print("left up")
			pass
		7:
			shadermat.set_shader_parameter("Direction", 3)
			drop_shadow.frame = 3
			#print("left down")
			pass
	


func get_closest_direction_vector() -> int:
	
	#print(transform.x.normalized())
	var forward = transform.x.normalized()
	var closest_direction: Vector2
	var number: int
	for i in range(directions.size()):
		#print(transform.x.normalized().distance_to(directions[0]))
		
		#print(i, " Dot to: ", forward.dot(directions[i].normalized()))
		if i == 0:
			closest_direction = directions[0]
			number = i
		if forward.dot(directions[i]) > forward.dot(closest_direction):
			closest_direction = directions[i]
			number = i
			#print("Closest Dot ", forward.dot(directions[i].normalized()))
			
	#print(closest_direction)
	return number
		
func backwards_force(boost, direction):
	var crash_velocity = 950 if boost else 550
	crashing = true
	can_turn = false
	velocity = direction * crash_velocity
	await get_tree().create_timer(0.2).timeout # Drive straight for a while.
	crashing = false
	get_new_direction()
	

func shoot():
	if not can_shoot: return
	if position.distance_to(player.position) > 600: return
	can_shoot = false
	
	gun_sound.play()
	
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
	if dying: return
	dying = true
	
	var e = explosion.instantiate()
	get_node("/root/Main/GameManager").add_child(e)
	e.global_position = global_position
	
	AudioManager.play("res://Assets/Audio/Explosion.wav")
	print("Death")
	var p = pickup.instantiate()
	var random = randi_range(0, 11)
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
		5:
			p.type = p.types.gas
			print("gas")
			pass		
		6: 
			p.type = p.types.boost_cooldown
			print("boost cooldown")
			pass
		7:
			p.type = p.types.boost_duration
			print("boost duration")
			pass
		8:
			p.type = p.types.gas
			print("gas")
			pass	
		9:
			p.type = p.types.gas
			print("gas")
			pass	
		10,11:
			print("Nothing")			
			p.queue_free()
			pass
	
	get_node("/root/Main/GameManager").add_child(p) #get_tree().root.
	p.global_position = global_position
	
	queue_free()
	pass # Replace with function body.
