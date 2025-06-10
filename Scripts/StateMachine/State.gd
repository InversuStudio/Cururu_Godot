class_name State
extends Node

var parent : Node # Node com script principal

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	pass
# COMPORTAMENTO AO SAIR DO STATE
func Exit() -> void:
	pass
# COMPORTAMENTO PROCESS, RETORNA UM STATE
func Update(_delta : float) -> State:
	return null
# COMPORTAMENTO PHYSICS_PROCESS, RETORNA UM STATE
func FixedUpdate(_delta : float) -> State:
	return null
