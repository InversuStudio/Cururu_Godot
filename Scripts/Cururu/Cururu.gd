extends CharacterBody2D

@export_group("Movimento")
## Velocidade de movimento terrestre, em m/s
@export var vel: float = 0.0
## Velocidade de movimento aéreo, em m/s
@export var vel_aerea: float = 0.0
## Tempo até atingir velocidade máxima, em segundos
@export var acel_time: float = 0.0
## Tempo até atingir inércia, em segundos
@export var decel_time: float = 0.0

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

@export_group("Combate")
## Distância do knockback, em metros
@export var distancia_knockback : float = 0.0
## Duração do knockback, em segundos
@export var tempo_knockback : float = 0.0
## Pontos de magia totais
@export var magia_max: int = 10

# Velocidade terrestre convertida -> 170 = tamanho tile
@onready var speed: float = vel  * 128
# Velocidade aérea
@onready var air_speed: float = vel_aerea * 128
# Aceleração
@onready var accel: float = speed / acel_time
# Desaceleração
@onready var decel: float = speed / decel_time
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
@export var vida : Vida = null
## Componente StateMachine
@export var state_machine : StateMachine = null
## Node container de HIT BOX
@export var hitbox_container: Node2D = null
## Node container de HURT BOX
@export var hurtbox_container: Node2D = null

var is_coyote: bool = false
var is_jump_lag: bool = false
var pode_dash: bool = true
var deu_air_dash: bool = false

@onready var sprite: AnimatedSprite2D = %Cururu

var input_move: float = 0.0
var pode_mover: bool = true

func _ready() -> void:
	# Inicia HurtBoxes
	for h:HurtBox in hurtbox_container.get_children():
		h.distancia_knockback = distancia_knockback
		h.tempo_knockback = tempo_knockback
	# Desabilita hitboxes
	for h in hitbox_container.get_children():
		if h is HitBox:
			for c in h.get_children():
				if c is CollisionShape2D: c.disabled = true
	# Configura Timers
	%Coyote.wait_time = tempo_coyote
	%JumpLag.wait_time = lag_pulo
	%DashTime.wait_time = tempo_dash
	%DashCooldown.wait_time = cooldown_dash
	%Cururu.flip_h = GameData.direcao
	# Conecta sinal de dano
	vida.connect("alterou_vida", VidaMudou)
	# Aplica flip, se necessário
	if sprite.flip_h == true:
		hitbox_container.scale.x = -1
	# Seta Magia
	GameData.magia_max = int(magia_max)
	if GameData.magia_atual > 0 and GameData.magia_atual < 1:
		GameData.magia_atual = magia_max
	if GameData.veio_de_baixo:
		%StateMachine.Muda_State(%StateMachine.find_child("Pulo"))
		GameData.veio_de_baixo = false

func _process(delta: float) -> void:
	# Controla se pode mover
	if !pode_mover: return
	# Recebe input
	input_move = Input.get_axis("esquerda", "direita")
	# Aplica PROCESS do StateMachine
	state_machine.Update(delta)
	
	# !!!!!!!!DEBUG - TIRAR DEPOIS!!!!!!!!!!!
	if Input.is_physical_key_pressed(KEY_ENTER):
		if Input.is_physical_key_pressed(KEY_SPACE):
			GameData.leu_data = false
			GameData.Load()
		else: vida.RecebeDano(vida.vida_max)

func _physics_process(delta: float) -> void:
	# Aplica PHYSICS_PROCESS do StateMachine
	state_machine.FixedUpdate(delta)
	move_and_slide()

# Habilita dash após cooldown
func _on_dash_cooldown_timeout() -> void:
	print("Cooldown acabou")
	pode_dash = true

# Função que indica dano
func VidaMudou(vida_nova, vida_antiga) -> void:
	GameData.vida_atual = vida_nova
	if vida_nova < vida_antiga:
		print("RECEBI DANO")
		%StateMachine.call_deferred("Muda_State", %StateMachine.find_child("Dano"))
	else:
		print("RECEBI CURA")
	
# COMPORTAMENTO AO MORRER
func Morte() -> void:
	print("MORRI")
	GameData.vida_atual = vida.vida_max
	GameData.magia_atual = magia_max
	if GameData.Load() == false:
		Mundos.CarregaFase(GameData.fase)
