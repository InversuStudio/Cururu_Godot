extends Node

# Registra o nome de todas as fases do jogo
var lista_fases:Array[PackedStringArray] = [
	["aTutorial", "CutsceneIntro.tscn"],
	["aTutorial", "CutsceneIntro2.tscn"],
	["aTutorial", "Tutorial_1.tscn"],
	["aTutorial", "Tutorial_2.tscn"],
	["aTutorial", "Tutorial_3.tscn"],
	["Mata_Atlantica", "MA_01.tscn"],
	["Mata_Atlantica", "MA_02.tscn"],
	["Mata_Atlantica", "MA_03.tscn"],
	["Mata_Atlantica", "MA_04.tscn"],
	["Mata_Atlantica", "MA_05.tscn"],
	["Mata_Atlantica", "MA_06.tscn"],
	["Mata_Atlantica", "MA_07.tscn"],
	["Mata_Atlantica", "MA_08.tscn"],
	["Mata_Atlantica", "MA_09.tscn"],
	["Mata_Atlantica", "MA_10.tscn"],
	["Mata_Atlantica", "MA_11.tscn"],
	["Mata_Atlantica", "MA_12.tscn"],
	["Mata_Atlantica", "MA_13.tscn"],
	["Mata_Atlantica", "MA_14.tscn"],
	["Mata_Atlantica", "MA_15.tscn"],
	["Mata_Atlantica", "MA_16.tscn"],
	["zDemo", "FinalDemo.tscn"],
	["zTeste", "ExemploEstruturaFase.tscn"],
	["zTeste", "FaseTeste1.tscn"],
	["zTeste", "FaseTeste2.tscn"],
	["zTeste", "FaseTeste3.tscn"],]
# Registra as fases que o player já visitou
var fases_visitadas:PackedStringArray = []
# Registra fase atual
var fase_atual:StringName = ""
# Segura a instância atual do Player
var player:Player = null
# Segura a instância atual da MainCamera
var main_camera:MainCamera = null

func _ready() -> void:
	var nome_cena:String = get_tree().current_scene.scene_file_path
	var slice:PackedStringArray = nome_cena.split("/")
	nome_cena = slice[slice.size() - 1]
	nome_cena = nome_cena.get_slice(".", 0)
	fase_atual = nome_cena
	Console.MudaAbaSelect()
	
	#var pastas:PackedStringArray = DirAccess.get_directories_at("res://Cenas/")
	#for p:String in pastas:
		#var files:PackedStringArray = DirAccess.get_files_at("res://Cenas/%s/" % p)
		#for f:String in files:
			#lista_fases.append([p, f])

# Lista que registra que peças de coração foram coletadas
var pecas_coracao: Array[String] = []
# Lista que registra areas secretas desbloqueadas
var areas_secretas: Array[String] = []
# Lista que registra todos os inimigos derrotados
var lista_inimigos:Array[String] = []
# Lista que registra todos os baús abertos
var lista_baus:Array[String] = []

var moeda: PackedScene = preload("res://Objetos/Props/Moeda.tscn")
func SpawnMoeda(parent:Node, pos:Vector2) -> void:
	var coin: Node2D = moeda.instantiate()
	coin.set_deferred("global_position", pos)
	#coin.global_position = pos
	#parent.add_child(coin)
	parent.call_deferred("add_child", coin)
	#coin.global_position = pos

func HitFreeze(hit_freeze:float) -> void:
	if hit_freeze > 0.0 and Engine.time_scale == 1.0:
		Engine.time_scale = 0.0
		await get_tree().create_timer(hit_freeze, true, false, true).timeout
		Engine.time_scale = 1.0

func FechaJogo() -> void:
	Fade.FadeOut()
	await Fade.terminou
	get_tree().quit()
