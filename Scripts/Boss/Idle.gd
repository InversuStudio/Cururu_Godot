extends State

## State de Cuspir Fogo
@export var state_cospe_fogo: State = null
## State de Pilar de Fogo
@export var state_pilar_fogo: State = null
## State de Vulnerável
@export var state_nocaute: State = null

var prosseguir:bool = false

func Enter() -> void:
	%Anim.play("Idle")
	%TimerIdle.start()
	parent.ShowPartes()
	#if parent.num_vul >= parent.num_ate_vulneravel:
		#get_parent().MudaState(state_nocaute)
		#parent.num_vul = 0
		#%TimerIdle.stop()

func FixedUpdate(_delta : float) -> State:
	if prosseguir:
		var dist:float = Mundos.player.global_position.x - parent.global_position.x
		if abs(dist) <= parent.dist_para_pilar * 128:
			return state_pilar_fogo
		return state_cospe_fogo
		#if randi_range(0,1) == 1:
			#return state_cospe_fogo
		#return state_pilar_fogo
	return null
	
func _on_timer_idle_timeout() -> void:
	prosseguir = true

func Exit() -> void:
	prosseguir = false
	%TimerIdle.stop()
	parent.HidePartes()
