extends State

@export var chao_state:State = null

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	parent.input_move.x = 0.0
	parent.velocity.x = 0.0
	%Anim.play("Acorda")
	await %Anim.animation_finished
	get_parent().MudaState(chao_state)

func FixedUpdate(delta : float) -> State:
	parent.velocity.y += parent.fall_gravity * delta
	return null

func Exit() -> void:
	parent.pode_mover = true
