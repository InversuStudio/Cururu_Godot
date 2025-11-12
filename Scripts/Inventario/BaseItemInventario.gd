class_name ItemInventario extends TextureButton

## Sprite do item normal
@export var sprite_normal: Texture2D = null
## Sprite do item selecionado
@export var sprite_select: Texture2D = null
## Script a ser rodado ao pressionar botão
@export var script_logica: ScriptItemInventario = null
## Nome que será procurado na lista de itens
@export var nome_item:String = ""

var id_inventario:int = 0
var num_item:int = 1:
	set(valor):
		num_item = valor
		UpdateNumItem()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if script_logica:
		#connect("pressed", func(): script_logica.Logica(nome_item
	nome_item = nome_item.capitalize()
	if sprite_normal: texture_normal = sprite_normal
	if sprite_select: texture_focused = sprite_select

func UpdateNumItem() -> void:
	%NumItem.text = str(num_item)
