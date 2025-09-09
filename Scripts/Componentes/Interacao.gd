class_name Interacao
extends Area2D

## Objeto a ser interagido
@export var objeto_interacao: InteractObject = null

# Armazena se está dentro
var dentro: bool = false
# Armazena o player
var target: CharacterBody2D = null
var pode_interagir: bool = true

# CONECTA SINAIS DE ENTRADA/SAÍDA
func _ready() -> void:
	connect("body_entered", Entrou)
	connect("body_exited", Saiu)

# CHECA INPUT DE INTERAÇÃO
func _input(_event: InputEvent) -> void:
	if !dentro or !pode_interagir: return
	if objeto_interacao and Input.is_action_just_pressed("interagir"): 
		objeto_interacao.Interact(target)

# CHECA SE PLAYER ENTROU NA ÁREA DE INTERAÇÃO
func Entrou(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("DENTRO INTERACT")
		target = body
		dentro = true
		objeto_interacao.Extra(true)

# CHECA SE PLAYER SAIU DA ÁREA DE INTERAÇÃO
func Saiu(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("FORA INTERACT")
		dentro = false
		objeto_interacao.Extra(false)
