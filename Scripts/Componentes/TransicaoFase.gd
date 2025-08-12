extends Area2D

## Lugar a ser enviado, para ser salvo
@export var destino: Mundos.NomeFase
## Posição onde será spawnado na próxima fase
@export var posicao: Vector2 = Vector2.ZERO
## Se o Player spawna virado à esquerda
@export var virado_a_esquerda: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.pode_mover = false
		Mundos.CarregaFase(destino, true, posicao, virado_a_esquerda)
