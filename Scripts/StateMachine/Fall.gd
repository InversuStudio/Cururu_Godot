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
## State de dash
@export var dash_state : State = null

# INICIA O STATE
func Enter() -> void:
	print("FALL")
	%Anim.play("Fall") # Animação de cair

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(delta: float) -> State:
	if Input.is_action_just_pressed("pulo"):
		if parent.is_coyote:
			return pulo_state
		parent.is_jump_lag = true
		%JumpLag.start()
	# Aplica gravidade de queda
	parent.velocity.y += parent.fall_gravity * delta
	
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
	
	# Se estiver no chão, mudar State
	if parent.is_on_floor():
		# Aplica Jump Lag
		if parent.is_jump_lag:
			parent.is_jump_lag = false
			return pulo_state
		return chao_state
		
	# INPUT DASH
	if Input.is_action_just_pressed("dash") and parent.pode_dash:
		return dash_state
		
	return null # Não muda o State

func _on_coyote_timeout() -> void:
	parent.is_coyote = false

func _on_jump_lag_timeout() -> void:
	parent.is_jump_lag = false
