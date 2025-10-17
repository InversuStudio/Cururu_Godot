extends Area2D

## Item a ser adicionado ao inventário
@export var tipo_item: Inventario.Itens

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Inventario.AddItem(tipo_item)
		queue_free()
