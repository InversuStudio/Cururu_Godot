extends State

@export var jump_state:State = null
@export var fall_state:State = null
@export var chao_state:State = null
#@export var hurt_state:State = null
@export var velocidade_cair:float = 1.0
@export var impulso_horizontal_pulo:float = 1.0
@export var reducao_pulo:float = 1.0

var oposto:int = 0
var espera:bool = false
var sair:bool = false

func _ready() -> void:
	velocidade_cair *= 128.0
	impulso_horizontal_pulo *= 128
	reducao_pulo *= 128

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	%Anim.play("Wall")
	Console._State(name)
	oposto = -sign(parent.input_move.x)
	parent.velocity.y = 0.0
	parent.pode_wall = false
	parent.deu_air_dash = false
	
# COMPORTAMENTO AO SAIR DO STATE
func Exit() -> void:
	sair = false
	espera = false
	parent.input_move.x = oposto
	await get_tree().create_timer(.2).timeout
	parent.pode_wall = true
# COMPORTAMENTO PROCESS, RETORNA UM STATE
func Update(_delta : float) -> State:
	if sign(parent.input_move.x) == oposto:
		Espera()
	if sair:
		return fall_state
	
	if Input.is_action_just_pressed("pulo"):
		parent.velocity.x = impulso_horizontal_pulo * oposto
		return jump_state
	
	return null
# COMPORTAMENTO PHYSICS_PROCESS, RETORNA UM STATE
func FixedUpdate(_delta : float) -> State:
	var dir:int = sign(parent.input_move.x)
	if dir and dir != oposto:
		parent.velocity.y = 0.0
	else:
		parent.velocity.y = velocidade_cair
	
	if !parent.is_on_wall():
		return fall_state
	if parent.is_on_floor():
		return chao_state
	return null

func Espera() -> void:
	await get_tree().create_timer(.1).timeout
	if get_parent().current_state == self:
		sair = true
