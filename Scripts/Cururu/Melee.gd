extends State

@export var chao_state: State = null
@export var fall_state: State = null
@export var nado_state: State = null

@export var sfx:Array[AudioStream] = []
@export var hitboxes:Array[HitBox] = []

@export_group("Pushback")
@export var distancia_push:float = 1.0
@export var tempo_push:float = .2

# Armazena número do ataque
var combo_num: int = 0
# Lista de animações
var combo_anim: Array[String] = [
	"Melee1", "Melee2"
]
@onready var combo_limit: int = combo_anim.size() - 1
var terminou: bool = false

const vfx:PackedScene = preload("res://Objetos/Funcionalidade/VFX_Melee.tscn")
var vfx_atual:Node2D = null

func _ready() -> void:
	await get_tree().process_frame
	for c:HitBox in hitboxes:
		c.connect("hit", Hit.bind(c))

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	print("MELEE")
	Console._State(name)
	%MeleeTime.stop() # Reseta timer para mudar de combo
	
	# Toca animação em ordem, loopando lista
	#if !parent.is_on_floor() and parent.input_move.y:
		#if parent.input_move.y > 0:
			#%Anim.play("Melee_Up", -1, GameData.ataque_anim_speed)
		#else:
			#%Anim.play("Melee_Down", -1, GameData.ataque_anim_speed)
	#else:
	var state:String = "Chao" if parent.is_on_floor() else "Ar"
	%Anim.play(combo_anim[combo_num] + state, -1, GameData.ataque_anim_speed)
	var next_combo = combo_num + 1
	var fx:Node2D = vfx.instantiate()
	parent.get_parent().add_child(fx)
	vfx_atual = fx
	fx.global_position = parent.global_position
	var c:AnimatedSprite2D = fx.get_child(0)
	fx.scale.x = -1 if parent.sprite.flip_h else 1
	c.play(str(next_combo))
	combo_num = next_combo if next_combo <= combo_limit else 0
	
	%SFX_Ataque.stream = sfx[combo_num]
	%SFX_Ataque.play()
	
	await c.animation_finished
	fx.queue_free()

func Exit() -> void:
	terminou = false

func Update(_delta:float) -> State:
	if terminou == true:
		if parent.is_on_floor():
			return chao_state
		if !parent.is_on_floor():
			return fall_state
	return null

func FixedUpdate(delta:float) -> State:
	if vfx_atual: vfx_atual.global_position = parent.global_position
	
	# Gravidade
	if !parent.is_on_floor():
		if parent.velocity.y >= 0:
			parent.velocity.y += parent.fall_gravity * delta
		else:
			parent.velocity.y += parent.jump_gravity * delta
	
	if parent.check_agua_down.is_colliding():
		return nado_state
	
	# Solução lógica pulo curto
	if Input.is_action_just_released("pulo"):
		parent.velocity.y /= 2.0
		#parent.velocity.y = 0.0
	
	# Movimentação
	var dir = parent.input_move.x
	if dir != 0.0:
		parent.velocity.x += parent.accel * dir * delta
		var target_speed:float = parent.speed if parent.is_on_floor(
			) else parent.air_speed
		if abs(parent.velocity.x) > target_speed:
			parent.velocity.x = target_speed * dir
	else:
		parent.velocity.x = move_toward(parent.velocity.x, dir, parent.decel * delta)
	
	return null

# Inicia timer para resetar combo, dentro do AnimationPlayer
func Reset_Ataque() -> void:
	terminou = true
	%MeleeTime.start()

# Reseta combo após certo tempo inativo
func _on_melee_timeout() -> void:
	combo_num = 0

func Hit(pos_target:Vector2, hit:HitBox) -> void:
	hit.CalcPushback(distancia_push, tempo_push, pos_target)
	if !hit.is_in_group("Special"):
		GameData.magia_atual += 1
