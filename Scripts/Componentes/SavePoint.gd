extends InteractObject

@onready var texto: RichTextLabel = $"../Texto"

func _ready() -> void:
	texto.hide()

func Interact(player:CharacterBody2D) -> void:
	player.vida.RecebeCura(GameData.vida_max)
	GameData.Save()
	%SFX.play()
	var hud:Control = get_tree().get_first_node_in_group("HUD")
	if hud:
		for item:ItemInventario in hud.inv.get_children():
			if item.script_logica.has_method("HabilitaBotao"):
				item.script_logica.HabilitaBotao()

func Extra(dentro:bool = true) -> void:
	if dentro:
		texto.show()
	else:
		texto.hide()
