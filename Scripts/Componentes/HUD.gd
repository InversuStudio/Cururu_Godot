extends CanvasLayer

const sprite_cheio:Texture2D = preload("res://Sprites/UI/HUD/UIHUD-VIDACHEIA.png")
const sprite_vazio:Texture2D = preload("res://Sprites/UI/HUD/UIHUD-VIDAVAZIZ.png")

@export var inventario_itens:Control = null
@export var inventario_amuletos:Control = null

var hud_ativo:int = 0
var configurado:bool = false

var full_mapa:bool = false
var tempo_mapa:float = 0.0

# INPUT PAUSE
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("start"):
		if Mundos.player == null or AvisoItem.ativo: return
		%Pause.visible = true if %Pause.visible == false else false
	
	if Input.is_action_just_pressed("select") and %Pause.visible:
		Mundos.CarregaFase(Mundos.NomeFase.MenuPrincipal)
	
	if Input.is_action_just_pressed("bumper_direito"):
		if hud_ativo + 1 <= %ContainerAbas.get_child_count() - 1:
			hud_ativo += 1
			MudaAba()
	
	if Input.is_action_just_pressed("bumper_esquerdo") and %Pause.visible:
		if hud_ativo - 1 >= 0:
			hud_ativo -= 1
			MudaAba()
	
	if !Inventario.tem_mapa: return
	if Input.is_action_just_pressed("select"):
		full_mapa = true
	
	if Input.is_action_just_released("select"):
		if %MapaSmall.visible:
			%MapaSmall.hide()
		elif tempo_mapa < 1.0 and not %Pause.visible:
			%MapaSmall.show()
		full_mapa = false
		tempo_mapa = 0.0

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

func _ready() -> void:
	# Conecta sinais de mudança de valor
	GameData.connect("update_magia", UpdateMagia)
	GameData.connect("update_vida_max", AdicionaCoracao)
	GameData.connect("update_vida_atual", UpdateVida)
	GameData.connect("update_moeda", UpdateMoeda)
	Mundos.connect("fase_mudou", MostraHUD)
	%Pause.connect("visibility_changed", func():
		get_tree().paused = true if %Pause.visible else false)
	# Organiza visibilidade das abas
	MudaAba()
	MostraHUD()
	
	%BtnContinuar.connect("pressed", func(): %Pause.visible = false)
	%BtnSair.connect("pressed", func(): Mundos.CarregaFase(Mundos.NomeFase.MenuPrincipal))
	%Opcoes.connect("visibility_changed", func():
		if %Opcoes.visible: %BtnContinuar.grab_focus())
	
	# Lógica para evitar bugs durante testes
	await get_tree().physics_frame
	if Mundos.player and GameData.vida_max > 0:
		IniciaHUD()

func MudaAba() -> void:
	for c:Control in %ContainerMenus.get_children():
		if c.get_index() == hud_ativo:
			c.show()
			%ContainerAbas.get_child(hud_ativo).button_pressed = true
		else: c.hide()

func MostraHUD() -> void:
	%Pause.hide()
	#%AvisoItem.modulate.a = 0.0
	#%AvisoItem.show()
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
		%BarraMagia.max_value = GameData.magia_max
		%BarraMagia.value = GameData.magia_atual
		UpdateMoeda()
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

func AvisoSave() -> void:
	%Anim.play("JogoSalvo")

# MOSTRA ITEM DO INVENTÁRIO
func MostraItem(nome:String, desc:String, cura:int = 0) -> void:
	inventario_itens.MostraItem(nome, desc, cura, sprite_cheio)

# MOSTRA AMULETOS DO INVENTÁRIO
func MostraAmuleto(nome:String, desc:String) -> void:
	inventario_amuletos.MostraAmuleto(nome, desc)

# DELETA TODOS OS ITENS DA UI INVENTÁRIO
func LimpaInv() -> void:
	inventario_itens.LimpaInv()
	inventario_amuletos.LimpaAm()
