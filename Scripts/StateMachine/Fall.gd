extends State

@export_group("Próximos States")
## State de chão
@export var chao_state : State = null
## State de wall slide
@export var wall_state : State = null
## State de pulo
@export var pulo_state : State = null
## State de nado
@export var nadando_state : State = null

# INICIA O STATE
func Enter() -> void:
	print("FALL")
	parent.anim.play("Fall") # Animação de cair

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(delta: float) -> State:
	if Input.is_action_just_pressed("pulo") and parent.is_coyote:
		return pulo_state
	# Aplica gravidade de queda
	parent.velocity.y += parent.fall_gravity * delta
	# Recebe input de movimento, aplica movimento
	parent.input_move = Input.get_axis("esquerda","direita")
	parent.velocity.x = parent.input_move * parent.air_speed
	
	# Se estiver no chão, mudar State
	if parent.is_on_floor():
		return chao_state
		
	return null # Não muda o State

func _on_coyote_timeout() -> void:
	parent.is_coyote = false
