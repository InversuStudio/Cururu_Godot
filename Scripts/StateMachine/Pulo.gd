extends State

@export_group("Próximos States")
## State de queda
@export var fall_state : State = null
## State de wall slide
@export var wall_state : State = null

# INICIA O STATE
func Enter() -> void:
	print("JUMP")
	parent.velocity.y = -parent.jump_force # Aplica pulo
	parent.anim.play("Jump") # Animação de pulo

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(delta: float) -> State:
	# Aplica gravidade de pulo
	parent.velocity.y += parent.jump_gravity * delta
	# Recebe input de movimento, aplica movimento
	parent.input_move = Input.get_axis("esquerda","direita")
	parent.velocity.x = parent.input_move * parent.air_speed
	
	# Se estiver caindo, muda State
	if parent.velocity.y >= 0.0:
		return fall_state
	# Se soltar botão de pulo, zera velocidade e muda State
	if Input.is_action_just_released("pulo"):
		parent.velocity.y = 0.0
		return fall_state
		
	return null # Não muda o State
