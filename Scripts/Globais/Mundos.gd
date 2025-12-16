extends Node

# Lista de fases
var arquivo_fase: Array[String] = [
	"res://Cenas/zTeste/FaseTeste1.tscn",
	"res://Cenas/zTeste/FaseTeste2.tscn",
	"res://Cenas/zTeste/FaseTeste3.tscn",
	"res://UI/MenuPrincipal.tscn",
	"res://Cenas/Mata_Atlantica/TUTORIAL/TMA01.tscn",
	"res://Cenas/Mata_Atlantica/TUTORIAL/TMA02.tscn",
	"res://Cenas/Mata_Atlantica/TUTORIAL/TMA03.tscn",
	"res://Cenas/Mata_Atlantica/AREA01/A1MA01.tscn",
	"res://Cenas/Mata_Atlantica/AREA01/A1MA02.tscn",
	"res://Cenas/Mata_Atlantica/AREA01/A1MA03.tscn",
	"res://Cenas/Mata_Atlantica/AREA01/A1MA04.tscn",
	"res://Cenas/Mata_Atlantica/AREA01/A1MA05.tscn",
	"res://Cenas/Mata_Atlantica/AREA01/A1MA06.tscn",
	"res://Cenas/Mata_Atlantica/AREA01/A1MA07.tscn",
	"res://Cenas/Mata_Atlantica/AREA01/A1MA08.tscn",
	"res://Cenas/Mata_Atlantica/AREA01/A1MA09.tscn",
	"res://Cenas/Mata_Atlantica/AREA02/A2MA01.tscn",
	"res://Cenas/Mata_Atlantica/AREA02/A2MA02.tscn",
	"res://Cenas/Mata_Atlantica/AREA02/A2MA03.tscn",
	"res://Cenas/Mata_Atlantica/AREA02/A2MA04.tscn",
	"res://Cenas/Mata_Atlantica/AREA02/A2MA05.tscn",
	"res://Cenas/Mata_Atlantica/AREA02/A2MA06.tscn",
	"res://Cenas/Mata_Atlantica/AREA02/A2MA07.tscn",
	"res://Cenas/Mata_Atlantica/AREA03/MA_04.tscn",
	"res://Cenas/Demo/FinalDemo.tscn",
]

# Enumerador de fases, deve seguir a mesma ordem que a lista
enum NomeFase {
	FaseTeste1,
	FaseTeste2,
	FaseTeste3,
	MenuPrincipal,
	TUTORIAL_1,
	TUTORIAL_2,
	TUTORIAL_3,
	Mata_Atlantica_1_1,
	Mata_Atlantica_1_2,
	Mata_Atlantica_1_3,
	Mata_Atlantica_1_4,
	Mata_Atlantica_1_5,
	Mata_Atlantica_1_6,
	Mata_Atlantica_1_7,
	Mata_Atlantica_1_8,
	Mata_Atlantica_1_9,
	Mata_Atlantica_2_1,
	Mata_Atlantica_2_2,
	Mata_Atlantica_2_3,
	Mata_Atlantica_2_4,
	Mata_Atlantica_2_5,
	Mata_Atlantica_2_6,
	Mata_Atlantica_2_7,
	Mata_Atlantica_MA_04,
	FinalDemo,
}

# Lista que registra que peças de coração foram coletadas
var pecas_coracao: Array[String] = []
# Lista que registra areas secretas desbloqueadas
var areas_secretas: Array[String] = []

# Registra fase atual
var fase_atual : NomeFase
@onready var player:Player = get_tree().get_first_node_in_group("Player")

signal fase_mudou

# Função para carregar nova fase
func CarregaFase(lugar:NomeFase, detalhado:bool = false,
	pos:Vector2=Vector2.ZERO) -> void:#, virado:bool=false) -> void:
	# Inicia Fade Out e espera a animação terminar
	Fade.FadeOut()
	await Fade.terminou
	# Espera o frame de física terminar e muda a cena
	await get_tree().physics_frame
	get_tree().change_scene_to_file(arquivo_fase[lugar])
	get_tree().paused = false
	fase_atual = lugar
	if GameData.ChecaData() == "" and GameData.player_morreu:
		GameData.moedas = 0
		GameData.player_morreu = false
	# Espera um frame de física, para o jogo carregar
	await get_tree().physics_frame
	# Inicia Fade In
	Fade.FadeIn()
	# Posiciona o player, se houver
	player = get_tree().get_first_node_in_group("Player")
	if player and detalhado == true:
		player.global_position = pos
		player.sprite.flip_h = GameData.direcao#virado
		
	# Registra novo HUD na cena
	HUD.IniciaHUD()
	fase_mudou.emit()

# Função para recarregar fase ativa
func Reload() -> void:
	get_tree().reload_current_scene()

var moeda: PackedScene = preload("res://Objetos/Props/Moeda.tscn")
func SpawnMoeda(parent:Node2D, pos:Vector2) -> void:
	var coin : Node2D = moeda.instantiate()
	parent.call_deferred("add_child", coin)
	coin.global_position = pos

func HitFreeze(hit_freeze:float) -> void:
	if hit_freeze > 0.0 and Engine.time_scale == 1.0:
		Engine.time_scale = 0.0
		await get_tree().create_timer(hit_freeze, true, false, true).timeout
		Engine.time_scale = 1.0

func FechaJogo() -> void:
	Fade.FadeOut()
	await Fade.terminou
	get_tree().quit()
