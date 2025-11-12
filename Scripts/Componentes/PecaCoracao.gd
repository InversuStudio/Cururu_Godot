extends Area2D

@export var id:Mundos.PecasCoracao

func _ready() -> void:
	if Mundos.pecas_coracao[id] == true:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Mundos.pecas_coracao[id] = true
		GameData.peca_coracao += 1
		queue_free()
