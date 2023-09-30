extends Sprite2D

var damage: float = 10.0
var boost_damage: float = 25.0

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		# TODO: Deal damage to enemy, and add velocity. Damage should change whether we're using boost or not.
		queue_free()
