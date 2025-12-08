class_name StateMachine
extends Node

## State inicial
@export var start_state: State = null
# State atual
var current_state: State = null
var last_state: State = null

func _ready() -> void:
	# Inicia variável parent de todos os States
	for c in get_children():
		if c is State: c.parent = get_parent()
	
	current_state = start_state # Inicia current_state

# COMPORTAMENTO AO ENTRAR UM STATE
func Enter() -> void:
	pass
# COMPORTAMENTO AO SAIR UM STATE
func Exit() -> void:
	pass

# # COMPORTAMENTO PROCESS
func Update(delta: float) -> void:
	# Executa função _process() do State, armazena resultado
	var new_state = current_state.Update(delta)
	# Se resultado não for nulo, será o novo State
	if new_state:
		MudaState(new_state)

# # COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(delta: float) -> void:
	# Executa função _physics_process() do State, armazena resultado
	var new_state = current_state.FixedUpdate(delta)
	# Se resultado não for nulo, será o novo State
	if new_state:
		MudaState(new_state)

# FUNÇÃO DE MUDAR STATE
func MudaState(new_state: State) -> void:
	current_state.Exit() # Executa saída do State
	last_state = current_state
	current_state = new_state # Muda o State
	current_state.Enter() # Executa entrada do State
