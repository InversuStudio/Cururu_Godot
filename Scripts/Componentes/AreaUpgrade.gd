extends InteractObject

@export var upgrade: GameData.upgrades

func _ready() -> void:
	if GameData.upgrade_num >= upgrade:
		get_parent().queue_free()

func Interact(_player:CharacterBody2D) -> void:
	print("UPGRADE: ", upgrade)
	GameData.upgrade_num = upgrade + 1
	get_parent().queue_free()
