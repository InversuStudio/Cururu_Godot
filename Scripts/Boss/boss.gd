extends Node2D

## Area2D que checa se player está presente, para iniciar Boss Fight
@export var area_check_player: Area2D = null
## Posições onde pilares de fogo vão spawnar
@export var pos_pilares: Array[Node2D] = []
## Número de ataques até ficar vulnerável
@export var num_ate_vulneravel: int = 2
## Música Boss
@export var musica_luta:AudioStream = null
# Número ataques que se passaram
var num_vul:int = 0
# Componente StateMachine
@onready var state_machine: StateMachine = $StateMachine

var tween:Tween = null

var morreu:bool = false

func _ready() -> void:
	Console._Print(pos_pilares.size())
	%Vida.connect("alterou_vida", TomouDano)
	%HurtBox.monitorable = false
	%BarraVida.max_value = %Vida.vida_max
	%BarraVida.value = 0.0
	%BarraVida.hide()
	if area_check_player:
		var start_state:State = state_machine.find_child("Start")
		if start_state:
			area_check_player.connect("body_entered", start_state.PlayerEntrou)

func _process(delta: float) -> void:
	state_machine.Update(delta)
	
func _physics_process(delta: float) -> void:
	state_machine.FixedUpdate(delta)

func TomouDano(vida_atual:int, _vida_antiga:int) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(%BarraVida, "value", vida_atual, .15)
	Console._Print(vida_atual)

func Morte() -> void:
	%HurtBox.queue_free()
	%TimerNocaute.stop()
	%TimerIdle.stop()
	%BarraVida.hide()
	%Anim.play("Surge", -1, -1.0, true)
	morreu = true
	#BGM.TocaMusica()
	Mundos.CarregaFase(Mundos.NomeFase.FinalDemo)
