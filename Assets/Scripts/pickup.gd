extends Node2D

enum types {shotgun, rifle, boost_cooldown, boost_duration, speed, money, gas}
@export var type: types = types.shotgun
@export var price: int = 0

@export var boost_cooldown_multiplier_change: float = 0.1
@export var boost_duration_multiplier_change: float = 0.1
@export var speed_multiplier_change: float = 0.1

@onready var game_manager = $"../GameManager"

func _on_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player"):
		if game_manager.money >= price && type != types.money:
			game_manager.money -= price
			picked_up(body)
		elif type == types.money:
			picked_up(body)
		
func picked_up(player):
	match type:
		types.shotgun:
			player.change_weapon_status(true, true)
			pass
		types.rifle:
			player.change_weapon_status(true, false)
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
		types.money:
			game_manager.money += 1
			print(game_manager.money)
			pass
		types.gas:
			game_manager.gas += 25
	
	queue_free()
	#TODO, play sound here with audiomanager..
	
