class_name Vida
extends Node

## Valor máximo de pontos de vida
@export var vida_max : int = 0
var vida_atual : int = 0

# Sinal emite com 2 valores: vida_antiga, vida_atual
signal alterou_vida

func _ready() -> void:
	vida_atual = vida_max
	if get_parent().is_in_group("Player"):
		GameData.vida_max = vida_max
		# Inicia vida_atual no início do jogo
		if GameData.vida_atual == 0:
			GameData.vida_atual = vida_max
		else:
			vida_atual = GameData.vida_atual

# FUNÇÃO PARA DIMINUIR VIDA
func RecebeDano(dano:int) -> void:
	alterou_vida.emit(vida_atual - dano, vida_atual)
	vida_atual -= dano
	vida_atual = clampi(vida_atual, 0, vida_max)
	# Se vida for zerada, morre
	if vida_atual <= 0:
		Morre()

# FUNÇÃO PARA AUMENTAR VIDA
func RecebeCura(cura:int) -> void:
	alterou_vida.emit(vida_atual + cura, vida_atual)
	vida_atual += cura
	vida_atual = clampi(vida_atual, 0, vida_max)

# FUNÇÃO DE MORRER
func Morre():
	print("MORRI")
	if get_parent().has_method("Morte"):
		get_parent().Morte()
	else:
		get_parent().queue_free()
