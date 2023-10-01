extends Node2D

var bills: Array[Sprite2D] = [Sprite2D.new(), Sprite2D.new(), Sprite2D.new(), Sprite2D.new()]
var manager = null

func _ready():
	bills.insert(0, find_child("Money"))
	bills.insert(1, find_child("Money2"))
	bills.insert(2, find_child("Money3"))
	bills.insert(3, find_child("Money4"))
	print(bills)
	
	for i in range(bills.size()):
		var bill = bills[i]
		print(bill)
		bill.visible = false
	
	manager = get_node("/root/Main/GameManager")
	manager.on_money_changed.connect(change_money_display)
	
func change_money_display():
	for i in range(bills.size()):
		if i > manager.money:
			bills[i].visible = false
		else:
			bills[i].visible = true
		
	

