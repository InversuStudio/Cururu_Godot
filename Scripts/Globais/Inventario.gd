extends Node

const lista_itens:Dictionary = {
	"item_cura" : preload("res://Objetos/Inventario/ItemCura.tscn"),
}

var inventario:Array[Array] = [
	[lista_itens["item_cura"], false],
	[lista_itens["item_cura"], false],
]

func AddItem(item:String, desabilitado:bool = false) -> void:
	if inventario.size() >= 15:
		Console._Print("[color=orange][b]INVENTÁRIO CHEIO[/b][/color]")
	inventario.append([lista_itens[item], desabilitado])

func HabilitaItem(id_item:int, disabled:bool = false) -> void:
	inventario[id_item][1] = disabled

func RemoveItem(id:int) -> void:
	inventario.remove_at(id)
	
func Reset() -> void:
	inventario = [
	[lista_itens["item_cura"], false],
	[lista_itens["item_cura"], false],
]
