extends State

@export_group("Próximos States")
## State de pulo
@export var pulo_state : State = null
## State de queda
@export var fall_state : State = null
## State de dash
@export var dash_state : State = null
# Armazena se está atacando 
var atacando : bool = false
# Armazena número do ataque
var combo_num: int = 0
# Lista de animações
var combo_anim: Array[String] = [
	"Melee1", "Melee2"
]
@onready var combo_limit: int = combo_anim.size() - 1
 
# INICIA O STATE
func Enter() -> void:
	print("CHAO")

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(_delta: float) -> State:
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
	
	if parent.is_on_floor() and atacando == false:
		# Controla animações de parado e correndo
		if input_move: %Anim.play("Run")
		else: %Anim.play("Idle")
		# Ao pressionar input de Pulo, mudar State
		if Input.is_action_just_pressed("pulo"):
			return pulo_state
	# Se não estiver no chão, mudar State
	if not parent.is_on_floor():
		parent.is_coyote = true
		%Coyote.start()
		return fall_state
	
	# INPUT MELEE
	if Input.is_action_just_pressed("melee") and not atacando:
		atacando = true # Define que está atacando
		%MeleeTime.stop() # Reseta timer para mudar de combo
		
		# Toca animação em ordem, loopando lista
		print(combo_num)
		%Anim.play(combo_anim[combo_num])
		var next_combo = combo_num + 1
		combo_num = next_combo if next_combo <= combo_limit else 0
		
	# INPUT MAGIA
	if Input.is_action_just_pressed("magia"):
		pass # nãoseioquenãoseiquelá
	
	# INPUT DASH
	if Input.is_action_just_pressed("dash") and parent.pode_dash:
		return dash_state
	return null # Não muda o State

# Função para resetar variável "atacando" e iniciar timer de ataque,
# chamada no AnimationPlayer
func Reset_Ataque() -> void:
	atacando = false
	%MeleeTime.start()

func _on_melee_time_timeout() -> void:
	combo_num = 0
