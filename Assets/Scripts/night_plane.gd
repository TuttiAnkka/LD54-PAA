extends MeshInstance2D

@export var cycle_speed: float = 30
var reversing = false
var tween = null

func _ready():
	day_cycle(false)
	pass
	
func day_cycle(reverse: bool):
	print("Start new cycle ",reverse)
	tween = create_tween() # Creates a new tween
	if reverse:
		tween.tween_property(self, "material:shader_parameter/DarknessMutiplier", 0.0, cycle_speed)
	else:
		tween.tween_property(self, "material:shader_parameter/DarknessMutiplier", 1.5, cycle_speed)
	
	await get_tree().create_timer(cycle_speed).timeout
	day_cycle(!reverse)
	

