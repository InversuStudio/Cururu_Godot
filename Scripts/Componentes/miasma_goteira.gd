extends Node2D

## Intervalo entre gotas em segundos (após a animação terminar)
@export var intervalo: float = 2.0
## Cena da gota a ser spawnada
@export var cena_gota: PackedScene = null

@onready var _ponto_spawn: Marker2D = $Marker2D
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	_agendar_proxima()

func _agendar_proxima() -> void:
	await get_tree().create_timer(intervalo).timeout
	_sprite.visible = true
	_sprite.play("default")
	await _sprite.animation_finished
	var gota: Node2D = cena_gota.instantiate()
	gota.global_position = _ponto_spawn.global_position
	_sprite.visible = false
	get_tree().current_scene.add_child(gota)
	_agendar_proxima()

func _spawnar_gota() -> void:
	if cena_gota == null:
		return
	var gota: Node2D = cena_gota.instantiate()
	gota.global_position = _ponto_spawn.global_position
	get_tree().current_scene.add_child(gota)
