extends InteractObject

## Qual upgrade é
@export var upgrade: GameData.Upgrades
## Nome que irá aparecer na tela de item coletado
@export var nome_tela:String = ""
## Descrição que irá aparecer na tela de item coletado
@export_multiline var descricao_tela:String = ""
## Imagem que irá aparecer na tela de item coletado
@export var imagem_tela:Texture2D = null

@onready var parent:Node2D = get_parent()
@onready var texto: RichTextLabel = $"../Texto"

func _ready() -> void:
	if GameData.upgrade_num >= upgrade + 1:
		%Poder.hide()
	texto.hide()

func Interact(_player:CharacterBody2D) -> void:
	if GameData.upgrade_num < upgrade + 1:
		texto.hide()
		GameData.upgrade_num = upgrade + 1
		%Poder.hide()
		Mundos.hud.AvisoItem(nome_tela, descricao_tela, imagem_tela)
		await Mundos.hud.tela_item
		GameData.Save()

func Extra(dentro:bool) -> void:
	if GameData.upgrade_num < upgrade + 1:
		if dentro:
			texto.show()
		else:
			texto.hide()
