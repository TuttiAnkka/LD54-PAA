extends Sprite2D

@export var damage: float = 25.0
@export var boost_damage: float = 50.0
var boost: bool = false
@onready var player = $"../.."
var colliding_enemies: Array = []
var crash = preload("res://Scenes/crash.tscn")
@onready var hit_point = $HitPoint


func _physics_process(delta):
	if not colliding_enemies.is_empty():
		for i in range(colliding_enemies.size()):
			colliding_enemies[i].backwards_force(boost, player.transform.x);

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		if not visible: return
		
		colliding_enemies.append(body)
		
		var dmg = boost_damage if boost else damage
		var enemy = body
		enemy.get_node("HealthComponent")._take_damage(dmg)
		#enemy.backwards_force(boost, player.transform.x);
		AudioManager.play("res://Assets/Audio/Crash.wav")
		
		var e2 = crash.instantiate()
		get_node("/root/Main/GameManager").add_child(e2)
		e2.global_position = hit_point.global_position
		e2.scale.x = 1
		e2.scale.y = 1

func _on_area_2d_body_exited(body):
	if body.is_in_group("Enemy"):
		colliding_enemies.remove_at(colliding_enemies.find(body))
