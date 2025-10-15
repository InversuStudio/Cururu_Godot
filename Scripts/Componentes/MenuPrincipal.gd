extends Control

var data:String = ""

func _ready() -> void:
	data = GameData.ChecaData()
	if data == "":
		$HBoxContainer/Continuar.disabled = true
	#$HBoxContainer/NovoJogo.focus_mode
	$HBoxContainer/NovoJogo.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_main_pressed() -> void:
	# Deleta Save
	if data != "":
		var file_dir:String = OS.get_executable_path().get_base_dir()+"/savedata.cfg"
		DirAccess.remove_absolute(file_dir)
	# Reseta dados do jogo
	GameData.ResetData()
	$BtnSFX.play()
	Mundos.CarregaFase(Mundos.NomeFase.TUTORIAL_1)

func _on_fase_teste_pressed() -> void:
	$BtnSFX.play()
	if GameData.Load():
		print("Jogo carregado")
		
func _on_sair_pressed() -> void:
	$BtnSFX.play()
	Mundos.FechaJogo()
