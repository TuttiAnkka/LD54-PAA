extends Node2D

@export var spread: float = 10
@export var frequency: float = 0.1
@export var current_frame: int = 15

var manager = null
var since_last_change = 0
var known_health = 96
@export var health_based = false

@onready var animated_sprite_2d = $AnimatedSprite2D
var smoke = preload("res://Scenes/smoke.tscn")

func _ready():
	if health_based:
		manager = get_node("/root/Main/GameManager")
		manager.on_gas_changed.connect(change_smoke_sprite)
		
	emit_smoke()
	
func emit_smoke():
	var s = smoke.instantiate()
	add_child(s)
	s.global_position = global_position + Vector2(randf_range(-spread, spread), randf_range(-spread, spread))
	s.frame = current_frame
	await get_tree().create_timer(frequency).timeout
	emit_smoke()
	pass
	
func change_smoke_sprite():
	since_last_change = known_health - manager.gas

	if since_last_change <= -6:
		known_health += 6
		current_frame += 1
		change_smoke_sprite()
		return
	elif since_last_change >= 6:
		known_health -= 6
		current_frame -= 1
		change_smoke_sprite()
		return

func _process(delta):
	animated_sprite_2d.frame = current_frame

