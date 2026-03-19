extends InteractObject

@onready var texto: RichTextLabel = $"../Texto"

func _ready() -> void:
	texto.hide()
	%Anim.animation_finished.connect(func(): %Anim.play("Idle"))

func Interact() -> void:
	Mundos.player.vida.RecebeCura(GameData.vida_max)
	%SFX.play()
	%Anim.play("Save")
	GameData.Save()
	Mundos.lista_inimigos = []
	
	if Mundos.player.state_machine.current_state.name == "Chao":
		Mundos.player.anim.play("Save")
		Mundos.player.pode_mover = false
		Mundos.player.pode_ataque = false
		Mundos.player.state_machine.find_child("Chao").pode_anim = false
		Mundos.player.input_move.x = 0.0
		Mundos.player.velocity.x = 0.0
		await Mundos.player.anim.animation_finished
		Mundos.player.pode_mover = true
		Mundos.player.pode_ataque = true
		Mundos.player.state_machine.find_child("Chao").pode_anim = true

func Extra(dentro:bool = true) -> void:
	if dentro:
		texto.show()
	else:
		texto.hide()
