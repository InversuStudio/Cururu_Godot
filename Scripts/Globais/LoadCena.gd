extends Control

var next_path:StringName = ""
var next_pos:Vector2 = Vector2.ZERO
var usa_pos:bool = false

var is_load:bool = false
signal fase_mudou

func Load(lugar:StringName, detalhado:bool=false, pos:Vector2=Vector2.ZERO) -> void:
	# Despausa cena, por precaução
	get_tree().paused = false
	# Armazena dados necessários
	next_path = lugar
	usa_pos = detalhado
	next_pos = pos
	# Aplica Fade Out
	Fade.FadeOut()
	await Fade.terminou
	# Espera frame de física e troca para tela de loading
	await get_tree().physics_frame
	get_tree().change_scene_to_file("res://UI/TelaCarregando.tscn")
	# Carrega nova fase
	ResourceLoader.load_threaded_request(next_path)
	is_load = true

func _process(_delta: float) -> void:
	# Se não estiver carregando nada, retorna
	if !is_load: return
	
	# Checa progresso do loading
	var status:ResourceLoader.ThreadLoadStatus = (
		ResourceLoader.load_threaded_get_status(next_path))
		
	# Se carregou tudo
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		is_load = false
		FazCoisa()

func FazCoisa() -> void:
	# Muda a cena para o arquivo carregado
	var cena:PackedScene = ResourceLoader.load_threaded_get(next_path)
	get_tree().change_scene_to_packed(cena)
	# Espera cena estar pronta
	await get_tree().scene_changed
	# Registra novo HUD na cena
	HUD.IniciaHUD()
	# Armazena o nome da fase atual
	var nome:PackedStringArray = next_path.split("/", false)
	var n:String = nome[nome.size() - 1]
	# Adiciona fase atual se não estiver na lista
	Mundos.fase_atual = n.get_slice(".", 0)
	if !Mundos.fases_visitadas.has(Mundos.fase_atual):
		Mundos.fases_visitadas.append(Mundos.fase_atual)
	# Reseta tudo se player morreu e não tem save
	if GameData.ChecaData() == "" and GameData.player_morreu:
		GameData.moedas = 0
		GameData.player_morreu = false
	# Atualiza a barra do console
	Console.MudaAbaSelect()
	# Inicia Fade In
	Fade.FadeIn()
	fase_mudou.emit()
