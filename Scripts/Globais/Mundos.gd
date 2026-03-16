extends Node

# Registra o nome de todas as fases do jogo
var lista_fases:Array[PackedStringArray] = [] # [PASTA, ARQUIVO]
# Registra fase atual
var fase_atual:StringName = ""
# Armazena a próxima fase a ser carregada
var prox_fase_path:StringName = ""
# Segura a instância atual do Player
@onready var player:Player = get_tree().get_first_node_in_group("Player")
# Recebe a posição que o player deve estar na próxima fase
var pos_player:Vector2 = Vector2.ZERO
# Recebe se pos_player deve ser usada
var usa_pos_player:bool = false
# Segura a instância atual da MainCamera
@onready var main_camera:MainCamera = get_tree().get_first_node_in_group("MainCamera")

signal fase_mudou

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

# Função para carregar nova fase
func CarregaFase(lugar:StringName, detalhado:bool = false,
	pos:Vector2=Vector2.ZERO) -> void:
	# Registra o caminho da próxima cena
	prox_fase_path = lugar
	# Registra posição do player
	usa_pos_player = detalhado
	pos_player = pos
	# Inicia Fade Out e espera a animação terminar
	Fade.FadeOut()
	await Fade.terminou
	# Espera o frame de física terminar e vai para a tela de carregamento
	await get_tree().physics_frame
	get_tree().change_scene_to_file("res://UI/TelaCarregando.tscn")
	
	var nome:PackedStringArray = lugar.split("/", false)
	var n:String = nome[nome.size() - 1]
	fase_atual = n.get_slice(".", 0)
	
	if GameData.ChecaData() == "" and GameData.player_morreu:
		GameData.moedas = 0
		GameData.player_morreu = false
	
	# Atualiza a barra do console
	Console.MudaAbaSelect()
	
	# LÓGICA CONTINUA NO SCRIPT DA TELA DE CARREGAMENTO

# Função para recarregar fase ativa
func Reload() -> void:
	get_tree().reload_current_scene()

var moeda: PackedScene = preload("res://Objetos/Props/Moeda.tscn")
func SpawnMoeda(parent:Node, pos:Vector2) -> void:
	var coin : Node2D = moeda.instantiate()
	parent.call_deferred("add_child", coin)
	#coin.global_position = pos
	coin.set_deferred("global_position", pos)

func HitFreeze(hit_freeze:float) -> void:
	if hit_freeze > 0.0 and Engine.time_scale == 1.0:
		Engine.time_scale = 0.0
		await get_tree().create_timer(hit_freeze, true, false, true).timeout
		Engine.time_scale = 1.0

func FechaJogo() -> void:
	Fade.FadeOut()
	await Fade.terminou
	get_tree().quit()
