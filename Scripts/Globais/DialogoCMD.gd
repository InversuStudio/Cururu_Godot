extends Node

const balao:PackedScene = preload("res://Dialogos/BalaoFala.tscn")
var voz:AudioStream = null

func IniciaDialogo(res:DialogueResource) -> void:
	DialogueManager.show_dialogue_balloon_scene(balao, res)

func AddItem(nome:String, desc:String, img_path:String) -> void:
	var img:Texture2D = null
	if img_path != "":
		img = load(img_path)
	AvisoItem.Mostra(nome, desc, img)

func AddMapa() -> void:
	Inventario.tem_mapa = true
	AvisoItem.Mostra(
		"Mapa",
		"Você recebeu o mapa da Mata Atlântica! Pressione BTN para abrí-lo.",
		load("res://Sprites/Cenário/Objetos/Upgrade/MAPA.png"),
		"select")
