extends Sprite2D


func _process(delta):
	
	scale.x -= 0.85 * delta
	scale.y -= 0.85 * delta
	
	if scale.x <= 0.1:
		queue_free()
