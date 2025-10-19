extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): # Enter / Espaço / Botão A do joystick etc
		Mundos.CarregaFase(Mundos.NomeFase.MenuPrincipal)
	#if Input.is_action_just_pressed("melee")
