extends State

@export_group("Próximos States")
## State de pulo
@export var pulo_state : State = null
## State de queda
@export var fall_state : State = null
# Armazena se está atacando 
var atacando : bool = false
# Armazena número do ataque
var combo_num : int = 0

# INICIA O STATE
func Enter() -> void:
	print("CHAO")

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(_delta: float) -> State:
	# Recebe input de movimento, aplica movimento
	parent.input_move = Input.get_axis("esquerda","direita")
	parent.velocity.x = parent.input_move * parent.speed
	
	if parent.is_on_floor() and atacando == false:
		# Controla animações de parado e correndo
		if parent.input_move: parent.anim.play("Run")
		else: parent.anim.play("Idle")
		# Ao pressionar input de Pulo, mudar State
		if Input.is_action_just_pressed("pulo"):
			return pulo_state
	# Se não estiver no chão, mudar State
	if not parent.is_on_floor():
		print("AIAIAII")
		parent.is_coyote = true
		parent.coyote.start()
		return fall_state
	# INPUT MELEE
	if Input.is_action_just_pressed("melee"):
		atacando = true
		# Define animação pelo número do ataque
		match combo_num:
			0:
				combo_num += 1
				%Anim.play("Melee1")
			1:
				combo_num = 0
				%Anim.play("Melee2")
	# INPUT MAGIA
	if Input.is_action_just_pressed("magia"):
		pass # nãoseioquenãoseiquelá
	
	return null # Não muda o State

# Função para resetar variável "atacando",
# chamada no AnimationPlayer
func Reset_Ataque() -> void:
	atacando = false
