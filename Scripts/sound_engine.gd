extends Node

@onready var sound_players = get_children()


func play_sound(sound_name: AudioStreamMP3):
	for player in sound_players:
		if !player.is_playing():
			player.set_stream(sound_name)
			player.play()
			
