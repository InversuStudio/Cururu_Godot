extends Node

#region Itens
enum Itens {
	Acai,
	Guarana,
}

const ItensString:Array[String] = [
	"Acai",
	"Guarana"
]

const lista_itens:Dictionary = {
	"Acai" : preload("res://Objetos/Inventario/InvAcai.tscn"),
	"Guarana" : preload("res://Objetos/Inventario/InvGuarana.tscn"),
}

signal add_item
signal del_item
#endregion

#region Amuletos
enum Amuletos {
	VelAtaque,
	RecMagia,
}

const AmuletosString:Array[String] = [
	"VelAtaque",
	"RecMagia"
]

const lista_amuletos:Dictionary = {
	"VelAtaque" : preload("res://Objetos/Inventario/AmVelAtaque.tscn"),
	"RecMagia" : preload("res://Objetos/Inventario/AmRecMagia.tscn"),
}

signal add_amuleto
signal set_amuleto
#endregion

var inventario:Array[Array] = [] # [nome item, quantidade]
var amuletos:Array[Array] = [] # [nome amuleto, ativado]

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
	

func AddAmuleto(amuleto:String) -> void:
	for a:Array in amuletos:
		if a.has(amuleto): return
	
	amuletos.append([amuleto, true])
	add_amuleto.emit(amuleto)

func SetAmuleto(amuleto:String) -> bool:
	for a:Array in amuletos:
		if a.has(amuleto):
			a[1] = true if a[1] == false else false
			set_amuleto.emit()
			return a[1]
	return false

func Reset() -> void:
	inventario = [
	["Acai", 1],
	["Guarana", 1],
	]
	amuletos = [
		["RecMagia", true]
	]

func _input(_event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_KP_0):
		AddAmuleto("RecMagia")
		AddAmuleto("VelAtaque")
