extends State

@export_group("Próximos States")
## State de queda
@export var fall_state : State = null
## State de wall slide
@export var wall_state : State = null
## State de dash
@export var dash_state : State = null

# INICIA O STATE
func Enter() -> void:
	print("JUMP")
	parent.velocity.y = -parent.jump_force # Aplica pulo
	%Anim.play("Jump") # Animação de pulo

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(delta: float) -> State:
	# Aplica gravidade de pulo
	parent.velocity.y += parent.jump_gravity * delta
	
	# Recebe input de movimento
	var input_move = Input.get_axis("esquerda","direita")
	# Aplica movimento
	parent.velocity.x = input_move * parent.speed
	
	# Espelha o sprite de acordo com o input
	if input_move > 0:
		%Cururu.flip_h = false
		parent.hitbox_container.scale.x = 1
	elif input_move < 0:
		%Cururu.flip_h = true
		parent.hitbox_container.scale.x = -1
	
	# Se estiver caindo, muda State
	if parent.velocity.y >= 0.0:
		return fall_state
	# Se soltar botão de pulo, zera velocidade e muda State
	if Input.is_action_just_released("pulo"):
		parent.velocity.y = 0.0
		return fall_state
	
	# INPUT DASH
	if Input.is_action_just_pressed("dash") and parent.pode_dash:
		return dash_state
		
	return null # Não muda o State
