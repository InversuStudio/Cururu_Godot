extends Node2D

## Intervalo entre gotas em segundos
@export var intervalo: float = 3.0
## Cena da gota a ser spawnada
@export var cena_gota: PackedScene = null

@onready var _ponto_spawn: Marker2D = $Marker2D

func _ready() -> void:
	_agendar_proxima()

func _agendar_proxima() -> void:
	await get_tree().create_timer(intervalo).timeout
	_spawnar_gota()
	_agendar_proxima()

func _spawnar_gota() -> void:
	if cena_gota == null:
		return
	var gota: Node2D = cena_gota.instantiate()
	get_tree().current_scene.add_child(gota)
	gota.global_position = _ponto_spawn.global_position
