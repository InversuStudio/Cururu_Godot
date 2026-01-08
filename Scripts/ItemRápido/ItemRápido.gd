extends Control

@export var cena_inventario:Control = null
var id_item:int = 0:
	set(valor):
		id_item = valor
		if id_item < 0:
			id_item = Inventario.inventario.size() - 1
			
		if id_item > Inventario.inventario.size() - 1:
			id_item = 0

func _ready() -> void:
	Inventario.connect("add_item", func(_i:String, _num:int):
		if %IconItem.texture == null:
			await get_tree().physics_frame
			%IconItem.texture = cena_inventario.PegaSprite(0)
		%NumRap.text = str(Inventario.inventario[id_item][1]))

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("bumper_direito"):
		if Inventario.inventario.size() > 0:
			id_item += 1
			%IconItem.texture = cena_inventario.PegaSprite(id_item)
			%NumRap.text = str(Inventario.inventario[id_item][1])
			
	if Input.is_action_just_pressed("bumper_esquerdo"):
		if Inventario.inventario.size() > 0:
			id_item -= 1
			%IconItem.texture = cena_inventario.PegaSprite(id_item)
			%NumRap.text = str(Inventario.inventario[id_item][1])
			
	if Input.is_action_just_pressed("usar_item"):
		if Inventario.inventario.size() > 0:
			cena_inventario.UsaItem(id_item)
			
			if id_item > Inventario.inventario.size() - 1:
				id_item -= 1
			
			if Inventario.inventario.size() > 0:
				%IconItem.texture = cena_inventario.PegaSprite(id_item)
				%NumRap.text = str(Inventario.inventario[id_item][1])
			else:
				%IconItem.texture = null
				%NumRap.text = ""

func IniciaBarra() -> void:
	if Inventario.inventario.size() > 0:
		%IconItem.texture = cena_inventario.PegaSprite(0)
		%NumRap.text = str(cena_inventario.PegaNum(0))
