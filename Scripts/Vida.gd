class_name Vida
extends Node

## Valor máximo de pontos de vida
@export var vida_max : int = 0
var vida_atual : int = 0

func _ready() -> void:
	# Inicia vida_atual no início do jogo
	vida_atual = vida_max

# FUNÇÃO PARA DIMINUIR VIDA
func recebe_dano(dano:Ataque) -> void:
	vida_atual -= dano.dano

# FUNÇÃO PARA AUMENTAR VIDA
func recebe_cura(cura:int) -> void:
	vida_atual += cura
