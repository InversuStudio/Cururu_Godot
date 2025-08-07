class_name Vida
extends Node

## Valor máximo de pontos de vida
@export var vida_max : int = 0
var vida_atual : int = 0

signal recebeu_dano
signal recebeu_vida
signal morreu

func _ready() -> void:
	GameData.vida_max = vida_max
	# Inicia vida_atual no início do jogo
	if GameData.vida_atual == 0:
		vida_atual = vida_max
		GameData.vida_atual = vida_max
	else:
		vida_atual = GameData.vida_atual

# FUNÇÃO PARA DIMINUIR VIDA
func RecebeDano(dano:int) -> void:
	vida_atual -= dano
	vida_atual = clampi(vida_atual, 0, vida_max)
	GameData.vida_atual = vida_atual
	recebeu_dano.emit()
	# Se vida for zerada, morre
	if vida_atual <= 0:
		morreu.emit()
		if get_parent().has_method("Morte"):
			get_parent().Morte()
		else: Morre()

# FUNÇÃO PARA AUMENTAR VIDA
func RecebeCura(cura:int) -> void:
	vida_atual += cura
	vida_atual = clampi(vida_atual, 0, vida_max)
	GameData.vida_atual = vida_atual
	recebeu_vida.emit()

# FUNÇÃO DE MORRER
func Morre():
	print("MORRI")
	get_parent().queue_free()
