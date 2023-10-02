extends Sprite2D


@export var destroy_on_collision: bool = true
var explosion = preload("res://Scenes/explosion.tscn")
@export var explosion_scale = 0.45
@export var spawn_explosion = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Player"):

		if spawn_explosion:
			var e = explosion.instantiate()
			get_node("/root/Main/GameManager").add_child(e)
			e.global_position = global_position
			e.scale.x = explosion_scale
			e.scale.y = explosion_scale
		
		if not destroy_on_collision:
			frame = 1
			return
			
		queue_free()
