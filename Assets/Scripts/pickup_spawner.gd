extends Node2D
# Ask joona
# Should pickups change after a certain time, even if player hasn't bought them?
@export var spawn_time: float = 15
var pickup: PackedScene = preload("res://Scenes/pickup.tscn")
var current_pickup = null
var timer_running: bool = false

func _ready():
	spawn_pickup()
	
func _process(delta):
	if current_pickup == null && not timer_running:
		timer_running = true
		await get_tree().create_timer(spawn_time).timeout
		spawn_pickup()
		
func spawn_pickup():
	timer_running = false
	var pup = pickup.instantiate()
	current_pickup = pup
	pup.type = randi_range(0, 6)
	add_child(pup)
	pup.global_position = global_position
