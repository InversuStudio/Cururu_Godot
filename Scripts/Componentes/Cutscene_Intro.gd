extends Control

@onready var pagina = 0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Continuar.grab_focus()

func _on_continuar_pressed() -> void:
	if pagina == 0:
		%HQ2.visible = true
		pagina += 1
	else:
		Mundos.CarregaFase(Mundos.NomeFase.TUTORIAL_1)
