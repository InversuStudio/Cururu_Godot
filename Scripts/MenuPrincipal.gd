extends Control

func _on_main_pressed() -> void:
	Mundos.CarregaFase(Mundos.NomeFase.Mata_Atlantica_MA_01)

func _on_fase_teste_pressed() -> void:
	if GameData.Load():
		print("Jogo carregado")
	else:
		print("Não há arquivo de save")
		Mundos.CarregaFase(Mundos.NomeFase.FaseTeste)
