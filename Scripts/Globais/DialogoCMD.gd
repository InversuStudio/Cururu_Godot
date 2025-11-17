extends Node

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
	AvisoItem.Mostra("Mapa", "Sou um mapa!", load("res://icon.svg"))
	#get_tree().get_first_node_in_group("BalaoFala").show()
