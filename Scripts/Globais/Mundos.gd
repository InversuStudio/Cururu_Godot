extends Node

# Lista de fases
var arquivo_fase: Array = [
	preload("res://Cenas/FaseTeste.tscn"),
	preload("res://Cenas/FaseTeste2.tscn"),
	preload("res://Cenas/MenuPrincipal.tscn"),
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
	preload("res://Cenas/Mata_Atlantica/AREA 2/MA_03.tscn"),
	preload("res://Cenas/Mata_Atlantica/AREA 3/MA_04.tscn"),
]

# Enumerador de fases, deve seguir a mesma ordem que a lista
enum NomeFase {
	FaseTeste,
	FaseTeste2,
	MenuPrincipal,
	Mata_Atlantica_TUTORIAL_TMA01,
	Mata_Atlantica_TUTORIAL_TMA02,
	Mata_Atlantica_TUTORIAL_TMA03,
	Mata_Atlantica_AREA01_A1MA01,
	Mata_Atlantica_AREA01_A1MA02,
	Mata_Atlantica_AREA01_A1MA03,
	Mata_Atlantica_AREA01_A1MA04,
	Mata_Atlantica_AREA01_A1MA05,
	Mata_Atlantica_AREA01_A1MA06,
	Mata_Atlantica_AREA01_A1MA07,
	Mata_Atlantica_AREA01_A1MA08,
	Mata_Atlantica_AREA01_A1MA09,
	Mata_Atlantica_MA_02,
	Mata_Atlantica_MA_03,
	Mata_Atlantica_MA_04,
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
