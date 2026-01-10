extends Control

func _ready() -> void:
	# Conecta sinais do inventário
	Inventario.add_item.connect(AddItem)
	Inventario.del_item.connect(DelItem)
	
	visibility_changed.connect(func():
		if visible:
			GameData.menu_aberto = visible
			if %Inv.get_child_count() > 0:
				%Inv.get_child(0).grab_focus()
			else:
				MostraItem("",""))
	
	# Instancia itens do inventário
	var item_id:int = 0
	for i:Array in Inventario.inventario:
		var item:ItemInventario = Inventario.lista_itens[i[0]].instantiate()
		item.num_item = i[1]
		item.id_inventario = item_id
		item_id += 1
		%Inv.add_child(item)
	
	%NomeInv.text = ""
	%DescInv.text = ""

# MOSTRA ITEM DO INVENTÁRIO
func MostraItem(nome:String, desc:String, cura:int = 0, sprite:Texture2D = null) -> void:
	%NomeInv.text = nome
	%DescInv.text = desc
	for c:Control in %NumCura.get_children():
		c.queue_free()
	for c:int in cura:
		var img:TextureRect = TextureRect.new()
		img.texture = sprite
		img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		img.custom_minimum_size = Vector2(55.0, 73.0)
		img.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		%NumCura.add_child(img)

# FUNÇÃO DE ADICIONAR ITENS
func AddItem(item:String, num:int) -> void:
	var item_novo:bool = true
	var node_itm:ItemInventario = null
	for itm:ItemInventario in %Inv.get_children():
		if item == Inventario.ItensString[itm.item]:
			item_novo = false
			node_itm = itm
			break
	
	if item_novo:
		var itm:ItemInventario = Inventario.lista_itens[item].instantiate()
		itm.id_inventario = %Inv.get_child_count()
		itm.num_item = num
		%Inv.add_child(itm)
	else:
		node_itm.num_item += num

# FUNÇÃO DE REMOVER ITEM
func DelItem(id:int) -> void:
	# Encontra o item e diminui seu número
	var c:ItemInventario = %Inv.get_child(id)
	c.num_item -= 1
	# Se seu novo número não for 0, função acaba.
	if c.num_item > 0: return
	
	# Se o item acabou, o remove do inventário...
	%Inv.remove_child(%Inv.get_child(id))
	# ...e o botão selecionado é outro do seu lado.
	var new_id:int = 0
	for i:ItemInventario in %Inv.get_children():
		i.id_inventario = new_id
		new_id += 1
	if %Inv.get_child_count() > 0:
		if %Inv.get_child(id - 1):
			%Inv.get_child(id - 1).grab_focus()
		elif %Inv.get_child(id + 1):
			%Inv.get_child(id + 1).grab_focus()

func LimpaInv() -> void:
	var n:int = %Inv.get_child_count() - 1
	while n >= 0:
		%Inv.remove_child(%Inv.get_child(n))
		n -= 1

func PegaSprite(id:int = 0) -> Texture2D:
	if %Inv.get_child_count() > 0:
		return %Inv.get_child(id).sprite_display
	return null

func UsaItem(id:int) -> void:
	%Inv.get_child(id).script_logica.Logica()

func PegaNum(id:int = 0) -> String:
	if %Inv.get_child_count() > 0:
		return str(%Inv.get_child(id).num_item)
	return ""
