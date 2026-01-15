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
var item_cura:bool = false
var checa_tempo:bool = false
var tempo_ultimo_passo: float = 0.0

func _ready() -> void:
	HUD.usa_item_rapido.connect(func():
		item_cura = true
		)
	await get_tree().current_scene.ready
	%RunVFXCooldown.connect("timeout", SpawnFolhasRun)
	parent.connect("virou", func():
		if get_parent().current_state == self and !item_cura:#pode_anim:
			%Anim.play("Turn")
			turn = true
		#if get_parent().current_state == self:
			Flip())

# INICIA O STATE
func Enter() -> void:
	print("CHAO")
	Console._State(name)
	%Coyote.stop()
	if parent.state_machine.last_state.name == "Fall":
		%Anim.play("Land")
		if parent.detalhe_chao[0]: SpawnFolhasFall()
	else: pode_anim = true
	
	if GameData.veio_de_baixo:
		GameData.veio_de_baixo = false
	var flip:float = -1.0 if parent.sprite.flip_h else 1.0
	if parent.input_move.x and flip != parent.input_buffer[1] and !item_cura:
		%Anim.play("Turn")
		turn = true
		Flip()

func Exit() -> void:
	
#esse %RunVFXCooldown.stop() tá causando o efeito do VFX quando o personagem para de se mover. dá pra ver se vc estiver andando da direita pra esquerda /
#não consegui pensar numa maneira de resolver isso sem separar o state de 'CHAO' em IDLE e RUNNING separadamente. 
#acho que manter tudo jutno pode dar mais problema daqui pra frente tbm
	%RunVFXCooldown.stop()
	turn = false
	pode_anim = false

#AJUSTE TEMPORÁRIO PARA MÚLTIPLOS EFEITOS // QUERIA USAR A MESMA FUNÇÃO E PASSAR UMA STRING DO TIPO DE ANIM QUANDO CHAMAR A FUNÇÃO MAS,
#NÃO CONSEGUI ISSO FAZER FUNCIONAR COM O %RunVFXCooldown.connect("timeout", SpawnFolhasRun)

func SpawnFolhasFall() -> void:
	if pode_emitir_vfx:
		var folha:PackedScene = preload("res://Objetos/Funcionalidade/VFX_FOLHA_FALL.tscn")
		var folhas:Node2D = folha.instantiate()
		parent.add_child(folhas)
		folhas.global_position = parent.global_position
		%SFX_Caindo_Chao.play()
		
func SpawnFolhasRun() -> void:
	if pode_emitir_vfx:
		var folha:PackedScene = preload("res://Objetos/Funcionalidade/VFX_FOLHA_RUN.tscn")
		var folhas:Node2D = folha.instantiate()
		parent.add_child(folhas)
		folhas.global_position = parent.global_position
		if parent.sprite.flip_h : folhas.set_flip(true) 
		else : folhas.set_flip(false)

func Update(_delta: float) -> State:
	# INPUT MELEE
	if Input.is_action_just_pressed("melee") and parent.pode_ataque:
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
		var pos_anim:float = parent.anim.current_animation_position if checa_tempo else 0.0
		if parent.input_move.x:
			if item_cura:
				parent.speed = parent.speed_walk
				parent.anim.play("Cura_Move")
				parent.anim.seek(pos_anim)
				Flip()
			else:
				parent.speed = parent.speed_run
				parent.anim.play("Run")
			if %RunVFXCooldown.is_stopped():
				%RunVFXCooldown.start()
		else:
			if item_cura:
				parent.speed = parent.speed_walk
				parent.anim.play("Cura_Parado")
				parent.anim.seek(pos_anim)
				Flip()
			else:
				parent.speed = parent.speed_run
				parent.anim.play("Idle")
			%RunVFXCooldown.stop()
	
		checa_tempo = true if item_cura else false
	
	# Se não estiver no chão, mudar State
	if not parent.is_on_floor():
		parent.is_coyote = true
		%Coyote.start()
		return fall_state
		
	return null # Não muda o State

func _on_anim_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Land":
			print("Pode Anim")
			pode_anim = true
		"Turn":
			print("Turn acabou")
			turn = false
			pode_anim = true
		"Cura_Parado":
			item_cura = false
		"Cura_Move":
			item_cura = false
		

func Flip() -> void:
	if parent.input_move.x > 0:
		%Cururu.flip_h = false
		parent.hitbox_container.scale.x = 1
	elif parent.input_move.x < 0:
		%Cururu.flip_h = true
		parent.hitbox_container.scale.x = -1
