class_name Player extends CharacterBody2D

@export_group("Movimento")
## Velocidade de movimento terrestre, em m/s
@export var vel_corre: float = 0.0
## Velocidade reduzida de movimento terrestre, em m/s
@export var vel_anda:float = 0.0
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
## Velocidade máxima de queda, em m/s
@export var velocidade_queda_max:float = 1.0

@export_group("Dash")
## Tempo de duração do dash, em segundos
@export var tempo_dash: float = 0.0
## Distância percorrida pelo dash, em metros
@export var distancia_dash: float = 0.0
## Tempo de recarga do dash
@export var cooldown_dash: float = 0.0

@export_group("Combate")
## Pontos de magia totais
@export var magia_max: int = 10

# Velocidade terrestre convertida -> 170 = tamanho tile
@onready var speed_run: float = vel_corre  * 128
@onready var speed_walk: float = vel_anda * 128
@onready var speed:float = speed_run
# Velocidade aérea
@onready var air_speed: float = vel_aerea * 128
# Aceleração
@onready var accel: float = speed_run / acel_time
# Desaceleração
@onready var decel: float = speed_run / decel_time
# Velocidade do dash
@onready var dash_speed: float = (distancia_dash / tempo_dash) * 128
# Velocidade do pulo
@onready var jump_force: float = ((2.0 * altura_pulo) / tempo_pulo) * 128
# Gravidade do pulo
@onready var jump_gravity: float = ((2.0 * altura_pulo) / pow(tempo_pulo, 2)) * 128
# Gravidade da queda
@onready var fall_gravity: float = ((2.0 * altura_pulo) / pow(tempo_cair, 2)) * 128
# Velocidade máxima de queda
@onready var max_fall_vel: float = velocidade_queda_max * 128

@export_group("Componentes")
## Componente Vida
@export var vida : Vida = null
## Componente StateMachine
@export var state_machine : StateMachine = null
## Seta vida específica. 0 não faz nada
@export var override_vida_player:int = 0
## Seta magia específica. -1 não faz nada
@export var override_magia:int = -1
# Node que segura os Marker2Ds que definem onde os ataques serão instanciados
@onready var pos_ataques: Node2D = $PosAtaques

# Variáveis controladoras
var is_coyote: bool = false
var is_jump_lag: bool = false
var deu_air_dash: bool = false
var input_move: Vector2 = Vector2.ZERO
var pode_mover: bool = true
var pode_ataque:bool = true
var pode_dash: bool = true
var pode_wall:bool = true
var pode_item:bool = true

@onready var check_agua_up: RayCast2D = $CheckAguaUp
@onready var check_agua_down: RayCast2D = $CheckAguaDown
@onready var check_chao: RayCast2D = $CheckChao
@onready var sprite: AnimatedSprite2D = %Cururu
@onready var anim: AnimationPlayer = %Anim

var detalhe_chao:Array = [false, ""]

signal virou
var input_buffer:Array[float] = [0.0, 0.0]

func _ready() -> void:
	# Registra referência global
	Mundos.player = self
	if LoadCena.usa_pos:
		print("MUDEI DE POS")
		global_position = LoadCena.next_pos
		sprite.flip_h = GameData.direcao
	
	#Deixa VFX invisível
	%VFX.hide()
	
	if GameData.game_start == false:
		pode_mover = false
		GameData.game_start = true
		state_machine.MudaState(state_machine.find_child("Acorda"))

		if override_vida_player > 0:
			vida.vida_atual = override_vida_player
			await get_tree().scene_changed
			GameData.vida_atual = override_vida_player
		if override_magia > -1:
			#vida.vida_atual = override_vida_player
			#await get_tree().scene_changed
			print("PINTO BOLAS!!!!!!!!!!!!!!!!!!!!")
			GameData.magia_atual = override_magia
	HUD.AplicaRed(vida.vida_atual)

	var ib:Array = [-1.0, -1.0] if GameData.direcao else [1.0, 1.0]
	input_buffer.assign(ib)
	
	pos_ataques.scale.x = -1 if GameData.direcao else 1
	
	# Conecta sinal de dano
	vida.connect("alterou_vida", VidaMudou)
	
	# Seta Magia
	GameData.magia_max = int(magia_max)
	if GameData.magia_atual > 0 and GameData.magia_atual < 1:
		GameData.magia_atual = magia_max
	if GameData.veio_de_baixo:
		state_machine.MudaState(state_machine.find_child("Pulo"))
		await get_tree().create_timer(1.0).timeout
		GameData.veio_de_baixo = false

func _process(delta: float) -> void:
	# Controla se pode mover
	if !pode_mover: return
	# Recebe input
	input_move.x = Input.get_axis("esquerda", "direita")
	input_move.y = Input.get_axis("cima", "baixo")
	# Armazena último input
	if input_move.x and input_move.x != input_buffer[1]:
		input_buffer[0] = sign(input_buffer[1])
		input_buffer[1] = sign(input_move.x)
		if input_buffer[0] != input_buffer[1]:
			virou.emit()
	var col:Object = check_chao.get_collider()
	if col:
		var grupo:String = ""
		if col.get_groups() != []:
			grupo = col.get_groups()[0]
		detalhe_chao = [true, grupo]
	else:
		detalhe_chao = [false, ""]
		
	# Aplica PROCESS do StateMachine
	state_machine.Update(delta)
	
	if abs(input_move.y) > .7 and state_machine.current_state.name == "Chao":
		if input_move.y > 0:
			Mundos.main_camera.comando -= delta
		else:
			Mundos.main_camera.comando += delta
	else:
		Mundos.main_camera.comando = 0.0

func _physics_process(delta: float) -> void:
	# Aplica PHYSICS_PROCESS do StateMachine
	state_machine.FixedUpdate(delta)
	velocity.y = clampf(velocity.y, -jump_force, max_fall_vel)
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
		pode_mover = false
		%StateMachine.call_deferred("MudaState", %StateMachine.find_child("Dano"))
	else:
		print("RECEBI CURA")
	HUD.AplicaRed(vida_nova)

func PlayExtra(som:AudioStream) -> void:
	%SFX_Extra.stream = som
	%SFX_Extra.play()

# COMPORTAMENTO AO MORRER
func Morte() -> void:
	print("MORRI")
	GameData.game_start = false
	if GameData.Load() == false:
		Mundos.lista_inimigos = []
		Mundos.lista_baus = []
		GameData.player_morreu = true
		LoadCena.Load("res://Cenas/aTutorial/Tutorial_1.tscn")
