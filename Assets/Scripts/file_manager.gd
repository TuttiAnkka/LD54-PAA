extends Node

func save(content):
	var old_score = load_game()
	if old_score != null:
		if old_score > content:
			return
	
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_var(content)
	file = null

func load_game():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if file == null: return null
	var content = file.get_var()
	return content
