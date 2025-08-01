# SCRIPT GLOBAL PARA REGISTRAR DIVERSOS DADOS DO JOGADOR
extends Node

# Armazena se os dados já foram lidos alguma vez
@onready var leu_data: bool = false

# Armazena a fase a ser carregada
var fase: Mundos.NomeFase = Mundos.NomeFase.FaseTeste
# Armazena a posição inicial do player
var posicao: Vector2 = Vector2(0, 0)
# Define se player inicia olhando para a esquerda(true) ou direita(false)
var direcao: bool = false
# Sinal lançado quando o contador de moedas é alterado
signal update_moeda
# Armazena o total de moedas coletadas
var moedas: int = 0:
	set(valor):
		moedas = valor
		# Quando o valor é alterado, é emitido update_moedas
		update_moeda.emit()

# Instância de controle do arquivo de save
var config: ConfigFile = ConfigFile.new()

# FUNÇÃO PARA SALVAR JOGO
func Save() -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	if player:
		# Atualiza dados
		fase = Mundos.fase_atual
		posicao = player.global_position
		direcao = player.sprite.flip_h
		# Joga dados no arquivo
		config.set_value("save", "fase", fase)
		config.set_value("save", "posicao", posicao)
		config.set_value("save", "direcao", direcao)
		config.set_value("save", "moedas", moedas)
		# Salva arquivo
		config.save(OS.get_executable_path().get_base_dir()+"/savedata.cfg")
		print("Jogo salvo")
	else:
		print("Erro ao salvar")

# FUNÇÃO PARA CARREGAR SAVE
func Load() -> bool:
	# Checa se o arquivo de save existe
	var err = config.load(OS.get_executable_path().get_base_dir()+"/savedata.cfg")
	# Se existir, lê os dados
	if err == OK:
		fase = config.get_value("save", "fase")
		posicao = config.get_value("save", "posicao")
		direcao = config.get_value("save", "direcao")
		moedas = config.get_value("save", "moedas")
		# Carrega o jogo, com os dados certos
		Mundos.CarregaFase(fase, true, posicao, direcao)
		return true
		
	return false
