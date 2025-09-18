extends State

@export_group("Próximos States")
## State de queda
@export var fall_state : State = null
## State de dash
@export var dash_state : State = null
## State de ataque melee
@export var melee_state: State = null
## State de ataque magico
@export var special_state: State = null

# INICIA O STATE
func Enter() -> void:
	print("JUMP")
	Console._State(name)
	parent.velocity.y = -parent.jump_force # Aplica pulo
	%Anim.play("Jump") # Animação de pulo

func Update(_delta: float) -> State:
	# INPUT MELEE
	if Input.is_action_just_pressed("melee"):
		return melee_state
	# INPUT MAGIA
	if Input.is_action_just_pressed("magia"
	) and GameData.upgrade_num >= 1 and GameData.magia_atual >= 3:
		return special_state
	# INPUT DASH
	if Input.is_action_just_pressed("dash") and parent.pode_dash:
		return dash_state
	
	return null

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(delta: float) -> State:
	# Aplica gravidade de pulo
	parent.velocity.y += parent.jump_gravity * delta
	
	# Aplica movimento
	#var dir = parent.input_move * parent.air_speed
	#parent.velocity.x = move_toward(parent.velocity.x, dir, parent.accel * delta)
	var dir = parent.input_move
	if dir != 0.0:
		parent.velocity.x += parent.accel * dir * delta
		if abs(parent.velocity.x) > parent.air_speed:
			parent.velocity.x = parent.air_speed * dir
	#parent.velocity.x = parent.input_move * parent.air_speed
	
	# Espelha o sprite de acordo com o input
	if parent.input_move > 0:
		%Cururu.flip_h = false
		parent.hitbox_container.scale.x = 1
	elif parent.input_move < 0:
		%Cururu.flip_h = true
		parent.hitbox_container.scale.x = -1
	
	# Se estiver caindo, muda State
	if parent.velocity.y >= 0.0:
		return fall_state
	# Se soltar botão de pulo, zera velocidade e muda State
	if Input.is_action_just_released("pulo") and parent.pode_mover:
		parent.velocity.y = 0.0
		return fall_state
		
	return null # Não muda o State
