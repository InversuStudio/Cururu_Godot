extends State

@export var chao_state: State = null
@export var fall_state: State = null
@export var nado_state: State = null

@export var sfx:AudioStream = null
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
	if !parent.is_on_floor() and parent.input_move.y:
		if parent.input_move.y > 0:
			%Anim.play("Melee_Up", -1, GameData.ataque_anim_speed)
		else:
			%Anim.play("Melee_Down", -1, GameData.ataque_anim_speed)
	else:
		%Anim.play(combo_anim[combo_num], -1, GameData.ataque_anim_speed)
		var next_combo = combo_num + 1
		combo_num = next_combo if next_combo <= combo_limit else 0
	%SFX_Ataque.stream = sfx
	%SFX_Ataque.play()
	OffsetSprite()

func Exit() -> void:
	parent.sprite.offset.y = 0
	terminou = false

func Update(_delta:float) -> State:
	if terminou == true:
		if parent.is_on_floor():
			return chao_state
		if !parent.is_on_floor():
			return fall_state
	return null

func FixedUpdate(delta:float) -> State:
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

func Hit(_pos_target:Vector2, hit:HitBox) -> void:
	#hit.CalcPushback(distancia_push, tempo_push, pos_target)
	if !hit.is_in_group("Special"):
		GameData.magia_atual += 1

func OffsetSprite() -> void:
	parent.sprite.offset.y = 28.0
	if parent.sprite.flip_h:
		parent.sprite.offset.x = -235.0
	else: parent.sprite.offset.x = 235.0
