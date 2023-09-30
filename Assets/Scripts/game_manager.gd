extends Node

# Game Properties
enum game_state { running, death, paused }
var current_state = game_state.running
var game_time: float = 0
var money: int = 0
var gas: float = 100

# UI
@onready var death_ui= $"../CanvasLayer/Death"
@onready var paused_ui = $"../CanvasLayer/Paused"



func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta):
	if Input.is_action_just_pressed("pause") && current_state == game_state.running:
		get_tree().paused = true
		current_state = game_state.paused
		paused_ui.visible = true
		
	if not get_tree().paused:
		game_time += delta
		#gas -= delta
		#print(gas)
		
		if gas <= 0:
			current_state = game_state.death
			get_tree().paused = true
			death_ui.visible = true

func _on_restart_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
	current_state = game_state.running
	
func _on_exit_pressed():
	get_tree().quit()
	
func _on_continue_pressed():
	get_tree().paused = false
	paused_ui.visible = false
	current_state = game_state.running
