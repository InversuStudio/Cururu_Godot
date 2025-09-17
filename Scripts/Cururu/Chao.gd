extends State

@export_group("Próximos States")
## State de pulo
@export var pulo_state : State = null
## State de queda
@export var fall_state : State = null
## State de dash
@export var dash_state : State = null
## State de ataque melee
@export var melee_state: State = null
## State de ataque magico
@export var special_state: State = null

var pode_anim: bool = false

# INICIA O STATE
func Enter() -> void:
	print("CHAO")
	Console._State(name)
	%Coyote.stop()
	if parent.state_machine.last_state.name == "Fall":
		%Anim.play("Land")
	else: pode_anim = true

func Exit() -> void:
	pode_anim = false

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
	return null # Não muda o State

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(delta: float) -> State:
	# Aplica gravidade bem fraca
	parent.velocity.y += 128 * delta
	# Aplica movimento
	var dir = parent.input_move * parent.speed
	if dir != 0.0:
		parent.velocity.x = move_toward(parent.velocity.x, dir, parent.accel * delta)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, dir, parent.decel * delta)
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
		if pode_anim:
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

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Land":
		pode_anim = true
