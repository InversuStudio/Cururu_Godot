extends State

@export_group("Próximos States")
## State de chão
@export var chao_state : State = null
## State de pulo
@export var pulo_state : State = null
## State de dash
@export var dash_state : State = null
## State de ataque melee
@export var melee_state: State = null
## State de ataque magico
@export var special_state: State = null

# INICIA O STATE
func Enter() -> void:
	print("FALL")
	Console._State(name)
	%Anim.play("Fall_Start") # Animação de cair

func Update(_delta: float) -> State:
	# INPUT MELEE
	if Input.is_action_just_pressed("melee"):
		return melee_state
	# INPUT MAGIA
	if Input.is_action_just_pressed("magia"
	) and GameData.upgrade_num >= 1 and GameData.magia_atual >= 3:
		return special_state
	# INPUT PULO
	if Input.is_action_just_pressed("pulo"):
		if parent.is_coyote:
			return pulo_state
		parent.is_jump_lag = true
		%JumpLag.start()
	# INPUT DASH
	if Input.is_action_just_pressed("dash") and parent.pode_dash:
		if parent.deu_air_dash == false:
			return dash_state
	return null

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(delta: float) -> State:
	# Aplica gravidade de queda
	parent.velocity.y += parent.fall_gravity * delta
	
	# Aplica movimento
	#var dir = parent.input_move * parent.air_speed
	#parent.velocity.x = move_toward(parent.velocity.x, dir, parent.accel * delta)
	var dir = parent.input_move
	if dir != 0.0:
		parent.velocity.x += parent.accel * dir * delta
		if abs(parent.velocity.x) > parent.air_speed:
			parent.velocity.x = parent.air_speed * dir
	#else:
		#parent.velocity.x = move_toward(parent.velocity.x, dir, parent.decel * delta)
	#parent.velocity.x = parent.input_move * parent.air_speed
	
	# Espelha o sprite de acordo com o input
	if parent.input_move > 0:
		%Cururu.flip_h = false
		parent.hitbox_container.scale.x = 1
	elif parent.input_move < 0:
		%Cururu.flip_h = true
		parent.hitbox_container.scale.x = -1
	
	# Se estiver no chão, mudar State
	if parent.is_on_floor():
		parent.deu_air_dash = false
		# Aplica Jump Lag
		if parent.is_jump_lag:
			parent.is_jump_lag = false
			return pulo_state
		return chao_state
		
	return null # Não muda o State

func _on_coyote_timeout() -> void:
	parent.is_coyote = false

func _on_jump_lag_timeout() -> void:
	parent.is_jump_lag = false

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Fall_Start":
		%Anim.play("Fall_Loop")
