class_name Amuleto extends TextureButton

## Nome que será procurado na lista de itens
@export var item:Inventario.Amuletos
## Nome que será mostrado no inventário
@export var nome_display:String
## Descrição que irá aparecer no inventário
@export_multiline var desc_item:String = ""
## Sprite do item normal
@export var sprite_normal: Texture2D = null
## Sprite do item selecionado
@export var sprite_select: Texture2D = null
## Script a ser rodado ao pressionar botão
@export var script_logica: ScriptItemInventario = null

var id_inventario:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if script_logica:
		connect("pressed", script_logica.Logica)
	
	if sprite_normal: texture_normal = sprite_normal
	if sprite_select: texture_focused = sprite_select
	
	focus_entered.connect(func():
		Mundos.hud.MostraAmuleto(
			nome_display, desc_item))
	
	Inventario.set_amuleto.connect(func():
		%Ativo.button_pressed = Inventario.amuletos[id_inventario][1])
	
	%Ativo.button_pressed = Inventario.amuletos[id_inventario][1]
