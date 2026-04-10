# SCRIPT GLOBAL PARA REGISTRAR DIVERSOS DADOS DO JOGADOR
extends Node

# Armazena se os dados já foram lidos alguma vez
@onready var leu_data:bool = false
@onready var game_start:bool = false

# Variáveis que armazenam se npc já falou
var saci_falou:bool = false
var naia_falou:bool = false

# Armazena se está usando teclado ou controller
# 0 = Mouse/Teclado | 1 = Xbox | 2 = PlayStation | 3 = Nintendo
signal tipo_input_mudou
var tipo_input:int = 0:
	set(valor):
		tipo_input = valor
		tipo_input_mudou.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		tipo_input = 0
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_pressed():
		if (event is InputEventMouseButton or event is InputEventKey
		or event is InputEventMouseButton):
			tipo_input = 0
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
		elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
			tipo_input = DetectControllerType()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func DetectControllerType() -> int:
	var nome: String = Input.get_joy_name(0).to_lower()
	if "xbox" in nome or "xinput" in nome or "microsoft" in nome:
		return 1
	elif "playstation" in nome or "dualshock" in nome or "dualsense" in nome or "sony" in nome:
		return 2
	elif "nintendo" in nome or "switch" in nome or "joy-con" in nome:
		return 3
	return 1  # fallback: Xbox como padrão

func GetUiButtonImage(action: StringName) -> StringName:
	var comandos:Array[InputEvent] = InputMap.action_get_events(action)

	if tipo_input == 0:
		var key: String = ""
		for ie: InputEvent in comandos:
			if ie is InputEventKey:
				key = OS.get_keycode_string(ie.physical_keycode)
				break
		return "res://Sprites/UI/Botoes/TesteTeclado" + key + ".png"

	else:
		var botao: int = 0
		var is_axis: bool = false
		for ie: InputEvent in comandos:
			if ie is InputEventJoypadButton:
				botao = ie.button_index
				break
			if ie is InputEventJoypadMotion:
				botao = ie.axis
				is_axis = true
				break

		if is_axis:
			return GetJoyAxis(botao)
		else:
			return GetJoyButton(botao)

func GetJoyAxis(botao:int) -> StringName:
	match botao:
		JOY_AXIS_TRIGGER_RIGHT:
			match tipo_input:
				1: return "res://Sprites/UI/Botoes/TesteInputXboxRT.png"
				2: return "res://Sprites/UI/Botoes/TesteInputPSRT.png"
				3: return "res://Sprites/UI/Botoes/TesteInputXboxRT.png"
		JOY_AXIS_TRIGGER_LEFT:
			match tipo_input:
				1: return "res://Sprites/UI/Botoes/TesteInputXboxLT.png"
				2: return "res://Sprites/UI/Botoes/TesteInputPSLT.png"
				3: return "res://Sprites/UI/Botoes/TesteInputXboxLT.png"
	return ""

func GetJoyButton(botao:int) -> StringName:
	match botao:
		JOY_BUTTON_A:
			match tipo_input:
				1: return "res://Sprites/UI/Botoes/TesteInputXboxA.png"
				2: return "res://Sprites/UI/Botoes/TesteInputPSX.png"
				3: return "res://Sprites/UI/Botoes/TesteInputXboxB.png"
		JOY_BUTTON_B:
			match tipo_input:
				1: return "res://Sprites/UI/Botoes/TesteInputXboxB.png"
				2: return "res://Sprites/UI/Botoes/TesteInputPSC.png"
				3: return "res://Sprites/UI/Botoes/TesteInputXboxA.png"
		JOY_BUTTON_X:
			match tipo_input:
				1: return "res://Sprites/UI/Botoes/TesteInputXboxX.png"
				2: return "res://Sprites/UI/Botoes/TesteInputPSQ.png"
				3: return "res://Sprites/UI/Botoes/TesteInputXboxY.png"
		JOY_BUTTON_Y:
			match tipo_input:
				1: return "res://Sprites/UI/Botoes/TesteInputXboxY.png"
				2: return "res://Sprites/UI/Botoes/TesteInputPST.png"
				3: return "res://Sprites/UI/Botoes/TesteInputXboxX.png"
		JOY_BUTTON_RIGHT_SHOULDER:
			match tipo_input:
				1: return "res://Sprites/UI/Botoes/TesteInputXboxRB.png"
				2: return "res://Sprites/UI/Botoes/TesteInputPSRB.png"
				3: return "res://Sprites/UI/Botoes/TesteInputXboxRB.png"
		JOY_BUTTON_LEFT_SHOULDER:
			match tipo_input:
				1: return "res://Sprites/UI/Botoes/TesteInputXboxLB.png"
				2: return "res://Sprites/UI/Botoes/TesteInputPSLB.png"
				3: return "res://Sprites/UI/Botoes/TesteInputXboxLB.png"
		JOY_BUTTON_START:
			pass
		JOY_BUTTON_BACK:
			pass
		JOY_BUTTON_DPAD_UP:
			return "res://Sprites/UI/Botoes/TesteInputXboxCima.png"
		JOY_BUTTON_DPAD_DOWN:
			return "res://Sprites/UI/Botoes/TesteInputXboxBaixo.png"
		JOY_BUTTON_DPAD_LEFT:
			return "res://Sprites/UI/Botoes/TesteInputXboxEsquerda.png"
		JOY_BUTTON_DPAD_RIGHT:
			return "res://Sprites/UI/Botoes/TesteInputXboxDireita.png"
	return ""

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
		magia_atual = clampi(roundi(magia_atual), 0, magia_max)
		update_magia.emit()

