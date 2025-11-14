extends Control

func _ready() -> void:
	# Conecta sinais do inventário
	Inventario.add_amuleto.connect(AddAmuleto)
	
	visibility_changed.connect(func():
		if visible:
			if %Inv.get_child_count() > 0:
				%Inv.get_child(0).grab_focus()
			else:
				MostraAmuleto("",""))
	
	# Instancia itens do inventário
	var item_id:int = 0
	for i:Array in Inventario.amuletos:
		var item:Amuleto = Inventario.lista_amuletos[i[0]].instantiate()
		item.id_inventario = item_id
		item_id += 1
		%Inv.add_child(item)
	
	%NomeInv.text = ""
	%DescInv.text = ""

# MOSTRA ITEM DO INVENTÁRIO
func MostraAmuleto(nome:String, desc:String) -> void:
	%NomeInv.text = nome
	%DescInv.text = desc

# FUNÇÃO DE ADICIONAR ITEM
func AddAmuleto(item:String) -> void:
	var itm:Amuleto = Inventario.lista_amuletos[item].instantiate()
	itm.id_inventario = %Inv.get_child_count()
	%Inv.add_child(itm)
