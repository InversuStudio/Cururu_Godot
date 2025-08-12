extends InteractObject

@export var arquivo_dialogo: DialogueResource = null
@export var dialogue_start: String = "start"
@export var interacao: Interacao = null
var balao = preload("res://Dialogos/balloon.tscn")

func _ready() -> void:
	interacao.objeto_interacao = self
	DialogueManager.dialogue_ended.connect(PodeInteragir)

func Interact(player:CharacterBody2D) -> void:
	interacao.pode_interagir = false
	player.pode_mover = false
	player.input_move = 0.0
	var b = balao.instantiate()
	get_tree().current_scene.add_child(b)
	b.start(arquivo_dialogo, dialogue_start)

func PodeInteragir(_res:DialogueResource) -> void:
	interacao.pode_interagir = true
	interacao.target.pode_mover = true
