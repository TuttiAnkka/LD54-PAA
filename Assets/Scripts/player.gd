extends CharacterBody2D

# Car Movement Properties
@export var speed: float = 100.0
@export var boost_speed: float = 200.0
@export var boost_cooldown: float = 1.0
@export var boost_duration: float = 0.5
@export var rotation_speed: float = 1000
var current_speed: float = 100.0

# Car Upgrade Multipliers
var boost_cooldown_multiplier: float = 1.0
var boost_duration_multiplier: float = 1.0
var speed_multiplier: float = 1.0

# Booleans
var can_boost = true

# References
@onready var anim = $AnimatedSprite2D
@onready var spikes = $WeaponPivot/Spikes
@onready var weapon = $WeaponPivot/Weapon


func _ready():
	current_speed = speed
	print(speed)

func _physics_process(delta):
	movement(delta)
	anim.position = position

func movement(delta):
	
	# Turning the car.
	var turning = Input.get_axis("ui_left", "ui_right")
	rotation = get_rotation() + (turning * rotation_speed)
	
	# Moving the car.
	velocity = transform.x.normalized() * current_speed * delta * 100 * speed_multiplier
	move_and_slide()
	
	rotate_sprite()
	boost()
	
func rotate_sprite():
	# Comparing our current forward direction to world right vector.
	if transform.x.dot(Vector2.RIGHT) < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
		
	# TODO:
	# We also need to compare to UP vector here..
	# If less than 0, means we're going down. That way we can combine up and down directions to select right sprite
	
func boost():
	if Input.is_action_just_pressed("boost") && can_boost:
		can_boost = false
		current_speed = boost_speed
		await get_tree().create_timer(boost_duration * boost_duration_multiplier).timeout # Boost duration timer.
		current_speed = speed
		await get_tree().create_timer(boost_cooldown * boost_cooldown_multiplier).timeout # Boost cooldown timer.
		can_boost = true
		
func change_weapon_status(status: bool, spread: bool):
	spikes.set_process(!status)
	spikes.visible = !status
	weapon.set_process(status)
	weapon.visible = status
	weapon.spread = spread
	weapon.canshoot = status
