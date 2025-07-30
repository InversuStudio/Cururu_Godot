# SCRIPT GLOBAL PARA REGISTRAR DIVERSOS DADOS DO JOGADOR
extends Node

var fase: String = ""
var posicao: Vector2 = Vector2(0, 0)
var direcao: bool = false
signal update_moeda
var moedas: int = 0:
	set(valor):
		print("AI MINHAS MOEDINHAS")
		moedas = valor
		update_moeda.emit()

var config: ConfigFile = ConfigFile.new()

func _ready() -> void:
	if Load():
		print("JOGO CARREGADO COM SUCESSO")
	else:
		print("ERRO AO CARREGAR SAVE")

# FUNÇÃO PARA SALVAR JOGO
func Save() -> void:
	config.set_value("save", "fase", fase)
	config.set_value("save", "posicao", posicao)
	config.set_value("save", "direcao", direcao)
	config.set_value("save", "moedas", moedas)
	config.save(OS.get_executable_path().get_base_dir()+"/savedata.cfg")
	print("Jogo salvo")

# FUNÇÃO PARA CARREGAR SAVE
func Load() -> bool:
	var err = config.load(OS.get_executable_path().get_base_dir()+"/savedata.cfg")
	if err == OK:
		fase = config.get_value("save", "fase")
		posicao = config.get_value("save", "posicao")
		direcao = config.get_value("save", "direcao")
		moedas = config.get_value("save", "moedas")
		return true
	return false

func Reload() -> void:
	get_tree().reload_current_scene()
