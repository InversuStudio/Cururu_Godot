extends AudioStreamPlayer


## Lista de audios dos passos
@export var lista_de_passos: Array[AudioStream] = []

@onready var passos_player: AudioStreamPlayer = %SFX_Passos

func tocar_som_aleatorio():
	if lista_de_passos.is_empty():
		print("A lista de sons está vazia!")
		return

	# Sorteia um áudio da lista
	var som_sorteado = lista_de_passos.pick_random()
	
	# Atribui ao player e toca
	passos_player.stream = som_sorteado
	passos_player.play()
