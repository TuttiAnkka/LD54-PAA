extends Area2D

var direction: Vector2 = Vector2.ZERO
@export var speed = 300

func _physics_process(delta):
	position += direction * speed * delta
	


func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		# TODO: Deal damage to enemy, or destroy it.
		queue_free()

