extends Node

# Game Properties
enum game_state { running, death, paused }
var current_state = game_state.paused
var game_time: float = 0
var money: int = 0
var gas: float = 96
@onready var player = $"../Player"
signal on_money_changed
signal on_gas_changed

# Enemy Spawning
@export var enemy_spawn_frequency: float = 3
@export var max_distance_from_player: float = 3000
var enemy = preload("res://Scenes/enemy.tscn")
var can_spawn = true
# Enemies should spawn every frequency seconds if there are less than max enemies.
# If enemy gets too far from player, teleport it closer.

# UI
@onready var death_ui= $"../CanvasLayer/Death"
@onready var paused_ui = $"../CanvasLayer/Paused"
@onready var main_menu_ui = $"../CanvasLayer/MainMenu"
@onready var score = $"../CanvasLayer/Death/Score"
@onready var high_score = $"../CanvasLayer/Death/HighScore"

func _ready():
	consume_fuel()
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	print("Highscore: ", FileManager.load_game())
	
func consume_fuel():
	await get_tree().create_timer(1).timeout
	change_gas(1, false)
	print("Fuel is: ", gas)
	consume_fuel()

func _process(delta):
	if Input.is_action_just_pressed("pause") && current_state == game_state.running:
		get_tree().paused = true
		current_state = game_state.paused
		paused_ui.visible = true
		
	if not get_tree().paused:
		spawn_enemies()
		game_time += delta
		
		#Everytime this is called for a full 1.0, call change_health instead.
		#gas -= delta
		#print(gas)
		
		if gas <= 0:
			current_state = game_state.death
			get_tree().paused = true
			death_ui.visible = true
			var score_rounded = "%.0f" % game_time
			score.text = "Score: " + str(score_rounded)
			FileManager.save(score_rounded)
			high_score.text = "Highscore: " + str(FileManager.load_game()) 
			
func spawn_enemies():
	if not can_spawn: return
	can_spawn = false
	print("Spawned an enemy")
	var e = enemy.instantiate()
	add_child(e) #get_tree().root.
	e.global_position = get_spawn_position()
	e.spawned = true
	
	await get_tree().create_timer(enemy_spawn_frequency).timeout # Boost cooldown timer.
	can_spawn = true

func get_spawn_position() -> Vector2:
	#Get player pos and look around in a random dir 400-700 pixels away. find if that place is obstructed somehow...
	var random_pos: Vector2 = player.global_position# + Vector2(randf_range(100, 1), randf_range(100, 175))
	
	if coin_toss():
		random_pos.x += randf_range(215, 275)
	else:
		random_pos.x -= randf_range(215, 275)
		
	if coin_toss():
		random_pos.y += randf_range(155, 215)
	else:
		random_pos.y -= randf_range(155, 215)
	
	#random_pos.x = -random_pos.x if coin_toss() else random_pos.x
	#random_pos.y = -random_pos.y if coin_toss() else random_pos.y
	
	#Raycast down from random pos. if it hits a tile, do get_spawn_position again and return
	
	return random_pos
	
func coin_toss() -> int:
	randomize()
	var value := randi() % 2 # will be 0 or 1
	return (value == 1)
	
func change_gas(amount: int, add: bool):
	if get_tree().paused: return
	
	if add:
		gas += amount
		gas = min(gas, 100)
	else:
		gas -= amount
		gas = max(gas, 0)
	emit_signal("on_gas_changed")

func change_money(amount: int, add: bool):
	if add:
		money += amount
		money = min(money, 4)
	else:
		money -= amount
		money = max(money, 0)
	emit_signal("on_money_changed")

func _on_restart_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
	current_state = game_state.running
	
func _on_exit_pressed():
	get_tree().quit()
	
func _on_continue_pressed():
	get_tree().paused = false
	paused_ui.visible = false
	main_menu_ui.visible = false
	current_state = game_state.running
