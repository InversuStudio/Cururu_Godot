extends State

@export var chao_state: State = null
@export var fall_state: State = null
@export var dano_state: State = null

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
	for c:Node2D in parent.hitbox_container.get_children():
		if c is HitBox:
			c.connect("hit", RecuperaMagia)

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	print("MELEE")
	Console._State(name)
	%MeleeTime.stop() # Reseta timer para mudar de combo
	# Toca animação em ordem, loopando lista
	%Anim.play(combo_anim[combo_num])
	var next_combo = combo_num + 1
	combo_num = next_combo if next_combo <= combo_limit else 0

func Exit() -> void:
	terminou = false

func Update(_delta:float) -> State:
	if terminou == true:
		if parent.is_on_floor():
			return chao_state
		if !parent.is_on_floor():
			return fall_state
		if parent.recebeu_dano:
			return dano_state
	return null

func FixedUpdate(delta:float) -> State:
	if parent.is_on_floor():
		parent.velocity.x = move_toward(parent.velocity.x, 0.0, parent.speed / 8)
	# Aplica gravidade de queda
	parent.velocity.y += parent.fall_gravity * delta
	return null

# Inicia timer para resetar combo, dentro do AnimationPlayer
func Reset_Ataque() -> void:
	terminou = true
	%MeleeTime.start()

# Reseta combo após certo tempo inativo
func _on_melee_timeout() -> void:
	combo_num = 0

func RecuperaMagia() -> void:
	print("HIT")
	GameData.magia_atual += 1
