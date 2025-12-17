extends State

@export_group("Próximos States")
## State de pulo
@export var pulo_state : State = null
## State de queda
@export var fall_state : State = null
## State de dash
@export var dash_state : State = null
## State de ataque melee
@export var melee_state: State = null
## State de ataque magico
@export var special_state: State = null

var pode_anim: bool = false
var turn:bool = false
#variavel temporária para MVP vvv
var pode_emitir_vfx: bool = true

@onready var last_dir:int = -1 if GameData.direcao else 1

func _ready() -> void:
	await get_tree().current_scene.ready
	parent.connect("virou", func():
		if get_parent().current_state == self:#pode_anim:
			%Anim.play("Turn")
			turn = true
		#if get_parent().current_state == self:
			Flip())
	%RunVFXCooldown.connect("timeout", SpawnFolhas)

# INICIA O STATE
func Enter() -> void:
	print("CHAO")
	Console._State(name)
	%Coyote.stop()
	if parent.state_machine.last_state.name == "Fall":
		%Anim.play("Land")
		if parent.detalhe_chao[0]: SpawnFolhas()
	else: pode_anim = true
	
	if GameData.veio_de_baixo:
		GameData.veio_de_baixo = false
	var flip:float = -1.0 if parent.sprite.flip_h else 1.0
	if parent.input_move.x and flip != parent.input_buffer[1]:
		%Anim.play("Turn")
		turn = true
		Flip()

func Exit() -> void:
	%RunVFXCooldown.stop()
	turn = false
	pode_anim = false

func SpawnFolhas() -> void:
	if pode_emitir_vfx:
		var folha:PackedScene = preload("res://Objetos/Funcionalidade/VFX_FOLHA.tscn")
		var folhas:Node2D = folha.instantiate()
		parent.add_child(folhas)
		folhas.global_position = parent.global_position

func Update(_delta: float) -> State:
	# INPUT MELEE
	if Input.is_action_just_pressed("melee"):
		return melee_state
	# INPUT MAGIA
	if Input.is_action_just_pressed("magia") and GameData.upgrade_num >= 1:
		if GameData.magia_atual >= 3:
			return special_state
		parent.state_machine.find_child("Special").TocaErro()
	# INPUT DASH
	if Input.is_action_just_pressed("dash") and parent.pode_dash:
		return dash_state
	# Ao pressionar input de Pulo, mudar State
	if Input.is_action_just_pressed("pulo") and parent.pode_mover:
		return pulo_state
	return null # Não muda o State
	
# COMPORTAMENTO PHYSICS_PROCESS
func FixedUpdate(delta: float) -> State:
	# Aplica gravidade bem fraca
	parent.velocity.y += 128 * delta
		
	# Aplica movimento
	if parent.pode_mover:# and !turn:
		var dir:float = parent.input_move.x
		if dir != 0.0:
			parent.velocity.x += parent.accel * dir * delta
			if abs(parent.velocity.x) > parent.speed:
				parent.velocity.x = parent.speed * dir
		else:
			parent.velocity.x = move_toward(parent.velocity.x, dir, parent.decel * delta)
	
	if pode_anim and !turn:
		if parent.input_move.x:
			%Anim.play("Run")
			if %RunVFXCooldown.is_stopped():
				%RunVFXCooldown.start()
				#SpawnFolhas()
		else:
			%Anim.play("Idle")
			%RunVFXCooldown.stop()
		
	# Se não estiver no chão, mudar State
	if not parent.is_on_floor():
		parent.is_coyote = true
		%Coyote.start()
		return fall_state
		
	return null # Não muda o State

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Land":
		print("Pode Anim")
		pode_anim = true
	if anim_name == "Turn":
		print("Turn acabou")
		turn = false
		pode_anim = true

func Flip() -> void:
	if parent.input_move.x > 0:
		%Cururu.flip_h = false
		parent.hitbox_container.scale.x = 1
	elif parent.input_move.x < 0:
		%Cururu.flip_h = true
		parent.hitbox_container.scale.x = -1
