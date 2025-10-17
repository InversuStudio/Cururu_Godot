extends Node

enum Itens {
	ItemCura,
}

const lista_itens:Array[PackedScene] = [
	#"item_cura" : 
	preload("res://Objetos/Inventario/ItemCura.tscn"),
]

signal inventario_atualizado
var inventario:Array[Array] = [
	[lista_itens[0], false],
	[lista_itens[0], false],
]

func AddItem(item:int, desabilitado:bool = false) -> void:
	if inventario.size() >= 15:
		Console._Print("[color=orange][b]INVENTÁRIO CHEIO[/b][/color]")
	inventario.append([lista_itens[item], desabilitado])
	inventario_atualizado.emit("add", item)

func HabilitaItem(id_item:int, disabled:bool = false) -> void:
	inventario[id_item][1] = disabled

func RemoveItem(id:int) -> void:
	inventario.remove_at(id)
	inventario_atualizado.emit("del", id)
	
func Reset() -> void:
	inventario = [
	[lista_itens[0], false],
	[lista_itens[0], false],
]