signal update_miasma
var miasma:int = 0:
	set(valor):
		miasma = valor
		miasma = clampi(miasma, 0, magia_max)
		update_miasma.emit()

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
var config:ConfigFile = ConfigFile.new()

# FUNÇÃO PARA SALVAR JOGO
func Save() -> void:
	# Apenas salva se estiver dentro de alguma fase
	if Mundos.player == null:
		Console._Print("Não é possível salvar aqui")
		return
	# Atualiza dados
	posicao = Mundos.player.global_position
	direcao = Mundos.player.sprite.flip_h
	# Joga dados no arquivo
	config.set_value("save", "fase", Mundos.fase_atual)
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
	if DirAccess.dir_exists_absolute(save_path) == false:
		var dir_err:Error = DirAccess.make_dir_absolute(save_path)
		if dir_err == OK: print("SavedGames criada")
		else:
			printerr("Erro ao criar SavedGames")
			return
	
	# Checa se pasta de save do Cururu existe
	if DirAccess.dir_exists_absolute(save_path + "/Cururu") == false:
		# Checa se pasta SavedGames existe
		var dir_err:Error = DirAccess.make_dir_absolute(save_path + "/Cururu")
		if dir_err == OK: print("Pasta Cururu criada")
		else:
			printerr("Erro ao criar pasta Cururu")
			return
	
	# Salva arquivo
	var err:Error = config.save(save_path + "/Cururu/savedata.cfg")
	
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
		posicao = config.get_value("save", "posicao")
		direcao = config.get_value("save", "direcao")
		
		var trocou:bool = false
		# Carrega o jogo, com os dados certos
		var fase:StringName = config.get_value("save", "fase")
		for f:PackedStringArray in Mundos.lista_fases:
			if f[1].get_slice(".", 0) == fase:
				var dest:PackedStringArray = f[1].split(".")
				LoadCena.Load(
					"res://Cenas/%s/%s" % [f[0], dest[0]+"."+dest[1]]
					, true, posicao)
				trocou = true
				break
		if !trocou:
			printerr("Cena não encontrada ao carregar save")
			return false
		
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
		miasma = 0
		return true
	printerr("SAVE NÃO ENCONTRADO")
	return false

# FUNÇÃO QUE CHECA SE SAVE EXISTE
func ChecaData() -> String:
	var file_dir:String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS
		)+"/SavedGames/Cururu/savedata.cfg"
	var err:Error = config.load(file_dir)
	if err == OK:
		return file_dir
	return ""

const player:PackedScene = preload("res://Objetos/Entidades/Player.tscn")

func ResetData() -> void:
	HUD.configurado = false
	Inventario.Reset()
	
	var p:Player = player.instantiate()
	vida_max = p.vida.vida_max
	vida_atual = vida_max
	magia_max = p.magia_max
	magia_atual = magia_max
	miasma = 0
	p.queue_free()
	
	moedas = 0
	direcao = false
	veio_de_baixo = false
	upgrade_num = 0
	
	peca_coracao = 0
	Mundos.pecas_coracao = []
