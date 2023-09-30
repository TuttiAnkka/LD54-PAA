extends Node

#This could be expanded..
#Different audiobuses for each sound type which can be chosen when calling the .play()
#That would make controlling music/sound effects etc. super easy

var num_players = 8 # The amount of sounds that can play at once.
var bus = "Sounds" # Which bus to use in Audio tab.

var available = []  # The available players.
var queue = []  # The queue of sounds to play.


func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		
		#Bind a connection to _on_stream_finished from the created audioplayer, which is called when audio finishes playing.
		p.finished.connect(_on_stream_finished.bind(p)) 
		p.bus = bus


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func play(sound_path):
	queue.append(sound_path)


func _process(delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
