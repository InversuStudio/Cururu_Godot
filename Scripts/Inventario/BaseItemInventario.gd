class_name ItemInventario extends TextureButton

## Nome que será procurado na lista de itens
@export var item:Inventario.Itens
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
var num_item:int = 1:
	set(valor):
		num_item = valor
		UpdateNumItem()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if script_logica:
		connect("pressed", script_logica.Logica)
	
	if sprite_normal: texture_normal = sprite_normal
	if sprite_select: texture_focused = sprite_select
	focus_entered.connect(func():
		HUD.MostraItem(nome_display,
		desc_item, script_logica.valor_cura))

func UpdateNumItem() -> void:
	%NumItem.text = str(num_item)
