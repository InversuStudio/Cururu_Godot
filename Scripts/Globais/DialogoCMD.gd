extends Node

const balao:PackedScene = preload("res://Dialogos/BalaoFala.tscn")

func IniciaDialogo(res:DialogueResource) -> void:
	DialogueManager.show_dialogue_balloon_scene(balao, res)

func AddItem(nome:String, desc:String, img_path:String) -> void:
	#get_tree().get_first_node_in_group("BalaoFala").hide()
	var img:Texture2D = null
	if img_path != "":
		img = load(img_path)
	AvisoItem.Mostra(nome, desc, img)
	#get_tree().get_first_node_in_group("BalaoFala").show()

func AddMapa() -> void:
	#get_tree().get_first_node_in_group("BalaoFala").hide()
	Inventario.tem_mapa = true
	AvisoItem.Mostra("Mapa", "Você recebeu o mapa da Mata Atlântica. Aperte LT para se guiar.", load("res://Sprites/Cenário/Objetos/Upgrade/MAPA.png"))
	#get_tree().get_first_node_in_group("BalaoFala").show()
