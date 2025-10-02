extends InteractObject

@export var upgrade: GameData.upgrades
@onready var texto: RichTextLabel = $"../Texto"

func _ready() -> void:
	if GameData.upgrade_num >= upgrade + 1:
		get_parent().queue_free()
	texto.hide()

func Interact(_player:CharacterBody2D) -> void:
	print("UPGRADE: ", upgrade)
	GameData.upgrade_num = upgrade + 1
	GameData.Save()
	get_parent().queue_free()

func Extra(dentro:bool) -> void:
	if dentro:
		texto.show()
	else:
		texto.hide()
