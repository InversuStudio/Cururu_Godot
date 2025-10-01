extends InteractObject

@export var upgrade: GameData.upgrades

func _ready() -> void:
	if GameData.upgrade_num >= upgrade + 1:
		get_parent().queue_free()
	%Texto.hide()

func Interact(_player:CharacterBody2D) -> void:
	print("UPGRADE: ", upgrade)
	GameData.upgrade_num = upgrade + 1
	GameData.Save()
	get_parent().queue_free()

func Extra(dentro:bool = true) -> void:
	if dentro:
		%Texto.show()
	else:
		%Texto.hide()
