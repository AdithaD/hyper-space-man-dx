extends Node

func play_sound_and_free(location : Vector2, stream: AudioStream) -> void:
	var audio_player := AudioStreamPlayer2D.new()
	
	audio_player.global_position = location
	audio_player.stream = stream
	
	add_child(audio_player)
	
	audio_player.play()
	
	await audio_player.finished
	audio_player.queue_free()
	
