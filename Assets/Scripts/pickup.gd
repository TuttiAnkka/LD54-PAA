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

# Get animated sprite frame, based on current enum turned into int..
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var drop_shadow = $DropShadow
var tween = null
var tween_speed = 0.35

func _enter_tree():
	game_manager = get_node("/root/Main/GameManager")
func _ready():
	tween_bopping(true)
	
	game_manager = get_node("/root/Main/GameManager")
	print(type)
	
	animated_sprite_2d.frame = type
	drop_shadow.frame = type
	
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
	
func tween_bopping(reverse: bool):
	tween = create_tween() # Creates a new tween
	if reverse:
		tween.tween_property(animated_sprite_2d, "position:y", -8, tween_speed)
	else:
		tween.tween_property(animated_sprite_2d, "position:y", 0, tween_speed)
	
	await get_tree().create_timer(tween_speed).timeout
	tween_bopping(!reverse)

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
			player.change_weapon_status(true, true, 1)
			game_manager.display_subtitle_text("{ SHOTGUN PICKUP }")
			AudioManager.play("res://Assets/Audio/GunPickup.wav")
			pass
		types.rifle:
			player.change_weapon_status(true, false, 2)
			game_manager.display_subtitle_text("{ RIFLE PICKUP }")
			AudioManager.play("res://Assets/Audio/GunPickup.wav")
			pass
		types.boost_cooldown:
			if(player.boost_cooldown_multiplier >= 0.5): player.boost_cooldown_multiplier -= 0.1
			game_manager.display_subtitle_text("{ BOOST COOLDOWN REDUCED }")
			AudioManager.play("res://Assets/Audio/BoostCooldown.wav")
			pass
		types.boost_duration:
			if(player.boost_duration_multiplier <= 1.5): player.boost_duration_multiplier += 0.1
			game_manager.display_subtitle_text("{ BOOST UPGRADE }")
			AudioManager.play("res://Assets/Audio/BoostUpgrade.wav")
			pass
		types.speed:
			if (player.speed_multiplier <= 1.5): player.speed_multiplier += 0.1
			game_manager.display_subtitle_text("{ SPEED UPGRADE }")
			AudioManager.play("res://Assets/Audio/SpeedUpgrade.wav")
			pass
		types.money:
			game_manager.change_money(1, true)
			print(game_manager.money)
			pass
		types.gas:
			game_manager.change_gas(35, true)
			game_manager.display_subtitle_text("{ GAS TANK FILLED }")
			AudioManager.play("res://Assets/Audio/GasTankFilled.wav")
	
	queue_free()
	#TODO, play sound here with audiomanager..
	
