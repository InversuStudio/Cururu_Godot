extends Node

# Registra o nome de todas as fases do jogo
var lista_fases:Array[PackedStringArray] = [] # [PASTA, ARQUIVO]
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
	
	var pastas:PackedStringArray = DirAccess.get_directories_at("res://Cenas/")
	for p:String in pastas:
		var files:PackedStringArray = DirAccess.get_files_at("res://Cenas/%s/" % p)
		for f:String in files:
			lista_fases.append([p, f])

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
