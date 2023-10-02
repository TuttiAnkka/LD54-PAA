extends AnimatedSprite2D

@export var down_scale = false
@export var decay_time = 0.25

func _ready():
	play("default")
	
	
func _process(delta):
	if frame == 9:
		queue_free()
		
	if down_scale:
		scale.x -= decay_time * delta
		scale.y -= decay_time * delta
		
	if scale.x <= 0.1:
		queue_free()

