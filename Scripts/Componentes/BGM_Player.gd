class_name BGM_Player
extends Node

## Música a ser tocada no fundo
@export var musica:AudioStream = null
## Volume da música
@export_range(0.0, 2.0) var volume:float = 1.0

func _ready() -> void:
	BGM.TocaMusica(musica, volume)
