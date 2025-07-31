class_name Secret
extends Area2D

## Sprite/Tilemap que esconde a área
@export var area_escondida: Node2D = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		area_escondida.hide()
			
func _on_body_exited(body: Node2D) -> void:
	if  body.is_in_group("Player"):
		area_escondida.show()
