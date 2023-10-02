extends Area2D

var direction: Vector2 = Vector2.ZERO
var damage_player = false
@export var speed = 300
var manager = null

@onready var ray = $RayCast2D
var flame = preload("res://Scenes/flame.tscn")
var explosion = preload("res://Scenes/explosion.tscn")

func _enter_tree():
	manager = get_node("/root/Main/GameManager")
	await get_tree().create_timer(3).timeout # Destroy timer.
	queue_free()


func _physics_process(delta):
	position += direction * speed * delta
	look_at(global_position+direction) #global_position+
	
	if ray.is_colliding():
		if ray.get_collider() is TileMap:
			AudioManager.play("res://Assets/Audio/BulletHit.wav")
			var e = explosion.instantiate()
			get_node("/root/Main/GameManager").add_child(e)
			e.global_position = global_position
			e.scale.x = 0.55
			e.scale.y = 0.55
			queue_free()
			

func _on_body_entered(body):
	if body.is_in_group("Enemy") && !damage_player:
		AudioManager.play("res://Assets/Audio/BulletHit.wav")
		body.get_node("HealthComponent")._take_damage(100)
		
		var e = flame.instantiate()
		get_node("/root/Main/GameManager").add_child(e)
		e.global_position = global_position
		
		var e2 = explosion.instantiate()
		get_node("/root/Main/GameManager").add_child(e2)
		e2.global_position = global_position
		e2.scale.x = 0.55
		e2.scale.y = 0.55
		
		
		queue_free()
	if body.is_in_group("Player") && damage_player:
		AudioManager.play("res://Assets/Audio/BulletHit.wav")
		
		var e = flame.instantiate()
		get_node("/root/Main/GameManager").add_child(e)
		e.global_position = global_position
		
		var e2 = explosion.instantiate()
		get_node("/root/Main/GameManager").add_child(e2)
		e2.global_position = global_position
		e2.scale.x = 0.55
		e2.scale.y = 0.55
		
		manager.change_gas(10, false)
		
		queue_free()

