extends Sprite2D

@onready var player = $"../.."
var bullet = preload("res://Scenes/bullet.tscn")
@onready var bullet_spawn = $BulletSpawn

@export var bullets: int = 20
var spread: bool = true
var canshoot: bool = true

@export var spread_amount: float = 0.25

func _process(delta):

	if Input.is_action_just_pressed("shoot") && canshoot:
		#TODO: spawn bullet/bullets
		canshoot = false
		
		if spread:
			AudioManager.play("res://Assets/Audio/Shotgun.wav")
			for i in range(bullets):
				# Shooting sound
				# Animation
				var b = bullet.instantiate()
				get_tree().root.add_child(b)
				b.global_position = bullet_spawn.global_position
				b.speed = b.speed * randf_range(0.8, 1.2)
				b.direction = player.transform.x + (player.transform.y * randf_range(-spread_amount, spread_amount))
		else:
			for i in range(bullets):
				AudioManager.play("res://Assets/Audio/Rifle.wav")
				# Animation
				var b = bullet.instantiate()
				get_tree().root.add_child(b)
				b.global_position = bullet_spawn.global_position
				#b.speed = b.speed * randf_range(0.8, 1.2)
				b.direction = player.transform.x
				await get_tree().create_timer(0.15).timeout
			
		# Wait for animation to finish before doing this.
		player.change_weapon_status(false, false, 1)
		
		
func _ready():
	set_process(false)
