extends CharacterBody2D

# Car Movement Properties
@export var speed: float = 100.0
@export var boost_speed: float = 200.0
@export var boost_cooldown: float = 1.0
@export var boost_duration: float = 0.5
@export var rotation_speed: float = 1000
var current_speed: float = 100.0
var death_speed: float = 0.5

# Car Upgrade Multipliers
var boost_cooldown_multiplier: float = 1.0
var boost_duration_multiplier: float = 1.0
var speed_multiplier: float = 1.0

var flame = preload("res://Scenes/flame.tscn")
@onready var smoke_emitter = $SmokeEmitter
var tyre_marks = preload("res://Scenes/tyremarks.tscn")

# Booleans
var can_boost = true
var dying = false

# References
@onready var anim = $AnimatedSprite2D
@onready var spikes = $WeaponPivot/Spikes
@onready var weapon = $WeaponPivot/Weapon
@onready var car_sound = $AudioStreamPlayer

# 8 move dirs to choose from.
var directions = [
Vector2.LEFT, Vector2.RIGHT, 
Vector2.UP, Vector2.DOWN, 
Vector2.RIGHT + Vector2.UP,
Vector2.RIGHT + Vector2.DOWN,
Vector2.LEFT + Vector2.UP,
Vector2.LEFT + Vector2.DOWN]

func _ready():
	current_speed = speed
	
	
	var normalised_directions = directions
	#print("not normal ", normalised_directions)
	for i in range(normalised_directions.size()):
		normalised_directions[i] = normalised_directions[i].normalized()
	#print("normal ", normalised_directions)
	directions = normalised_directions
	#print("new dirs ", directions)
	#print(speed)

func _physics_process(delta):
	movement(delta)
	anim.position = position

func movement(delta):
	
	
	# Turning the car.
	var turning = Input.get_axis("left", "right")
	rotation = get_rotation() + (turning * rotation_speed)
	
	# Moving the car.
	velocity = transform.x.normalized() * current_speed * delta * 100 * speed_multiplier
	move_and_slide()
	
	rotate_sprite()
	
	if dying:
		current_speed -= death_speed
		car_sound.stop()
		
		if current_speed <= 10:
			get_node("/root/Main/GameManager").player_death() 
			
		return
	boost()
	
func rotate_sprite():
	# Comparing our current forward direction to world right vector.
	#if transform.x.dot(Vector2.RIGHT) < 0:
	#	anim.flip_h = true
	#else:
	#	anim.flip_h = false
		
	match get_closest_direction_vector():
		0:
			anim.frame = 4
			#print("left")
		1:
			anim.frame = 0
			#print("right")
		2:
			anim.frame = 6
			#print("up")
		3:
			anim.frame = 2
			#print("down")
		4:
			anim.frame = 7
			#print("right up")
			pass
		5:
			anim.frame = 1
			#print("right down")
			pass
		6:
			anim.frame = 5
			#print("left up")
			pass
		7:
			anim.frame = 3
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
	
func boost():
	if Input.is_action_just_pressed("boost") && can_boost:
		can_boost = false
		current_speed = boost_speed
		spikes.boost = true
		car_sound.pitch_scale = 3.5
		boost_flames(15, 0)
		await get_tree().create_timer(boost_duration * boost_duration_multiplier).timeout # Boost duration timer.
		current_speed = speed
		spikes.boost = false
		car_sound.pitch_scale = 1.5
		await get_tree().create_timer(boost_cooldown * boost_cooldown_multiplier).timeout # Boost cooldown timer.
		can_boost = true
		
func boost_flames(times, current):
	if current == times: return
	var e = tyre_marks.instantiate()
	get_node("/root/Main/GameManager").add_child(e)
	e.global_position = smoke_emitter.global_position# + Vector2(randf_range(-10,10), randf_range(-10, 10))
	e.rotation = rotation
	
	await get_tree().create_timer(0.05).timeout
	boost_flames(times, current+1)
		
func change_weapon_status(status: bool, spread: bool, frame: int):
	if weapon.visible == status: return
	
	spikes.set_process(!status)
	spikes.visible = !status
	weapon.set_process(status)
	weapon.frame = frame
	weapon.visible = status
	weapon.spread = spread
	weapon.canshoot = status


