extends AudioStreamPlayer

# Arraste o som para este slot no Inspector
@export var som_recurso : AudioStream 

func disparar_som():
	if not playing:
		stream = som_recurso
		play()
