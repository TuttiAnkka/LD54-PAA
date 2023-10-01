extends AnimatedSprite2D

# 8 move dirs to choose from.
var directions = [
Vector2.LEFT, Vector2.RIGHT, 
Vector2.UP, Vector2.DOWN, 
Vector2.RIGHT + Vector2.UP,
Vector2.RIGHT + Vector2.DOWN,
Vector2.LEFT + Vector2.UP,
Vector2.LEFT + Vector2.DOWN]

@export var decay_time = 0.85
@export var rotation_speed = 2
@export var lerp_speed = 25

func _enter_tree():
	var random = randf_range(0.75, 1)
	scale.x = random
	scale.y = random

func _process(delta):
	#position += directions[randi_range(0, 7)]
	position = lerp(position, position+directions[randi_range(0, 7)], lerp_speed * delta)
	scale.x -= decay_time * delta
	scale.y -= decay_time * delta
	rotation += rotation_speed * delta
	
	if scale.x < 0.1:
		queue_free()
