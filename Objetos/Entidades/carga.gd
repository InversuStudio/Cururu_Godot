extends State

@export var chao_state:State = null
var pode_carga:bool = true
var timer:Timer = null

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", func() -> void:
		pode_carga = true)

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	parent.input_move.x = 0.0
	%Anim.play("Carga")
	
# COMPORTAMENTO AO SAIR DO STATE
func Exit() -> void:
	pass
	
# COMPORTAMENTO PROCESS, RETORNA UM STATE
func Update(_delta : float) -> State:
	if Input.is_action_just_released("charge") or (GameData.miasma <= 0
	or GameData.magia_atual == GameData.magia_max):
		return chao_state
	
	if pode_carga:
		pode_carga = false
		GameData.miasma -= 1
		GameData.magia_atual += 1
		timer.start(.5)
		
	return null
