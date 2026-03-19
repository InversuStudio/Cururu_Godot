extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): # Enter / Espaço / Botão A do joystick etc
		LoadCena.Load("res://UI/MenuPrincipal.tscn")
