extends CanvasLayer

const sprite_cheio:Texture2D = preload("res://Sprites/UI/HUD/Barra_Vida/UIHUD-VIDACHEIA.png")
const sprite_vazio:Texture2D = preload("res://Sprites/UI/HUD/Barra_Vida/UIHUD-VIDAVAZIZ.png")

@export var inventario_itens:Control = null
@export var inventario_amuletos:Control = null
@export var item_rapido:Control = null
signal usa_item_rapido

var hud_ativo:int = 0
var configurado:bool = false

var full_mapa:bool = false
var tempo_mapa:float = 0.0

var tipo_input:int = 0

# INPUT PAUSE
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("start"):
		var dialogo_ativo = get_tree().root.find_child("BalaoFala", true, false)
		if Mundos.player == null or AvisoItem.ativo or dialogo_ativo: return
		%Pause.visible = true if %Pause.visible == false else false
	
	if Input.is_action_just_pressed("ui_cancel"):
		if %Pause.visible:
			%Pause.visible = false
			Mundos.player.pode_ataque = false
			await get_tree().create_timer(.1).timeout
			Mundos.player.pode_ataque = true
		
	if Input.is_action_just_pressed("bumper_direito") and %Pause.visible:
		if hud_ativo + 1 <= %ContainerAbas.get_child_count() - 1:
			hud_ativo += 1
			print("É, MEU BOM. A VIDA É TRISTE")
			MudaAba()
	
	if Input.is_action_just_pressed("bumper_esquerdo") and %Pause.visible:
		if hud_ativo - 1 >= 0:
			hud_ativo -= 1
			MudaAba()
	
	if tipo_input != GameData.tipo_input:
		tipo_input = GameData.tipo_input
		MudaImgInput()
	
	#if !Inventario.tem_mapa: return
	#if Input.is_action_just_pressed("select"):
		#full_mapa = true
	#
	#if Input.is_action_just_released("select"):
		#if %MapaSmall.visible:
			#%MapaSmall.hide()
		#elif tempo_mapa < 1.0 and not %Pause.visible:
			#%MapaSmall.show()
		#full_mapa = false
		#tempo_mapa = 0.0

func _process(delta: float) -> void:
	if full_mapa:
		tempo_mapa += delta
		if tempo_mapa >= 1:
			full_mapa = false
			tempo_mapa = 0.0
			hud_ativo = 2
			MudaAba()
			%MapaSmall.hide()
			%Pause.show()
	if !Inventario.tem_mapa: return
	if Input.is_action_pressed("select") and not %Pause.visible:
		%MapaSmall.show()
	else:
		%MapaSmall.hide()

func MudaImgInput() -> void:
	%Select.text = "[img]%s[/img]   %s" % [GameData.GetUiButtonImage("ui_accept"), "Selecionar"]
	%Back.text = "[img]%s[/img]   %s" % [GameData.GetUiButtonImage("ui_cancel"), "Voltar"]

func _ready() -> void:
	# Conecta sinais de mudança de valor
	#GameData.connect("update_magia", UpdateMagia)
	#GameData.connect("update_miasma", UpdateMiasma)
	GameData.connect("update_vida_max", AdicionaCoracao)
	GameData.connect("update_vida_atual", UpdateVida)
	GameData.connect("update_moeda", UpdateMoeda)
	get_tree().scene_changed.connect(MostraHUD)
	
	item_rapido.connect("usa_item", usa_item_rapido.emit)
	
	%Pause.connect("visibility_changed", func():
		get_tree().paused = true if %Pause.visible else false)
	# Organiza visibilidade das abas
	MudaAba()
	MostraHUD()
	
	MudaImgInput()
	%Red.modulate.a = 0.0
	
	%BtnContinuar.connect("pressed", func(): %Pause.visible = false)
	%BtnSair.connect("pressed", func():
		LoadCena.Load("res://UI/MenuPrincipal.tscn")
		item_rapido.ResetaBarra())
	%Opcoes.connect("visibility_changed", func():
		if %Opcoes.visible: %BtnContinuar.grab_focus())
		
	%OpcoesAudio.connect("visibility_changed", func():
		if %OpcoesAudio.visible: %SliderMaster.grab_focus())
	
	%SliderMaster.connect("value_changed", func(valor:float):
		var bus:int = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(bus, linear_to_db(valor)))
		
	%SliderBGM.connect("value_changed", func(valor:float):
		var bus:int = AudioServer.get_bus_index("BGM")
		AudioServer.set_bus_volume_db(bus, linear_to_db(valor)))
		
	%SliderSFX.connect("value_changed", func(valor:float):
		var bus:int = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(bus, linear_to_db(valor)))
	
	# Lógica para evitar bugs durante testes
	await get_tree().physics_frame
	if Mundos.player and GameData.vida_max > 0:
		IniciaHUD()
		MostraHUD()

