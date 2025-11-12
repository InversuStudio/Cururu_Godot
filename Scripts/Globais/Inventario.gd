extends Node

enum Itens {
	Acai,
	Guarana,
}

const lista_itens:Dictionary = {
	"Acai" : preload("res://Objetos/Inventario/InvAcai.tscn"),
	"Guarana" : preload("res://Objetos/Inventario/InvGuarana.tscn"),
}

signal add_item
signal del_item

var inventario:Array[Array] = []

func AddItem(item:String, num:int = 1) -> void:
	if inventario.size() >= 15:
		Console._Print("[color=orange][b]INVENTÁRIO CHEIO[/b][/color]")
		return
		
	var tem_item:bool = false
	var itm_id:int = 0
	for i:Array in inventario:
		if i.has(item):
			tem_item = true
			break
		itm_id += 1
			
	if tem_item:
		inventario[itm_id][1] += 1
		add_item.emit(item, false)
	else:
		inventario.append([item, num])
		add_item.emit(item, true)

func RemoveItem(id:int) -> void:
	inventario[id][1] -= 1
	if inventario[id][1] <= 0:
		inventario.remove_at(id)
	del_item.emit(id)
	
func Reset() -> void:
	inventario = [
	["Acai", 1],
	["Guarana", 1],
]
