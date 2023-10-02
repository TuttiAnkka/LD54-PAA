extends Sprite2D


func _process(delta):
	
	scale.x -= 1 * delta
	scale.y -= 1 * delta
	
	if scale.x <= 0.1:
		queue_free()
