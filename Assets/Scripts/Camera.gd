extends Camera2D

@onready var player = $"../Player"
@export var speed: float = 10.0
@export var position_offset: float = 100.0

func _physics_process(delta):
	#var target_pos_x = player.global_position.x + (player.transform.x * 10)
	#var target_pos_y = player.global_position.y + (player.transform.y * 10)
	
	var target_pos = player.global_position + (player.transform.x.normalized() * position_offset)
	
	global_position = lerp(global_position, target_pos, speed * delta)
	#global_position.y = lerp(global_position.y, target_pos_y, speed * delta)
