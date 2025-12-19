extends Node2D

func _ready() -> void:
	$PoeiraAtaque.connect("finished", _on_particulas_folha_finished)
	$PoeiraAtaque.emitting = true

func _on_particulas_folha_finished() -> void:
	queue_free()
