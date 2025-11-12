extends Node

enum Itens {
	Acai,
	Guarana,
}

const lista_itens:Dictionary = {
	"Acai" : preload("res://Objetos/Inventario/Acai.tscn"),
	"Guarana" : preload("res://Objetos/Inventario/Guarana.tscn"),
}

#signal inventario_atualizado

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
		print("CHECANDO")
		if i.has(item):
			tem_item = true
			print("TEM ITEM")
			break
		itm_id += 1
			
	if tem_item:
		inventario[itm_id][1] += 1
		add_item.emit(item, false)
	else:
		inventario.append([item, num])
		add_item.emit(item, true)
	print(inventario)
	#inventario_atualizado.emit("add", item)

func RemoveItem(id:int) -> void:
	inventario[id][1] -= 1
	if inventario[id][1] <= 0:
		inventario.remove_at(id)
	del_item.emit(id)
	#inventario_atualizado.emit("del", id)
	
func Reset() -> void:
	inventario = [
	["Acai", 1],
	["Guarana", 1],
]
