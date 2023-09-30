extends Node2D
signal on_death
signal on_damage_taken
var health = 10
@export var max_health = 10

func _ready():
	health = max_health

func _take_damage(amount):
	health -= amount
	emit_signal("on_damage_taken")
	if health <= 0:
		emit_signal("on_death")
		

