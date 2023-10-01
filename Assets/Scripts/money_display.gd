extends Node2D

var bills: Array[Sprite2D] = [Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new()]
var manager = null

func _ready():
	#bills.insert(0, find_child("Money")) # This is here just to make the array 5 long, so the first index we're using is 0.
	bills.insert(1, find_child("Money"))
	bills.insert(2, find_child("Money2"))
	bills.insert(3, find_child("Money3"))
	bills.insert(4, find_child("Money4"))
	#print(bills)
	
	for i in range(bills.size()):
		bills[i].visible = false
	
	manager = get_node("/root/Main/GameManager")
	manager.on_money_changed.connect(change_money_display)
	
func change_money_display():
	for i in range(bills.size()):
		if i > manager.money:
			bills[i].visible = false
		else:
			bills[i].visible = true
			
func _physics_process(delta):
	position = get_parent().position
	rotation = get_rotation() + 5 * delta

