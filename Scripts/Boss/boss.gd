extends Node2D

@export_group("Config")
## Area2D que checa se player está presente, para iniciar Boss Fight
@export var area_check_player: Area2D = null
## Posição nova da câmera durante batalha
@export var target_camera_batalha:Node2D = null

## Node do rabo
@export var rabo:HitBox = null
@export var pos_rabo:Array[Marker2D] = [] # [pos baixo, pos cima]
## Tempo parado após cuspir fogo
@export var tempo_idle_cuspe:float = 0.0
## Tempo parado após pilar de fogo
@export var tempo_idle_pilar:float = 0.0
## Número de ataques até trocar de lado
@export var num_ate_trocar_lado:int = 3
@onready var natl:int = num_ate_trocar_lado

@export_group("Pilares de Fogo")
## Node que carrega os pilares no cenário
@export var parent_pilares:Node2D = null
## Distância em que boss usa pilar de fogo
@export var dist_para_pilar:float = 7.0
## Lista contendo os pontos onde os pilares spawnam
@export var spawn_pilares:Array[Marker2D] = []
## Tempo que pilar leva para carregar
@export var tempo_carga_pilar:float = .8
## Tempo entre spawn de pilares de fogo
@export var tempo_ate_prox_pilar:float = .5

signal spawn_pilar

@export_group("Misc.")
## Música Boss
@export var musica_luta:AudioStream = null
# Número ataques que se passaram
var num_vul:int = 0
# Componente StateMachine
@onready var state_machine: StateMachine = $StateMachine
## Node de posição do Boss, para quando ele for trocar de lado
@export var flip_node:Array[Marker2D] = []
## Zoom aplicado à câmera ao iniciar batalha
@export var zoom:float = .6
## Arquivos de áudio contendo as vozes de fala
@export var vozes_fala:Array[AudioStream] = []
## Luz do boss
@export var luz_boss:Light2D = null

var tween:Tween = null
var nocaute:bool = false
var luz:float = 0.0

var vida_miasma_max:int = 0
var vida_miasma_atual:int = 0

## Lista de gritos do Boitatá.[br]O primeiro item é o rigido de entrada
@export var gritos:Array[AudioStream] = []

## Arquivo de diálogo
@export var dialogo:DialogueResource = null

func _process(delta: float) -> void:
	state_machine.Update(delta)
	
func _physics_process(delta: float) -> void:
	state_machine.FixedUpdate(delta)

func _ready() -> void:
	# Reseta shader hit flash
	%SpriteMain.material.set_shader_parameter("valor", 0.0)
	%Titulo.modulate.a = 0.0
	
	DialogueManager.connect("got_dialogue", func(_l:DialogueLine) -> void:
		var id:int = randi_range(0, vozes_fala.size() - 1)
		if id >= 0: DialogoCMD.voz = vozes_fala[id])
	
	luz = luz_boss.energy
	luz_boss.energy = 0.0
	
	# Sinais de vida
	%VidaBoss.connect("alterou_vida", TomouDano)
	#%VidaMCabeca.connect("alterou_vida", func(atual:int, _old:int):
	%HurtCabeca.connect("hurt", func(h:Array[HitBox]) -> void:
		ArmorDano(%VidaMCabeca, h)
		if %VidaMCabeca.vida_atual <= 0:
			#Esconde sprite armadura
			#%HurtCabeca.set_deferred("monitorable", false)
			%HurtCabeca.comp_vida = %VidaBoss
			#%HurtCabeca.sprite = %SpriteMain
			await get_tree().create_timer(.1).timeout # Só pra ter hit flash
			%SpriteCabeca.hide()
			ChecaArmor()
	)
	#%VidaMCorpo.connect("alterou_vida", func(atual:int, _old:int):
	%HurtCorpo.connect("hurt", func(h:Array[HitBox]) -> void:
		ArmorDano(%VidaMCorpo, h)
		if %VidaMCorpo.vida_atual <= 0:
			#Esconde sprite armadura
			#%HurtCorpo.set_deferred("monitorable", false)
			%HurtCorpo.comp_vida = %VidaBoss
			#%HurtCorpo.sprite = %SpriteMain
			await get_tree().create_timer(.1).timeout # Só pra ter hit flash
			%SpriteCorpo.hide()
			ChecaArmor()
	)
	vida_miasma_max = %VidaMCabeca.vida_max + %VidaMCorpo.vida_max
	vida_miasma_atual = vida_miasma_max
	
	# Sinais de hurtbox
	%HurtBox.monitorable = false
	
	# Inicializa barra de vida
	%BarraVida.max_value = %VidaBoss.vida_max
	%BarraVida.value = 0.0
	%BarraArmor.max_value = vida_miasma_max
	%BarraArmor.value = 0.0
	%UI_BOSS.hide()
	
	# Inicializa rabo
	rabo.visibility_changed.connect(func():
		var val:bool = true if rabo.visible else false
		rabo.set_deferred("monitoring", val)
		rabo.set_deferred("monitorable", val))
	rabo.global_position = pos_rabo[0].global_position
	rabo.hide()

func ChecaArmor() -> void:
	if vida_miasma_atual <= 0 and %VidaBoss.vida_atual > 0:
		print("MIASMA DESTRUIDO")
		%HurtCabeca.set_deferred("monitorable", false)
		%HurtCorpo.set_deferred("monitorable", false)
		state_machine.MudaState(state_machine.find_child("Nocaute"))

func TomouDano(vida_atual:int, _vida_antiga:int) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(%BarraVida, "value", vida_atual, .15)
	
	if vida_atual == 20:
		tempo_idle_cuspe /= 1.0
		tempo_idle_pilar /= 1.5
	
	%SpriteMain.material.set_shader_parameter("valor", 1.0)
	await get_tree().create_timer(.2).timeout
	%SpriteMain.material.set_shader_parameter("valor", 0.0)

func ArmorDano(vida:Vida, h:Array[HitBox]) -> void:
	for hit:HitBox in h:
		if hit.is_in_group("Special"):
			vida.RecebeDano(1.5)
	vida_miasma_atual = %VidaMCabeca.vida_atual + %VidaMCorpo.vida_atual
	var tween_a:Tween = create_tween()
	tween_a.tween_property(%BarraArmor, "value", vida_miasma_max - vida_miasma_atual, .15)

func ResetArmor() -> void:
	if %VidaBoss.vida_atual <= 0: return
	vida_miasma_atual = vida_miasma_max
	
	%HurtCabeca.comp_vida = %VidaMCabeca
	#%HurtCabeca.sprite = %SpriteCabeca
	%VidaMCabeca.RecebeCura(%VidaMCabeca.vida_max)
	%HurtCabeca.set_deferred("monitorable", true)
	%SpriteCabeca.show()
	
	%HurtCorpo.comp_vida = %VidaMCorpo
	#%HurtCorpo.sprite = %SpriteCorpo
	%VidaMCorpo.RecebeCura(%VidaMCorpo.vida_max)
	%HurtCorpo.set_deferred("monitorable", true)
	%SpriteCorpo.show()

func SpawnPilar(pos:NodePath) -> void:
	var node:Node2D = get_node(pos)
	spawn_pilar.emit(node.global_position)

func Morte() -> void:
	%HurtBox.set_deferred("monitorable", false)
	%HurtCabeca.set_deferred("monitorable", false)
	%HurtCorpo.set_deferred("monitorable", false)
	%TimerNocaute.stop()
	%TimerIdle.stop()
	%TimerPilar.stop()
	%UI_BOSS.hide()
	BGM.TocaMusica()
	await get_tree().physics_frame
	state_machine.MudaState(state_machine.find_child("Final"))
