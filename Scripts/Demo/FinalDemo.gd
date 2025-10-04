extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		Mundos.CarregaFase(Mundos.NomeFase.MenuPrincipal)
	#if Input.is_action_just_pressed("melee")
