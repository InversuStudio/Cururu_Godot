extends GridContainer

func _ready() -> void:
	# Conecta sinais do inventário
	Inventario.add_item.connect(AddItem)
	Inventario.del_item.connect(DelItem)
	# Instancia itens do inventário
	var item_id:int = 0
	for i:Array in Inventario.inventario:
		var item:ItemInventario = Inventario.lista_itens[i[0]].instantiate()
		item.num_item = i[1]
		item.UpdateNumItem()
		item.id_inventario = item_id
		item_id += 1
		add_child(item)

# FUNÇÃO DE ADICIONAR ITEM
func AddItem(item:String, novo_item:bool) -> void:
	# Se for um item novo que não estava no inventário...
	if novo_item:
		# ...o adiciona.
		var itm:ItemInventario = Inventario.lista_itens[item].instantiate()
		itm.id_inventario = get_child_count()
		add_child(itm)
	# Se não for novo...
	else:
		# ...encontra o item no inventário...
		var itm:ItemInventario = null
		for c:ItemInventario in get_children():
			if item == Inventario.ItensString[c.nome_item]:
				itm = c
				break
		# ...e sobe seu número.
		if itm:
			itm.num_item += 1
			itm.UpdateNumItem()

# FUNÇÃO DE REMOVER ITEM
func DelItem(id:int) -> void:
	# Encontra o item e diminui seu número
	var c:ItemInventario = get_child(id)
	c.num_item -= 1
	# Se seu novo número não for 0, função acaba.
	if c.num_item > 0: return
	
	# Se o item acabou, o remove do inventário...
	remove_child(get_child(id))
	# ...e o botão selecionado é outro do seu lado.
	var new_id:int = 0
	for i:ItemInventario in get_children():
		i.id_inventario = new_id
		new_id += 1
	if get_child_count() > 0:
		if get_child(id - 1):
			get_child(id - 1).grab_focus()
		elif get_child(id + 1):
			get_child(id + 1).grab_focus()
	# Se não houver outro item no inventário, a seleção vai para o botão Retornar
	else: %Retornar.grab_focus()
