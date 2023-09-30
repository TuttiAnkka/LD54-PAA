extends Sprite2D

@export var damage: float = 25.0
@export var boost_damage: float = 50.0
var boost: bool = false
@onready var player = $"../.."


func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		if not visible: return
		# TODO: Deal damage to enemy, and add velocity. Damage should change whether we're using boost or not.
		# Get healthcomponent. deal damage to that.
		var dmg = boost_damage if boost else damage
		var enemy = body
		enemy.get_node("HealthComponent")._take_damage(dmg)
		enemy.backwards_force(boost, player.transform.x);
