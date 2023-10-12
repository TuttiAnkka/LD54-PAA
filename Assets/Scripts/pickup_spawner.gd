extends Node2D
# Ask joona
# Should pickups change after a certain time, even if player hasn't bought them?

var spawn_time: float = 30
var pickup: PackedScene = preload("res://Scenes/pickup.tscn")
var current_pickup = null

func _ready():
	spawn_pickup()
	await get_tree().create_timer(spawn_time).timeout
	spawn_pickup()
	
func spawn_pickup():
	# If we want to change it so that the pickup changes whether or not it exists, just do current_pickup.queuefree()
	# Then continue function normally.
	if current_pickup: return
	
	var pup = pickup.instantiate()
	current_pickup = pup
	pup.type = randi_range(0, 6)
	add_child(pup)
	pup.global_position = global_position

	await get_tree().create_timer(spawn_time).timeout
	
	spawn_pickup()
	
	
func _process(delta):
	print(current_pickup == null)
