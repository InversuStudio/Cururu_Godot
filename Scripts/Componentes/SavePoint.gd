extends InteractObject

func Interact(player:CharacterBody2D) -> void:
	player.vida.RecebeCura(GameData.vida_max)
	GameData.Save()
