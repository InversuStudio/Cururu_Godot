class_name ItemInventario extends TextureButton

## Sprite do item normal
@export var sprite_normal: Texture2D = null
## Sprite do item selecionado
@export var sprite_select: Texture2D = null
## Sprite do item desabilitado
@export var sprite_disable: Texture2D = null
## Script a ser rodado ao pressionar botão
@export var script_logica: ScriptItemInventario = null

var id_inventario:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if script_logica:
		connect("pressed", func(): script_logica.Logica())
	if sprite_normal: texture_normal = sprite_normal
	if sprite_select: texture_focused = sprite_select
	if sprite_disable: texture_disabled = sprite_disable
