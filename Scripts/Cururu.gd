extends CharacterBody2D

@export_group("Movimento")
## Velocidade de movimento terrestre, em m/s
@export var vel: float = 0.0
## Velocidade de movimento aéreo, em m/s
@export var vel_aerea: float = 0.0

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
@onready var speed: float = vel  * 128
# Velocidade aérea
@onready var air_speed: float = vel_aerea * 128
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
var deu_air_dash: bool = false

@onready var hitbox_container: Node2D = $HitBoxes

var input_move: float = 0.0

@onready var sprite: AnimatedSprite2D = %Cururu

func _ready() -> void:
	%Coyote.wait_time = tempo_coyote
	%JumpLag.wait_time = lag_pulo
	%DashTime.wait_time = tempo_dash
	%DashCooldown.wait_time = cooldown_dash
	%Cururu.flip_h = GameData.direcao

func _process(delta: float) -> void:
	# Recebe input
	input_move = Input.get_axis("esquerda", "direita")
	# Aplica PROCESS do StateMachine
	state_machine.Update(delta)
	if Input.is_physical_key_pressed(KEY_ENTER):
		var dano = Ataque.new()
		dano.dano = vida.vida_max
		vida.recebe_dano(dano)

func _physics_process(delta: float) -> void:
	# Aplica PHYSICS_PROCESS do StateMachine
	state_machine.FixedUpdate(delta)
	move_and_slide()

# Habilita dash após cooldown
func _on_dash_cooldown_timeout() -> void:
	pode_dash = true

# COMPORTAMENTO AO MORRER
func morte() -> void:
	print("MORRI")
	if GameData.Load() == false:
		#Mundos.Reload()
		Mundos.CarregaFase(GameData.fase)
		GameData.moedas = 0
