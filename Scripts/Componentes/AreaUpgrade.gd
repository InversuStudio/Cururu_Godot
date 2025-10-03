extends InteractObject

@export var upgrade: GameData.upgrades
@onready var texto: RichTextLabel = $"../Texto"

func _ready() -> void:
	if GameData.upgrade_num >= upgrade + 1:
		%Poder.hide()
	texto.hide()

func Interact(_player:CharacterBody2D) -> void:
	if GameData.upgrade_num < upgrade + 1:
		print("UPGRADE: ", upgrade)
		GameData.upgrade_num = upgrade + 1
		GameData.Save()
		%Poder.hide()

func Extra(dentro:bool) -> void:
	if GameData.upgrade_num < upgrade + 1:
		if dentro:
			texto.show()
		else:
			texto.hide()
