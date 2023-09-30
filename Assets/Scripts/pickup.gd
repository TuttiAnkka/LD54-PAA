extends Node2D

enum types {weapon, boost_cooldown, boost_duration, speed, money}
@export var type: types = types.weapon
@export var price: int = 0

@export var boost_cooldown_multiplier_change: float = 0.1
@export var boost_duration_multiplier_change: float = 0.1
@export var speed_multiplier_change: float = 0.1

func _on_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player"):
		if GameManager.money >= price && type != types.money:
			GameManager.money -= price
			picked_up(body)
		elif type == types.money:
			picked_up(body)
		
func picked_up(player):
	match type:
		types.weapon:
			player.enable_weapon()
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
			GameManager.money += 1
			print(GameManager.money)
			pass
	
	queue_free()
	#TODO, play sound here with audiomanager..
	
