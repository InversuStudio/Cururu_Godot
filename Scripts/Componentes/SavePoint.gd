extends InteractObject

func _ready() -> void:
	%Texto.hide()

func Interact(player:CharacterBody2D) -> void:
	player.vida.RecebeCura(GameData.vida_max)
	GameData.Save()

func Extra(dentro:bool = true) -> void:
	if dentro:
		%Texto.show()
	else:
		%Texto.hide()
