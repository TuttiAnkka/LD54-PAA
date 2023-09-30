extends Area2D

var direction: Vector2 = Vector2.ZERO
var damage_player = false
@export var speed = 300


func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Enemy") && !damage_player:
		body.get_node("HealthComponent")._take_damage(100)
		queue_free()
	if body.is_in_group("Player") && damage_player:
		get_tree().get_root().find_node("GameManager").gas -= 10
		queue_free()

