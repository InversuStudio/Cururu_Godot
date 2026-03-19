extends InteractObject

@export var arquivo_dialogo: DialogueResource = null
@export var dialogue_start: String = "start"
@export var interacao: Interacao = null
@export var vozes:Array[AudioStream] = []
var balao:PackedScene = preload("res://Dialogos/BalaoFala.tscn")

func _ready() -> void:
	interacao.objeto_interacao = self
	DialogueManager.dialogue_ended.connect(PodeInteragir)
	DialogueManager.got_dialogue.connect(Voz)
	%Texto.hide()
	%Texto.z_index = 100

func Interact() -> void:
	%Texto.hide()
	interacao.pode_interagir = false
	Mundos.player.input_move.x = 0.0
	Mundos.player.velocity.x = 0.0
	Mundos.player.pode_mover = false
	Mundos.player.pode_ataque = false
	DialogueManager.show_dialogue_balloon_scene(balao, arquivo_dialogo, dialogue_start)

func PodeInteragir(_res:DialogueResource) -> void:
	%Texto.show()
	await get_tree().create_timer(.5).timeout
	interacao.pode_interagir = true
	Mundos.player.pode_mover = true
	Mundos.player.pode_ataque = true

func Voz(_l:DialogueLine) -> void:
	if vozes.size() > 0:
		var id:int = randi_range(0, vozes.size() - 1)
		DialogoCMD.voz = vozes[id]

func Extra(dentro:bool) -> void:
	if dentro:
		%Texto.show()
	else:
		%Texto.hide()
