class_name BGM_Player
extends Node

## Música a ser tocada no fundo
@export var musica:AudioStream = null
## Volume da música, em db
@export var volume:float = 0.0

func _ready() -> void:
	BGM.TocaMusica(musica, volume)
