extends CharacterBody2D

var current_direction: Vector2 = Vector2.LEFT
@export var new_dir_time: float = 1.25
@export var rotation_speed: float = 0.045
var rotation_dir: int = 1 # 0 and 1 for left and right 
var can_turn: bool = true
@export var speed: float = 100
var crashing: bool = false
var can_shoot = true

# 8 move dirs to choose from.
var directions = [Vector2.LEFT, Vector2.RIGHT, 
Vector2.UP, Vector2.DOWN, 
Vector2.RIGHT + Vector2.UP,
Vector2.RIGHT + Vector2.DOWN,
Vector2.LEFT + Vector2.UP,
Vector2.LEFT + Vector2.DOWN]

@onready var sprite = $Sprite2D

func _physics_process(delta):
	rotate_sprite()
	#sprite.position = position
	print(transform.x)
	#might have to switch to charactercontroller, since move_and_slide has built in collision detection.
	#position += transform.x * speed * delta
	
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
	
func get_new_direction():
	current_direction = directions[randi() % directions.size()] # Get a random direction from array.
	rotation_dir = 1 if coin_toss() else -1
	can_turn = true
	
func coin_toss() -> int:
	randomize()
	var value := randi() % 2 # will be 0 or 1
	print(value == 1)
	return (value == 1)

func rotate_sprite():
	# Comparing our current forward direction to world right vector.
	if transform.x.dot(Vector2.RIGHT) < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
func backwards_force(boost, direction):
	var crash_velocity = 950 if boost else 550
	crashing = true
	can_turn = false
	velocity = direction * 550
	await get_tree().create_timer(0.2).timeout # Drive straight for a while.
	crashing = false
	get_new_direction()
	

func shoot():
	if not can_shoot: return
	can_shoot = false
	# Instantiate bullet, make it fly towards player.

func _on_health_component_on_damage_taken():
	# Play some sound maybe, spawn particles etc.
	pass # Replace with function body.

func _on_health_component_on_death():
	# Randomized chance to spawn an upgrade, money or nothing.
	# Also particles.
	queue_free()
	pass # Replace with function body.
