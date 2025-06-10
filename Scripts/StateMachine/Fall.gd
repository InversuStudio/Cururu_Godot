extends State

@export_group("Próximos States")
## State de chão
@export var chao_state : State = null
## State de wall slide
@export var wall_state : State = null
## State de nado
@export var nadando_state : State = null

# INICIA O STATE
func Enter() -> void:
	print("FALL")
	parent.anim.play("Fall") # Animação de cair

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(_delta: float) -> State:
	# Aplica gravidade de queda
	parent.velocity.y += parent.fall_gravity
	# Recebe input de movimento, aplica movimento
	parent.input_move = Input.get_axis("esquerda","direita")
	parent.velocity.x = parent.input_move * parent.air_speed * 10
	
	# Se estiver no chão, mudar State
	if parent.is_on_floor():
		return chao_state
		
	return null # Não muda o State
