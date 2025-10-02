extends InteractObject

@onready var texto: RichTextLabel = $"../Texto"

func _ready() -> void:
	texto.hide()

func Interact(player:CharacterBody2D) -> void:
	player.vida.RecebeCura(GameData.vida_max)
	GameData.Save()

func Extra(dentro:bool = true) -> void:
	if dentro:
		texto.show()
	else:
		texto.hide()
