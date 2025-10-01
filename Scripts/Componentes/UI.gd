extends Control

# Recebe se o player morreu
var player_morreu: bool = false

var coracoes:Array = []

const sprite_cheio:Texture2D = preload("res://Sprites/UI/HUD/UIHUD-VIDACHEIA.png")
const sprite_vazio:Texture2D = preload("res://Sprites/UI/HUD/UIHUD-VIDAVAZIZ.png")

func _input(_event: InputEvent) -> void:
	var cena:Node = get_tree().current_scene
	if Input.is_action_just_pressed("pause"):
		if cena.process_mode == PROCESS_MODE_INHERIT:
			%Pause.show()
			cena.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			cena.process_mode = Node.PROCESS_MODE_INHERIT
			%Pause.hide()

func _ready() -> void:
	%Pause.hide()
	var player:CharacterBody2D = get_tree().get_first_node_in_group("Player")
	# Se achar Player na cena...
	if player:
		# Espera frame para carregar tudo
		await get_tree().process_frame
		# Adiciona corações na barra de vida
		for n in GameData.vida_max:
			var coracao: TextureRect = TextureRect.new()
			coracao.custom_minimum_size = Vector2(50.0, 50.0)
			coracao.texture = sprite_cheio
			%BarraHeart.add_child(coracao)
		coracoes = %BarraHeart.get_children()
		# Inicializa valores da barra de magia
		%BarraMagia.max_value = GameData.magia_max
		%BarraMagia.value = GameData.magia_atual
		# Inicializa valores da barra de vida
		if GameData.vida_atual > 0:
			UpdateVida(GameData.vida_atual, 0)
		# Conecta sinais de dano, cura e morte
		player.vida.connect("alterou_vida", UpdateVida)
		GameData.connect("update_magia", UpdateMagia)
		# Conecta UpdateMoeda ao sinal de mudança na quintidade de moedas
		GameData.connect("update_moeda", UpdateMoeda)
		# Se ainda não leu o arquivo de save...
		if GameData.leu_data == false:
			# ...e houver arquivo de save...
			if GameData.config.has_section_key("save", "moedas"):
			# ...atualiza contador de moedas com o número salvo
				GameData.moedas = GameData.config.get_value("save", "moedas")
				GameData.leu_data = true
		# Atualiza contador pela primeira vez
		UpdateMoeda()

# Função para atualizar contador de moedas
func UpdateMoeda() -> void:
	# Funciona apenas se o player não estiver morto
	if !player_morreu:
		%CounterMoeda.text = str(GameData.moedas)

# Função para alterar valor da barra de vida
func UpdateVida(vida_nova:int, _vida_antiga:int) -> void:
	Console._Print("[color=green]VIDA: %s[/color]" % [GameData.vida_atual])
	for c:TextureRect in coracoes:
		c.texture = sprite_cheio if c.get_index() + 1 <= vida_nova else sprite_vazio
	if vida_nova <= 0:
		PlayerMorreu()

# Função para sinalizar que player morreu
func PlayerMorreu() -> void:
	player_morreu = true
	
func UpdateMagia() -> void:
	if !player_morreu:
		Console._Print("[color=cyan]MAGIA: %s[/color]" % [GameData.magia_atual])
		#%BarraMagia.value = GameData.magia_atual
		var tween:Tween = get_tree().create_tween()
		tween.tween_property(%BarraMagia,"value",GameData.magia_atual,.3).set_trans(
			Tween.TRANS_CUBIC)

func AvisoSave() -> void:
	%Anim.play("JogoSalvo")

func _on_retornar_pressed() -> void:
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT
	%Pause.hide()

func _on_sair_pressed() -> void:
	Mundos.CarregaFase(Mundos.NomeFase.MenuPrincipal)
