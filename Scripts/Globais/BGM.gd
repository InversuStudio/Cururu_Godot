extends AudioStreamPlayer

func TocaMusica(musica:AudioStream = null, volume:float= 0.0) -> void:
	if musica:
		if stream != musica:
			stream = musica
			volume_db = volume
			play()
	else:
		stop()
