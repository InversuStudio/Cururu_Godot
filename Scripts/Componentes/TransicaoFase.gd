extends Area2D

## Define se transição é vertical ou horizontal
@export var vertical: bool = false
## Caminho do arquivo da fase a ser carregada
@export var destino:StringName = ""
## Posição onde será spawnado na próxima fase
@export var posicao: Vector2 = Vector2.ZERO
# Se o Player spawna virado à esquerda
var virado_a_esquerda: bool = false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Não faz transição se player estiver morto
		if GameData.vida_atual <= 0: return
		# Desabilita controle do player
		body.pode_mover = false
		# Armazena direção que player está olhando
		GameData.direcao = true if body.sprite.flip_h else false
		# Se for transição vertical
		if vertical:
			if body.velocity.y <= 0.0:
				GameData.veio_de_baixo = true
				body.velocity.y = -body.jump_force
				body.input_move.x = 0.0
		else:
			match GameData.direcao:
				false:
					body.input_move.x = 1.0
				true:
					body.input_move.x = -1.0
				
		LoadCena.Load(destino, true, posicao)
