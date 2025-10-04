extends Node

# Lista de fases
var arquivo_fase: Array = [
	preload("res://Cenas/zTeste/FaseTeste1.tscn"),
	preload("res://Cenas/zTeste/FaseTeste2.tscn"),
	preload("res://Cenas/zTeste/FaseTeste3.tscn"),
	preload("res://UI/MenuPrincipal.tscn"),
	preload("res://Cenas/Mata_Atlantica/TUTORIAL/TMA01.tscn"),
	preload("res://Cenas/Mata_Atlantica/TUTORIAL/TMA02.tscn"),
	preload("res://Cenas/Mata_Atlantica/TUTORIAL/TMA03.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA01/A1MA01.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA01/A1MA02.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA01/A1MA03.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA01/A1MA04.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA01/A1MA05.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA01/A1MA06.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA01/A1MA07.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA01/A1MA08.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA01/A1MA09.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA02/A2MA01.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA02/A2MA02.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA02/A2MA03.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA02/A2MA04.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA02/A2MA05.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA02/A2MA06.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA02/A2MA07.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA03/MA_04.tscn"),
	preload("res://Cenas/Demo/FinalDemo.tscn"),
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

# Registra fase atual
var fase_atual : NomeFase

# Função para carregar nova fase
func CarregaFase(lugar:NomeFase, detalhado:bool = false,
	pos:Vector2=Vector2.ZERO, virado:bool=false) -> void:
	# Encontra componente de FADE na cena ativa
	var fade: Fade = get_tree().get_first_node_in_group("Fade")
	if fade: # Se houver, inicia animação de FADE OUT
		fade.FadeOut()
		await fade.terminou
	# Espera passar frame de física, para não dar erro durante gameplay
	await get_tree().physics_frame
	# Muda a cena
	get_tree().change_scene_to_packed(arquivo_fase[lugar])
	fase_atual = lugar
	# Espera um frame de física, para o jogo carregar
	await get_tree().physics_frame
	# Encontra e posiciona o player, se houver
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	if player and detalhado == true:
		player.global_position = pos
		player.sprite.flip_h = virado

# Função para recarregar fase ativa
func Reload() -> void:
	get_tree().reload_current_scene()

var moeda: PackedScene = preload("res://Objetos/Props/Moeda.tscn")
func SpawnMoeda(pos:Vector2) -> void:
	var coin : Node2D = moeda.instantiate()
	get_tree().current_scene.call_deferred("add_child", coin)
	coin.global_position = pos

func FechaJogo() -> void:
	var fade: Fade = get_tree().get_first_node_in_group("Fade")
	if fade: # Se houver, inicia animação de FADE OUT
		fade.FadeOut()
		await fade.terminou
	get_tree().quit()
