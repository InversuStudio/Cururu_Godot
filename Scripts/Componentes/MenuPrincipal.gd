extends Control

var data:String = ""

func _ready() -> void:
	%NovoJogo.connect("pressed", NewGame)
	%Continuar.connect("pressed", Continuar)
	%Sair.connect("pressed", Sair)
	GameData.game_start = false
	Inventario.inventario = []
	Mundos.areas_secretas = []
	await get_tree().physics_frame
	data = GameData.ChecaData()
	if data == "":
		%Continuar.hide()
		%NovoJogo.grab_focus()
	else:
		%Continuar.grab_focus()

func NewGame() -> void:
	# Deleta Save
	if data != "":
		var save_path:String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS
			) + "/SavedGames/Cururu/savedata.cfg"
		DirAccess.remove_absolute(save_path)
	# Reseta dados do jogo
	GameData.ResetData()
	$BtnSFX.play()
	LoadCena.Load("res://Cenas/aTutorial/CutsceneIntro.tscn")

func Continuar() -> void:
	$BtnSFX.play()
	Mundos.lista_inimigos = []
	Mundos.lista_baus = []
	if GameData.Load():
		print("Jogo carregado")
		
func Sair() -> void:
	$BtnSFX.play()
	Mundos.FechaJogo()
