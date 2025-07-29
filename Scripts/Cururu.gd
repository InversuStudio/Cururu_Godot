extends CharacterBody2D

@export_group("Movimento")
## Velocidade de movimento terrestre, em m/s
@export var velocidade: float = 0.0

@export_group("Pulo")
## Altura do pulo, em metros
@export var altura_pulo: float = 0.0
## Tempo até altura máxima do pulo, em segundos
@export var tempo_pulo: float = 0.0
## Tempo até alcançar chão após pulo, em segundos
@export var tempo_cair: float = 0.0
## Tempo de efeito to coyote time
@export var tempo_coyote: float = 0.0
## Espaço de tempo para aceitar input de pulo antes de chegar ao chão
@export var lag_pulo: float = 0.0

@export_group("Dash")
## Tempo de duração do dash, em segundos
@export var tempo_dash: float = 0.0
## Distância percorrida pelo dash, em metros
@export var distancia_dash: float = 0.0
## Tempo de recarga do dash
@export var cooldown_dash: float = 0.0

# Velocidade terrestre convertida -> 170 = tamanho tile
@onready var speed: float = velocidade  * 128
# Velocidade do dash
@onready var dash_speed: float = (distancia_dash / tempo_dash) * 128
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

var is_coyote: bool = false
var is_jump_lag: bool = false
var pode_dash: bool = true

@onready var hitbox_container: Node2D = $HitBoxes

func _ready() -> void:
	%Coyote.wait_time = tempo_coyote
	%JumpLag.wait_time = lag_pulo
	%DashTime.wait_time = tempo_dash
	%DashCooldown.wait_time = cooldown_dash

func _physics_process(delta: float) -> void:
	# Aplica PHYSICS_PROCESS do StateMachine
	state_machine.FixedUpdate(delta)
	move_and_slide()

func _on_dash_cooldown_timeout() -> void:
	print("Pode dar dash")
	pode_dash = true
