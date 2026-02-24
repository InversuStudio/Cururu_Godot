extends InteractObject

@onready var texto: RichTextLabel = $"../Texto"

func _ready() -> void:
	texto.hide()
	%Anim.animation_finished.connect(func(): %Anim.play("Idle"))

func Interact(player:CharacterBody2D) -> void:
	player.vida.RecebeCura(GameData.vida_max)
	%SFX.play()
	%Anim.play("Save")
	GameData.Save()
	Mundos.lista_inimigos = []

func Extra(dentro:bool = true) -> void:
	if dentro:
		texto.show()
	else:
		texto.hide()
