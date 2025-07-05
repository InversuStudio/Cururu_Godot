extends CharacterBody2D

@export_group("Movimento")
## Velocidade de movimento terrestre, em m/s
@export var velocidade: float = 0
## Multiplicador da velocidade aérea
@export var velocidade_ar: float = 0.0
## Altura do pulo, em metros
@export var altura_pulo: float = 0.0
## Tempo até altura máxima do pulo, em segundos
@export var tempo_pulo: float = 0.0
## Tempo até alcançar chão após pulo, em segundos
@export var tempo_cair: float = 0.0
## Tempo de efeito to coyote time
@export var tempo_coyote: float = 0.0

# Velocidade terrestre convertida -> 170 = tamanho tile
@onready var speed: float = velocidade  * 128
# Velocidade de movimento aéreo, em m/s
@onready var air_speed: float = velocidade_ar * 128
# Velocidade do pulo
@onready var jump_force: float = ((2.0 * altura_pulo) / tempo_pulo) * 128
# Gravidade do pulo
@onready var jump_gravity: float = ((2.0 * altura_pulo) / pow(tempo_pulo, 2)) * 128
# Gravidade da queda
@onready var fall_gravity: float = ((2.0 * altura_pulo) / pow(tempo_cair, 2)) * 128

@export_group("Componentes")
## Componente Vida
@export var vida : Vida
## Componente StateMachine
@export var state_machine : StateMachine

@onready var anim: AnimationPlayer = $Anim # Animação
@onready var coyote: Timer = $Coyote
var is_coyote: bool = false

var input_move : float = 0.0 # Input de movimento

func _ready() -> void:
	coyote.wait_time = tempo_coyote

func _physics_process(delta: float) -> void:
	# Recebe input de movimento
	input_move = Input.get_axis("esquerda","direita")
	
	if input_move: # Se o input for diferente de 0
		# Espelha o sprite de acordo com o input
		%Cururu.flip_h = true if input_move < 0 else false
	
	# Aplica PHYSICS_PROCESS do StateMachine
	state_machine.FixedUpdate(delta)
	
	move_and_slide()
