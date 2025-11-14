class_name HUD extends Control

# Recebe se o player morreu
var player_morreu: bool = false

var coracoes:Array = []

const sprite_cheio:Texture2D = preload("res://Sprites/UI/HUD/UIHUD-VIDACHEIA.png")
const sprite_vazio:Texture2D = preload("res://Sprites/UI/HUD/UIHUD-VIDAVAZIZ.png")

var tela_item_on:bool = false

signal tela_item

@export var inventario_itens:Control = null
@export var inventario_amuletos:Control = null

# INPUT PAUSE
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("start"):
		if !get_tree().paused:
			%Pause.show()
			get_tree().paused = true
		else:
			%Pause.hide()
			get_tree().paused = false
	
	if Input.is_action_just_pressed("ui_accept") and tela_item_on:
		%Anim.play("PegaItemOff")
		await %Anim.animation_finished
		tela_item_on = false
		get_tree().paused = false
		tela_item.emit()
	
	if Input.is_action_just_pressed("ui_cancel") and %Pause.visible:
		Mundos.CarregaFase(Mundos.NomeFase.MenuPrincipal)
	
	if Input.is_action_just_pressed("bumper_direito"):
		if Mundos.hud_ativo + 1 <= %ContainerAbas.get_child_count() - 1:
			Mundos.hud_ativo += 1
			MudaAba()
	
	if Input.is_action_just_pressed("bumper_esquerdo"):
		if Mundos.hud_ativo - 1 >= 0:
			Mundos.hud_ativo -= 1
			MudaAba()

func MudaAba() -> void:
	for c:Control in %ContainerMenus.get_children():
		if c.get_index() == Mundos.hud_ativo:
			c.show()
			%ContainerAbas.get_child(Mundos.hud_ativo).button_pressed = true
		else: c.hide()

func _ready() -> void:
	# Espera jogo carregar
	await get_tree().process_frame
		
	# ESCONDE MENU PAUSE AO INICIAR JOGO
	%Pause.hide()
	%AvisoItem.modulate.a = 0.0
	%AvisoSave.self_modulate.a = 0.0
	%AvisoItem.show()
	
	# Mostra aba certa do HUD
	MudaAba()
	
	# Se achar Player na cena...
	if Mundos.player:
		# Adiciona corações na barra de vida
		for n:int in GameData.vida_max:
			AdicionaCoracao()
		
		# Inicializa valores da barra de magia
		%BarraMagia.max_value = GameData.magia_max
		%BarraMagia.value = GameData.magia_atual
		
		# Inicializa valores da barra de vida
		if GameData.vida_atual > 0 and GameData.vida_atual < GameData.vida_max:
			UpdateVida(GameData.vida_atual, 0)
			
		# Conecta sinais de dano, cura e morte
		Mundos.player.vida.connect("alterou_vida", UpdateVida)
		GameData.connect("update_magia", UpdateMagia)
		GameData.connect("update_vida", AdicionaCoracao)
		
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
	await get_tree().physics_frame
	Console._Print("[color=green]VIDA: %s[/color]" % [GameData.vida_atual])
	for c:TextureRect in coracoes:
		c.texture = sprite_cheio if c.get_index() + 1 <= vida_nova else sprite_vazio
	if vida_nova <= 0:
		PlayerMorreu()

func AdicionaCoracao() -> void:
	var coracao:TextureRect = TextureRect.new()
	coracao.custom_minimum_size = Vector2(50.0, 50.0)
	coracao.texture = sprite_cheio
	%BarraHeart.add_child(coracao)
	coracoes.append(coracao) # = %BarraHeart.get_children()

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

func AvisoItem(nome:String, desc:String, img:Texture2D) -> void:
	get_tree().paused = true
	#cena.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	%NomeItemAviso.text = nome
	%DescItemAviso.text = desc
	%ImgItemAviso.texture = img
	%Anim.play("PegaItemOn")
	await %Anim.animation_finished
	tela_item_on = true

# MOSTRA ITEM DO INVENTÁRIO
func MostraItem(nome:String, desc:String, cura:int = 0) -> void:
	inventario_itens.MostraItem(nome, desc, cura, sprite_cheio)

func MostraAmuleto(nome:String, desc:String) -> void:
	inventario_amuletos.MostraAmuleto(nome, desc)

func _on_sair_pressed() -> void:
	Mundos.CarregaFase(Mundos.NomeFase.MenuPrincipal)
