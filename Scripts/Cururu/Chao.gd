extends State

@export_group("Próximos States")
## State de pulo
@export var pulo_state : State = null
## State de queda
@export var fall_state : State = null
## State de dash
@export var dash_state : State = null
## State de dano
@export var dano_state: State = null
## State de ataque melee
@export var melee_state: State = null
## State de ataque magico
@export var magia_state: State = null
 
# INICIA O STATE
func Enter() -> void:
	print("CHAO")

func Update(_delta: float) -> State:
	# INPUT MELEE
	if Input.is_action_just_pressed("melee"):
		return melee_state
	# INPUT MAGIA
	if Input.is_action_just_pressed("magia") and GameData.magia_atual >= 4:
		return magia_state
	# INPUT DASH
	if Input.is_action_just_pressed("dash") and parent.pode_dash:
		return dash_state
	return null # Não muda o State

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(_delta: float) -> State:
	# DANO
	if parent.recebeu_dano:
		return dano_state
		
	# Aplica movimento
	var dir = parent.input_move * parent.speed
	parent.velocity.x = move_toward(parent.velocity.x, dir, parent.speed / 8)
	#parent.velocity.x = parent.input_move * parent.speed
	
	# Espelha o sprite de acordo com o input
	if parent.input_move > 0:
		%Cururu.flip_h = false
		parent.hitbox_container.scale.x = 1
	elif parent.input_move < 0:
		%Cururu.flip_h = true
		parent.hitbox_container.scale.x = -1
	
	if parent.is_on_floor():
		# Controla animações de parado e correndo
		if parent.input_move: %Anim.play("Run")
		else: %Anim.play("Idle")
		
		# Ao pressionar input de Pulo, mudar State
		if Input.is_action_just_pressed("pulo") and parent.pode_mover:
			return pulo_state
			
	# Se não estiver no chão, mudar State
	if not parent.is_on_floor():
		parent.is_coyote = true
		%Coyote.start()
		return fall_state
		
	return null # Não muda o State
