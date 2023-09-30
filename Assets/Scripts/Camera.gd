extends Camera2D

@onready var player = $"../Player"
@export var speed: float = 10.0
@export var position_offset: float = 100.0

func _physics_process(delta):
	var target_pos = player.global_position + (player.transform.x.normalized() * position_offset)
	#global_position = lerp(global_position, target_pos, speed * delta) # Lerp doesn't seem to be needed here, since we want camera to stay on player.
	global_position = target_pos

