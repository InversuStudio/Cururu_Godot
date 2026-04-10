extends State

@export var chao_state:State = null
var pode_carga:bool = true
var timer:Timer = null
var fx_atual: Node2D = null

const vfx: PackedScene = preload("res://Objetos/Funcionalidade/VFX_recarga_magica.tscn")

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", func() -> void:
		pode_carga = true)

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	parent.input_move.x = 0.0
	parent.velocity.x = 0.0
	%Anim.play("Carga")
	# Spawna VFX ao entrar na carga
	fx_atual = vfx.instantiate()
	parent.add_child(fx_atual)
	fx_atual.global_position = parent.global_position
	fx_atual.get_child(0).play("default")

func Exit() -> void:
	if fx_atual:
		fx_atual.queue_free()
		fx_atual = null
	
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
