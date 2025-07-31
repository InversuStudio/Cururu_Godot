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
	# Reseta dash, pois tocou no chão
	parent.pode_dash = true

func Update(_delta: float) -> State:
	# INPUT MELEE
	if Input.is_action_just_pressed("melee") and not atacando:
		atacando = true # Define que está atacando
		%MeleeTime.stop() # Reseta timer para mudar de combo
		
		# Toca animação em ordem, loopando lista
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

# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(_delta: float) -> State:
	# Aplica movimento
	parent.velocity.x = parent.input_move * parent.speed
	
	# Espelha o sprite de acordo com o input
	if parent.input_move > 0:
		%Cururu.flip_h = false
		parent.hitbox_container.scale.x = 1
	elif parent.input_move < 0:
		%Cururu.flip_h = true
		parent.hitbox_container.scale.x = -1
	
	if parent.is_on_floor() and atacando == false:
		# Controla animações de parado e correndo
		if parent.input_move: %Anim.play("Run")
		else: %Anim.play("Idle")
		
		# Ao pressionar input de Pulo, mudar State
		if Input.is_action_just_pressed("pulo"):
			return pulo_state
			
	# Se não estiver no chão, mudar State
	if not parent.is_on_floor() and not atacando:
		parent.is_coyote = true
		%Coyote.start()
		return fall_state
		
	return null # Não muda o State

# Função para resetar variável "atacando" e iniciar timer de ataque,
# chamada no AnimationPlayer
func Reset_Ataque() -> void:
	atacando = false
	%MeleeTime.start()

# Reseta combo, caso demore muito para atacar
func _on_melee_time_timeout() -> void:
	combo_num = 0

# Habilita dash após cooldown
func _on_dash_cooldown_timeout() -> void:
	if parent.is_on_floor(): parent.pode_dash = true
