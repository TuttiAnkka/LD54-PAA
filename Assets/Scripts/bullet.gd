extends Area2D

var direction: Vector2 = Vector2.ZERO
var damage_player = false
@export var speed = 300
var manager = null

@onready var ray = $RayCast2D

func _enter_tree():
	manager = get_node("/root/Main/GameManager")
	await get_tree().create_timer(3).timeout # Destroy timer.
	queue_free()


func _physics_process(delta):
	position += direction * speed * delta
	look_at(global_position+direction) #global_position+
	
	if ray.is_colliding():
		if ray.get_collider() is TileMap:
			queue_free()	

func _on_body_entered(body):
	if body.is_in_group("Enemy") && !damage_player:
		body.get_node("HealthComponent")._take_damage(100)
		queue_free()
	if body.is_in_group("Player") && damage_player:
		manager.gas -= 10
		queue_free()

