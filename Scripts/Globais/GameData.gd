# SCRIPT GLOBAL PARA REGISTRAR DIVERSOS DADOS DO JOGADOR
extends Node

# Armazena se os dados já foram lidos alguma vez
@onready var leu_data: bool = false
@onready var game_start:bool = false

# Armazena a fase a ser carregada
var fase: Mundos.NomeFase = Mundos.NomeFase.FaseTeste1
# Armazena a posição inicial do player
var posicao: Vector2 = Vector2(0, 0)
# Define se player inicia olhando para a esquerda(true) ou direita(false)
var direcao: bool = false
# Armazena se player foi para outra área vindo de baixo
var veio_de_baixo:bool = false
# Armazena o estado do menu de pause
var menu_aberto: bool = false
# Armazena o total de moedas coletadas
signal update_moeda
var moedas: int = 0:
	set(valor):
		moedas = valor
		# Quando o valor é alterado, é emitido update_moedas
		update_moeda.emit()
		
# Armazena informações de vida do player
signal update_vida_max
var vida_max: int = 0:
	set(valor):
		var old:int = vida_max
		vida_max = valor
		update_vida_max.emit(old)

signal update_vida_atual
var vida_atual: int = 0:
	set(valor):
		vida_atual = valor
		update_vida_atual.emit()

# Armazena informações da magia do player
signal update_magia
var magia_max: int = 0
var magia_atual: float = 0.5:
	set(valor):
		magia_atual = valor
		magia_atual = clamp(magia_atual, 0, magia_max)
		update_magia.emit()

var upgrade_num: int = 0
enum Upgrades {
	MissilAgua,
}

var peca_coracao:int = 0:
	set(valor):
		peca_coracao = valor
		if valor >= 3:
			peca_coracao = 0
			vida_max += 1

var ataque_anim_speed:float = 1.0

var player_morreu:bool = false

# Instância de controle do arquivo de save
var config: ConfigFile = ConfigFile.new()

# FUNÇÃO PARA SALVAR JOGO
func Save() -> void:
	if Mundos.player:
		# Atualiza dados
		fase = Mundos.fase_atual
		posicao = Mundos.player.global_position
		direcao = Mundos.player.sprite.flip_h
		# Joga dados no arquivo
		config.set_value("save", "fase", fase)
		config.set_value("save", "posicao", posicao)
		config.set_value("save", "direcao", direcao)
		config.set_value("save", "vida_max", vida_max)
		config.set_value("save", "moedas", moedas)
		config.set_value("save", "upgrades", upgrade_num)
		config.set_value("save", "inventario", Inventario.inventario)
		config.set_value("save", "amuletos", Inventario.amuletos)
		config.set_value("save", "peca_coracao", peca_coracao)
		config.set_value("save", "lista_coracao", Mundos.pecas_coracao)
		config.set_value("save", "areas_secretas", Mundos.areas_secretas)
		config.set_value("save", "tem_mapa", Inventario.tem_mapa)
		
		var save_path:String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/SavedGames"
		# Checa se pasta SavedGames existe
		if DirAccess.dir_exists_absolute(save_path):
			print("SavedGames existe")
		# Senão, a cria
		else:
			var dir_err:Error = DirAccess.make_dir_absolute(save_path)
			if dir_err == OK: print("SavedGames criada")
			else:
				printerr("Erro ao criar SavedGames")
				return
		
		# Checa se pasta de save do Cururu existe
		if DirAccess.dir_exists_absolute(save_path + "/Cururu"):
			print("Pasta Cururu existe")
		# Senão, a cria
		else:
			# Checa se pasta SavedGames existe
			var dir_err:Error = DirAccess.make_dir_absolute(save_path + "/Cururu")
			if dir_err == OK: print("Pasta Cururu criada")
			else:
				printerr("Erro ao criar pasta Cururu")
				return
		
		# Salva arquivo
		var err:Error = config.save(save_path + "/Cururu/savedata.cfg")
			#OS.get_executable_path().get_base_dir()+"/savedata.cfg")
		# Lança aviso de save
		if err == OK:
			HUD.AvisoSave()
			print("Jogo salvo")
		else:
			printerr("Erro ao salvar")

# FUNÇÃO PARA CARREGAR SAVE
func Load() -> bool:
	# Checa se o arquivo de save existe
	if ChecaData() != "":
		# Se existir, lê os dados
		fase = config.get_value("save", "fase")
		posicao = config.get_value("save", "posicao")
		direcao = config.get_value("save", "direcao")
		
		# Carrega o jogo, com os dados certos
		Mundos.CarregaFase(fase, true, posicao)#, direcao)
		await Fade.terminou
		
		vida_max = config.get_value("save", "vida_max")
		moedas = config.get_value("save", "moedas", 0)
		upgrade_num = config.get_value("save", "upgrades")
		peca_coracao = config.get_value("save", "peca_coracao")
		Mundos.pecas_coracao = config.get_value("save", "lista_coracao")
		Mundos.areas_secretas = config.get_value("save", "areas_secretas")
		
		Inventario.inventario = []
		HUD.LimpaInv()
		
		var inv:Array[Array] = config.get_value("save", "inventario")
		for i:Array in inv:
			Inventario.AddItem(i[0], i[1])
		
		var am:Array[Array] = config.get_value("save", "amuletos")
		for a:Array in am:
			print(a)
			Inventario.AddAmuleto(a[0], a[1])
		
		Inventario.tem_mapa = config.get_value("save", "tem_mapa")
		
		if vida_max > 0:
			vida_atual = vida_max
		if magia_max > 0:
			magia_atual = magia_max
		return true
	printerr("SAVE NÃO ENCONTRADO")
	return false

# FUNÇÃO QUE CHECA SE SAVE EXISTE
func ChecaData() -> String:
	var file_dir:String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS
		)+"/SavedGames/Cururu/savedata.cfg"
	#OS.get_executable_path().get_base_dir()+"/savedata.cfg"
	var err:Error = config.load(file_dir)
	if err == OK:
		return file_dir
	return ""
	
const player:PackedScene = preload("res://Objetos/Entidades/Player.tscn")

func ResetData() -> void:
	HUD.configurado = false
	Inventario.Reset()
	
	var p:CharacterBody2D = player.instantiate()
	vida_max = p.vida.vida_max
	vida_atual = vida_max
	magia_max = p.magia_max
	magia_atual = magia_max
	p.queue_free()
	
	moedas = 0
	direcao = false
	veio_de_baixo = false
	upgrade_num = 0
	
	peca_coracao = 0
	Mundos.pecas_coracao = []
	#for peca:int in Mundos.pecas_coracao.size() - 1:
		#Mundos.pecas_coracao[peca] = false
		#peca_coracao = false
