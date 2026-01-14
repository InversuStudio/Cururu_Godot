extends InteractObject

@export var arquivo_dialogo: DialogueResource = null
@export var dialogue_start: String = "start"
@export var interacao: Interacao = null
var balao = preload("res://Dialogos/BalaoFala.tscn")
var falando:bool = false

func _ready() -> void:
	interacao.objeto_interacao = self
	DialogueManager.dialogue_ended.connect(PodeInteragir)
	%Texto.hide()

func Interact(player:CharacterBody2D) -> void:
	%Texto.hide()
	interacao.pode_interagir = false
	player.input_move.x = 0.0
	player.velocity.x = 0.0
	player.pode_mover = false
	player.pode_ataque = false
	DialogueManager.show_dialogue_balloon_scene(balao, arquivo_dialogo, dialogue_start)
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(.5).timeout
	player.pode_ataque = true

func PodeInteragir(_res:DialogueResource) -> void:
	%Texto.show()
	interacao.pode_interagir = true
	interacao.target.pode_mover = true

func Extra(dentro:bool) -> void:
	if dentro:
		%Texto.show()
	else:
		%Texto.hide()
