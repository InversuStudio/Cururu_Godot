extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sinal não tava conectado :p
	$Particulas_Folha.connect("finished", _on_particulas_folha_finished)
	$Particulas_Folha.emitting = true

func _on_particulas_folha_finished() -> void:
	queue_free()
