extends Node2D

## Area2D que checa se player está presente, para iniciar Boss Fight
@export var area_check_player: Area2D = null
## Câmera da batalha
@export var camera_batalha:MainCamera = null
## Posição nova da câmera durante batalha
@export var target_camera_batalha:Node2D = null
## Posições onde pilares de fogo vão spawnar
@export var pos_pilares: Array[Node2D] = []
# Número de ataques até ficar vulnerável
#@export var num_ate_vulneravel: int = 2
## Distância em que boss usa pilar de fogo
@export var dist_para_pilar:float = 0.0
## Node do rabo
@export var rabo:HitBox = null
## Tempo parado após cuspir fogo
@export var tempo_idle_cuspe:float = 0.0
## Tempo parado após pilar de fogo
@export var tempo_idle_pilar:float = 0.0
## Música Boss
@export var musica_luta:AudioStream = null
# Número ataques que se passaram
var num_vul:int = 0
# Componente StateMachine
@onready var state_machine: StateMachine = $StateMachine

var tween:Tween = null

var morreu:bool = false

## Lista de gritos do Boitatá.[br]O primeiro item é o rigido de entrada
@export var gritos:Array[AudioStream] = []

## Arquivo de diálogo
@export var dialogo:DialogueResource = null

func ChecaArmor() -> void:
	if %VidaMCorpo.vida_atual <= 0:
	#if %VidaMCabeca.vida_atual <= 0 and %VidaMCorpo.vida_atual <= 0:
		state_machine.MudaState(state_machine.find_child("Nocaute"))

func _ready() -> void:
	%SpriteMain.material.set_shader_parameter("valor", 0.0)
	# Sinais de vida
	%VidaBoss.connect("alterou_vida", TomouDano)
	%VidaMCabeca.connect("alterou_vida", func(atual:int, _old:int):
		if atual <= 0:
			#Esconde sprite armadura
			%HurtCabeca.set_deferred("monitorable", false)
			%HurtCabeca.hide()
			ChecaArmor()
	)
	%VidaMCorpo.connect("alterou_vida", func(atual:int, old:int):
		ArmorDano(atual, old)
		if atual <= 0:
			#Esconde sprite armadura
			%HurtCorpo.set_deferred("monitorable", false)
			%HurtCorpo.hide()
			ChecaArmor()
	)
	
	# Sinais de hurtbox
	%HurtBox.monitorable = false
	
	# Inicializa barra de vida
	%BarraVida.max_value = %VidaBoss.vida_max
	%BarraVida.value = 0.0
	%BarraVida.hide()
	%BarraArmor.max_value = %VidaMCorpo.vida_max
	%BarraArmor.value = 0.0
	
	# Conecta sinal para iniciar luta
	if area_check_player:
		var start_state:State = state_machine.find_child("Start")
		if start_state:
			area_check_player.connect("body_entered", func(b:Node2D):
				start_state.PlayerEntrou(b)
				camera_batalha.MudaTarget(target_camera_batalha, Vector2.ZERO)
				camera_batalha.MudaZoom(.6)
				#camera_batalha.
			)
	
	# Inicializa rabo
	rabo.visibility_changed.connect(func():
		var val:bool = true if rabo.visible else false
		rabo.set_deferred("monitoring", val)
		rabo.set_deferred("monitorable", val))
	rabo.hide()
	
	HidePartes()

func _process(delta: float) -> void:
	state_machine.Update(delta)
	
func _physics_process(delta: float) -> void:
	state_machine.FixedUpdate(delta)

func TomouDano(vida_atual:int, _vida_antiga:int) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(%BarraVida, "value", vida_atual, .15)
	
	if vida_atual == 10:
		tempo_idle_cuspe /= 2.0
		tempo_idle_pilar /= 2.0

func ArmorDano(vida_atual:int, _vida_antiga:int) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(%BarraArmor, "value", vida_atual, .15)
	
	if vida_atual == 10:
		tempo_idle_cuspe /= 2.0
		tempo_idle_pilar /= 2.0


func ResetArmor() -> void:
	%VidaMCabeca.RecebeCura(100)
	%HurtCabeca.set_deferred("monitorable", true)
	#%HurtCabeca.show()
	
	%VidaMCorpo.RecebeCura(100)
	%HurtCorpo.set_deferred("monitorable", true)
	#%HurtCorpo.show()

func Morte() -> void:
	%HurtBox.queue_free()
	%TimerNocaute.stop()
	%TimerIdle.stop()
	%BarraVida.hide()
	%Anim.play("Surge", -1, -1.0, true)
	morreu = true
	BGM.TocaMusica()
	#Mundos.CarregaFase(Mundos.NomeFase.FinalDemo)

# ESSAS FUNÇÕES SÃO TEMPORÁRIAS
func HidePartes() -> void:
	%SpriteCabeca.hide()
	%SpriteCorpo.hide()
	$Temp.hide()
	
	%SpriteCabeca.stop()
	%SpriteCorpo.stop()
	$Temp.stop()

func ShowPartes() -> void:
	%SpriteCabeca.show()
	%SpriteCorpo.show()
	$Temp.show()
	
	%SpriteCabeca.play("Idle")
	%SpriteCorpo.play("Idle")
	$Temp.play("default")
