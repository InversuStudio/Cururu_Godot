extends InteractObject

func Interact(player:CharacterBody2D) -> void:
	player.vida.RecebeCura(GameData.vida_max)
	GameData.Save()
	var hud:Control = get_tree().get_first_node_in_group("HUD")
	if hud: hud.AvisoSave()
