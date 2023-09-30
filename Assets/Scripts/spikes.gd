extends Sprite2D

var damage: float = 10.0
var boost_damage: float = 25.0
var boost: bool = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		# TODO: Deal damage to enemy, and add velocity. Damage should change whether we're using boost or not.
		# Get healthcomponent. deal damage to that.
		var enemy = body
		#enemy.get_node("healthcomponent")._take_damage(2)
		enemy.backwards_force(boost, transform.x);
