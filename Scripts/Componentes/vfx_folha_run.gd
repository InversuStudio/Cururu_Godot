extends Node2D
var flip:bool = false

func _ready() -> void:
	$GramaCorre.connect("finished", _on_particulas_folha_finished)
	$GramaCorre.emitting = true

func set_flip(value: bool) -> void:
	flip = value
	$GramaCorre.direction.x = 1 if flip else -1

func _on_particulas_folha_finished() -> void:
	queue_free()
