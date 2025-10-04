extends Control

func _ready() -> void:
	if !GameData.ChecaData():
		$HBoxContainer/Continuar.disabled = true

func _on_main_pressed() -> void:
	$BtnSFX.play()
	Mundos.CarregaFase(Mundos.NomeFase.TUTORIAL_1)

func _on_fase_teste_pressed() -> void:
	$BtnSFX.play()
	if GameData.Load():
		print("Jogo carregado")
	#else:
		#print("Não há arquivo de save")
		#Mundos.CarregaFase(Mundos.NomeFase.FaseTeste1)
		
func _on_sair_pressed() -> void:
	$BtnSFX.play()
	Mundos.FechaJogo()
