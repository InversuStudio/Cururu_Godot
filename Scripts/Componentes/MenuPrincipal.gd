extends Control

func _ready() -> void:
	if !GameData.ChecaData():
		$HBoxContainer/Continuar.disabled = true
	#$HBoxContainer/NovoJogo.focus_mode

func _on_main_pressed() -> void:
	$BtnSFX.play()
	Mundos.CarregaFase(Mundos.NomeFase.TUTORIAL_1)

func _on_fase_teste_pressed() -> void:
	$BtnSFX.play()
	if GameData.Load():
		print("Jogo carregado")
		
func _on_sair_pressed() -> void:
	$BtnSFX.play()
	Mundos.FechaJogo()
