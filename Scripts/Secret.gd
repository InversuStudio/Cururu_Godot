class_name Secret
extends Area2D

## Sprite/Tilemap que esconde a área
@export var area_escondida: Node2D = null
var dentro: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		dentro = true
			
func _on_body_exited(body: Node2D) -> void:
	if  body.is_in_group("Player"):
		dentro = false

func _process(delta: float) -> void:
	# "Animação" de fade
	if dentro == true: area_escondida.self_modulate.a = move_toward(
		area_escondida.self_modulate.a, 0.0, delta * 10)
	else: area_escondida.self_modulate.a = move_toward(
		area_escondida.self_modulate.a, 1.0, delta * 10)
