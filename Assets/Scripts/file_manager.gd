extends Node

func _ready():
	save(150)

func save(content: int):
	var old_score: int = load_game()
	print("Old highscore: ", old_score)
	print("New highscore: ", content)
	if old_score != null:
		if old_score > content:
			return
	
	print("Saving new highscore, it was higher ", content)
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_var(content)
	file = null

func load_game():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if file == null: return null
	var content: int = int(file.get_var())
	return content
