extends InteractObject

@export var upgrade: GameData.upgrades

func Interact(_player:CharacterBody2D) -> void:
	print("UPGRADE: ", upgrade)
	GameData.upgrade_num = upgrade + 1
	get_parent().queue_free()
