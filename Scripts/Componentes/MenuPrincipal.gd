extends Control

var data:String = ""

func _ready() -> void:
	GameData.game_start = false
	Inventario.inventario = []
	Mundos.areas_secretas = []
	await get_tree().physics_frame
	data = GameData.ChecaData()
	if data == "":
		%Continuar.hide() #disabled = true
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	%NovoJogo.grab_focus()

func _on_main_pressed() -> void:
	# Deleta Save
	if data != "":
		#var file_dir:String = OS.get_executable_path().get_base_dir()+"/savedata.cfg"
		var save_path:String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS
			) + "/SavedGames/Cururu/savedata.cfg"
		DirAccess.remove_absolute(save_path)
	# Reseta dados do jogo
	GameData.ResetData()
	Mundos.lista_inimigos = []
	Mundos.lista_baus = []
	#Mundos.areas_secretas = []
	$BtnSFX.play()
	Mundos.CarregaFase(Mundos.NomeFase.CutsceneIntro)
	#Mundos.CarregaFase(Mundos.NomeFase.TUTORIAL_1)

func _on_fase_teste_pressed() -> void:
	$BtnSFX.play()
	Mundos.lista_inimigos = []
	Mundos.lista_baus = []
	#Mundos.areas_secretas = []
	if await GameData.Load():
		print("Jogo carregado")
		
func _on_sair_pressed() -> void:
	$BtnSFX.play()
	Mundos.FechaJogo()
