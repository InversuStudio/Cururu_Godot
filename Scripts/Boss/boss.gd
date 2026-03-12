extends Node2D

@export_group("Config")
## Area2D que checa se player está presente, para iniciar Boss Fight
@export var area_check_player: Area2D = null
## Posição nova da câmera durante batalha
@export var target_camera_batalha:Node2D = null

## Node do rabo
@export var rabo:HitBox = null
## Tempo parado após cuspir fogo
@export var tempo_idle_cuspe:float = 0.0
## Tempo parado após pilar de fogo
@export var tempo_idle_pilar:float = 0.0

@export_group("Pilares de Fogo")
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

var tween:Tween = null

var nocaute:bool = false
var morreu:bool = false

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
	
	# Sinais de vida
	%VidaBoss.connect("alterou_vida", TomouDano)
	%VidaMCabeca.connect("alterou_vida", func(atual:int, _old:int):
		ArmorDano()
		if atual <= 0:
			#Esconde sprite armadura
			%HurtCabeca.set_deferred("monitorable", false)
			await get_tree().create_timer(.1).timeout # Só pra ter hit flash
			%SpriteCabeca.hide()
			ChecaArmor()
	)
	%VidaMCorpo.connect("alterou_vida", func(atual:int, _old:int):
		ArmorDano()
		if atual <= 0:
			#Esconde sprite armadura
			%HurtCorpo.set_deferred("monitorable", false)
			await get_tree().create_timer(.1).timeout # Só pra ter hit flash
			%SpriteCorpo.hide()
			ChecaArmor()
	)
	vida_miasma_max = %VidaMCabeca.vida_max + %VidaMCorpo.vida_max
	vida_miasma_atual = vida_miasma_max
	
	# Sinais de hurtbox
	%HurtCabeca.hurt.connect(TomaDano)
	%HurtCorpo.hurt.connect(TomaDano)
	%HurtBox.monitorable = false
	
	# Inicializa barra de vida
	%BarraVida.max_value = %VidaBoss.vida_max
	%BarraVida.value = 0.0
	%BarraVida.hide()
	%BarraArmor.max_value = vida_miasma_max
	%BarraArmor.value = 0.0
	
	# Conecta sinal para iniciar luta
	if area_check_player:
		var start_state:State = state_machine.find_child("Start")
		if start_state:
			area_check_player.connect("body_entered", func(b:Node2D):
				start_state.PlayerEntrou(b)
				Mundos.main_camera.MudaTarget(target_camera_batalha, Vector2.ZERO)
				Mundos.main_camera.MudaZoom(.6)
			)
	
	# Inicializa rabo
	rabo.visibility_changed.connect(func():
		var val:bool = true if rabo.visible else false
		rabo.set_deferred("monitoring", val)
		rabo.set_deferred("monitorable", val))
	rabo.hide()

func ChecaArmor() -> void:
	if vida_miasma_atual <= 0:
		print("MIASMA DESTRUIDO")
		state_machine.MudaState(state_machine.find_child("Nocaute"))

func TomaDano(hit:Array[HitBox]) -> void:
	%VidaBoss.RecebeDano(hit[0].dano)

func TomouDano(vida_atual:int, _vida_antiga:int) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(%BarraVida, "value", vida_atual, .15)
	
	if vida_atual == 10:
		tempo_idle_cuspe /= 2.0
		tempo_idle_pilar /= 2.0

func ArmorDano() -> void:
	vida_miasma_atual = %VidaMCabeca.vida_atual + %VidaMCorpo.vida_atual
	var tween_a:Tween = create_tween()
	tween_a.tween_property(%BarraArmor, "value", vida_miasma_atual, .15)
	
	# Deixa ataques mais rápidos
	#if vida_atual == 10:
		#tempo_idle_cuspe /= 2.0
		#tempo_idle_pilar /= 2.0

func ResetArmor() -> void:
	vida_miasma_atual = vida_miasma_max
	%VidaMCabeca.RecebeCura(%VidaMCabeca.vida_max)
	%HurtCabeca.set_deferred("monitorable", true)
	%SpriteCabeca.show()
	
	%VidaMCorpo.RecebeCura(%VidaMCorpo.vida_max)
	%HurtCorpo.set_deferred("monitorable", true)
	%SpriteCorpo.show()

func SpawnPilar(pos:NodePath) -> void:
	var node:Node2D = get_node(pos)
	spawn_pilar.emit(node.global_position)

func Morte() -> void:
	%HurtBox.set_deferred("monitorable", false)#queue_free()
	%TimerNocaute.stop()
	%TimerIdle.stop()
	%BarraVida.hide()
	%Anim.play("Surge", -1, -1.0, true)
	morreu = true
	BGM.TocaMusica()
