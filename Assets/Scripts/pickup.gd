extends Node2D

enum types {weapon, boost_cooldown, boost_duration, speed}
@export var type: types = types.weapon

@export var boost_cooldown_multiplier_change = 0.1
@export var boost_duration_multiplier_change = 0.1
@export var speed_multiplier_change = 0.1

func _on_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player"):
		#TODO, add money check here. Probably should be handled by game_manager, not by playerscript
		picked_up(body)
		
func picked_up(player):
	match type:
		types.weapon:
			# TODO enable player weapon, hide spikes.
			pass
		types.boost_cooldown:
			player.get_node().boost_cooldown -= 0.1
			pass
		types.boost_duration:
			player.get_node().boost_duration -= 0.1
			pass
		types.speed:
			player.speed_multiplier += 0.1
			pass
	
	queue_free()
	#TODO, play sound here with audiomanager..
	
