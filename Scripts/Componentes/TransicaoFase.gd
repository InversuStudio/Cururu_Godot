extends Area2D

## Define se transição é vertical ou horizontal
@export var vertical: bool = false
## Lugar a ser enviado, para ser salvo
@export var destino: Mundos.NomeFase
## Posição onde será spawnado na próxima fase
@export var posicao: Vector2 = Vector2.ZERO
# Se o Player spawna virado à esquerda
var virado_a_esquerda: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Não faz transição se player estiver morto
		if GameData.vida_atual <= 0: return
		# Desabilita controle do player
		body.pode_mover = false
		# Armazena direção que player está olhando
		virado_a_esquerda = body.sprite.flip_h
		# Se for transição vertical
		if vertical:
			if body.velocity.y <= 0.0:
				GameData.veio_de_baixo = true
				body.velocity.y = -body.jump_force
				body.input_move = 0.0
		else:
			match virado_a_esquerda:
				false:
					body.input_move = 1.0
				true:
					body.input_move = -1.0
				
		Mundos.CarregaFase(destino, true, posicao, virado_a_esquerda)