func MudaAba() -> void:
	for c:Control in %ContainerMenus.get_children():
		if c.get_index() == hud_ativo:
			c.show()
			%ContainerAbas.get_child(hud_ativo).button_pressed = true
		else: c.hide()

func MostraHUD() -> void:
	%Pause.hide()
	%AvisoSave.self_modulate.a = 0.0
	%MapaSmall.hide()
	if Mundos.player: %Corpo.show()
	else: %Corpo.hide()

# FUNÇÃO PARA ATUALIZAR O HUD PELA PRIMEIRA VEZ
func IniciaHUD() -> void:
	# Se achar Player na cena e não estiver configurado...
	if Mundos.player and configurado == false:
		# Remove corações antigos
		var c:int = %BarraHeart.get_child_count() - 1
		while c >= 0:
			%BarraHeart.remove_child(%BarraHeart.get_child(c))
			c -= 1
		# Adiciona novos corações na barra de vida
		var i:int = 0
		for n:int in GameData.vida_max:
			AdicionaCoracao(i)
			i += 1
		# Inicializa valores
		%BarraAgua.tamanho = GameData.magia_max
		%BarraAgua.valor = %BarraAgua.tamanho
		%BarraAgua.last_val = %BarraAgua.valor
		%BarraAgua.step = %BarraAgua.textura.size.y / %BarraAgua.tamanho
		#%BarraAgua.tamanho = GameData.magia_max
		#%BarraAgua.valor = GameData.magia_atual
		#%BarraMagia.max_value = GameData.magia_max
		#%BarraMagia.value = GameData.magia_atual
		#%Separador.max_value = GameData.magia_max
		#%Separador.value = GameData.magia_atual
		
		#%BarraMiasma.max_value = GameData.magia_max
		#%BarraMiasma.value = 0.0
		UpdateMoeda()
		item_rapido.IniciaBarra()
		# Marca como configurado
		configurado = true

# Função para atualizar contador de moedas
func UpdateMoeda() -> void:
	# Funciona apenas se o player não estiver morto
	%CounterMoeda.text = str(GameData.moedas)

# Função para alterar valor da barra de vida
func UpdateVida() -> void:
	Console._Print("[color=green]VIDA: %s[/color]" % [GameData.vida_atual])
	for c:TextureRect in %BarraHeart.get_children():
		c.texture = sprite_cheio if c.get_index() + 1 <= GameData.vida_atual else sprite_vazio

func AdicionaCoracao(old:int) -> void:
	if GameData.vida_max > old:
		var coracao:TextureRect = TextureRect.new()
		coracao.custom_minimum_size = Vector2(50.0, 50.0)
		coracao.texture = sprite_cheio
		%BarraHeart.add_child(coracao)
		
	elif GameData.vida_max < old:
		var child:Node = %BarraHeart.get_child(%BarraHeart.get_child_count() - 1)
		%BarraHeart.remove_child(child)
	
func UpdateMagia() -> void:
	Console._Print("[color=cyan]MAGIA: %s[/color]" % [GameData.magia_atual])
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(%BarraMagia,"value",GameData.magia_atual,.3).set_trans(
		Tween.TRANS_CUBIC)
	var t:Tween = get_tree().create_tween()
	t.tween_property(%Separador,"value",GameData.magia_atual,.3).set_trans(
		Tween.TRANS_CUBIC)

func UpdateMiasma() -> void:
	Console._Print("MIASMA")
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(%BarraMiasma,"value",GameData.miasma,.3).set_trans(
		Tween.TRANS_CUBIC)

func AvisoSave() -> void:
	%Anim.play("JogoSalvo")

# MOSTRA ITEM DO INVENTÁRIO
func MostraItem(nome:String, desc:String, cura:int = 0) -> void:
	inventario_itens.MostraItem(nome, desc, cura, sprite_cheio)

# MOSTRA AMULETOS DO INVENTÁRIO
func MostraAmuleto(nome:String, desc:String) -> void:
	inventario_amuletos.MostraAmuleto(nome, desc)

func AplicaRed(vida:int) -> void:
	var color:Color = Color.WHITE
	if vida == 2:
			color.a = 0.5
	elif vida <= 1:
			color.a = 1.0
	else:
		color.a = 0.0
	var tween:Tween = create_tween()
	tween.tween_property(%Red, "modulate", color, .3)

# DELETA TODOS OS ITENS DA UI INVENTÁRIO
func LimpaInv() -> void:
	inventario_itens.LimpaInv()
	inventario_amuletos.LimpaAm()
	item_rapido.IniciaBarra()
