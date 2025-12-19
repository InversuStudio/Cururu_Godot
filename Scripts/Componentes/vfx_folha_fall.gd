extends Node2D

func _ready() -> void:
	$GramaQueda.connect("finished", _on_particulas_folha_finished)
	$GramaQueda.emitting = true

func _on_particulas_folha_finished() -> void:
	queue_free()
