extends State

@export var chao_state: State = null
@export var fall_state: State = null
@export var nado_state: State = null

@export var hitboxes:Array[HitBox] = []

@export var sfx_sem_magia: Array[AudioStream] = []

@export_group("Pushback")
@export var distancia_push:float = 1.0
@export var tempo_push:float = .2

var terminou: bool = false

const sfx:AudioStream = preload("res://Audio/SFX/CURURU/Ataque secundário.wav")

const vfx:PackedScene = preload("res://Objetos/Funcionalidade/VFX_Chicote.tscn")
var vfx_atual:Node2D = null

func _ready() -> void:
	for c:HitBox in hitboxes:
		c.connect("hit", Hit.bind(c))

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	print("MAGIA")
	Console._State(name)
	GameData.magia_atual -= 3
	
	# Toca animação, de acordo com input direcional
	#if !parent.is_on_floor() and Input.is_action_pressed("baixo"):
		#%Anim.play("Special_Down")
	#elif Input.is_action_pressed("cima"):
		#%Anim.play("Special_Up")
	#else:
	%Anim.play("Special")
	var fx:Node2D = vfx.instantiate()
	parent.get_parent().add_child(fx)
	vfx_atual = fx
	fx.global_position = parent.global_position
	var c:AnimatedSprite2D = fx.get_child(0)
	fx.scale.x = -1 if parent.sprite.flip_h else 1
	c.play("ataque")
	%SFX_Ataque.stream = sfx
	%SFX_Ataque.play()
	
	await c.animation_finished
	fx.queue_free()
	

func Exit() -> void:
	terminou = false

func FixedUpdate(delta:float) -> State:
	if vfx_atual: vfx_atual.global_position = parent.global_position
	
	if Input.is_action_just_released("pulo"):
		parent.velocity.y /= 2.0

	if parent.check_agua_down.is_colliding():
		return nado_state
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, parent.decel * delta)
	if parent.velocity.y >= 0:
		parent.velocity.y += parent.fall_gravity * delta
	else:
		parent.velocity.y += parent.jump_gravity * delta
	
	if terminou == true:
		if parent.is_on_floor():
			return chao_state
		if !parent.is_on_floor():
			return fall_state
	
	return null

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "Special" or anim_name == "Special_Up"
		or anim_name == "Special_Down"):
		terminou = true

func Hit(_pos_target:Vector2, hit:HitBox) -> void:
	#hit.CalcPushback(distancia_push, tempo_push, pos_target)
	if !hit.is_in_group("Special"):
		GameData.magia_atual += 1

func TocaErro() -> void:
	if sfx_sem_magia.size() == 0: return
	var n:int = randi_range(0, sfx_sem_magia.size() - 1)
	%SFX_Extra.stream = sfx_sem_magia[n]
	%SFX_Extra.play()
