extends Node2D

enum types {shotgun, rifle, boost_cooldown, boost_duration, speed, money, gas}
@export var type: types = types.shotgun
@export var price: int = 0

@export var boost_cooldown_multiplier_change: float = 0.1
@export var boost_duration_multiplier_change: float = 0.1
@export var speed_multiplier_change: float = 0.1

var game_manager = null
@onready var money_pivot = $MoneyPivot
@onready var money = $MoneyPivot/Money
@onready var money_2 = $MoneyPivot/Money2
@onready var money_3 = $MoneyPivot/Money3
@onready var money_4 = $MoneyPivot/Money4


func _enter_tree():
	game_manager = get_node("/root/Main/GameManager")
func _ready():
	game_manager = get_node("/root/Main/GameManager")
	
	if price > 0:
		money.visible = true
	if price > 1:
		money_2.visible = true
	if price > 2:
		money_3.visible = true
	if price > 3:
		money_4.visible = true
	
func _process(delta):
	money_pivot.rotation = money_pivot.get_rotation() + 3 * delta


func _on_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player"):
		if game_manager.money >= price && type != types.money:
			game_manager.change_money(price, false)
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
			game_manager.change_money(1, true)
			print(game_manager.money)
			pass
		types.gas:
			game_manager.change_gas(25, true)
	
	queue_free()
	#TODO, play sound here with audiomanager..
	
