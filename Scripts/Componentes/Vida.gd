class_name Vida
extends Node

## Valor máximo de pontos de vida
@export var vida_max : int = 0
var vida_atual : int = 0

signal recebeu_dano

func _ready() -> void:
	# Inicia vida_atual no início do jogo
	vida_atual = vida_max

# FUNÇÃO PARA DIMINUIR VIDA
func recebe_dano(dano:int) -> void:
	recebeu_dano.emit()
	vida_atual -= dano
	# Se vida for zerada, morre
	if vida_atual <= 0:
		if get_parent().has_method("morte"):
			get_parent().morte()
		else: morre()

# FUNÇÃO PARA AUMENTAR VIDA
func recebe_cura(cura:int) -> void:
	vida_atual += cura

# FUNÇÃO DE MORRER
func morre():
	print("MORRI")
	get_parent().queue_free()
