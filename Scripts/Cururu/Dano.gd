extends State

@export var fall_state: State = null
@export var chao_state: State = null

var acabou: bool = false
var counter: float
var target_dir:Vector2

func Enter() -> void:
	Console._Print(Vector2(1,-1) > Vector2(1,0))
	print("DANO")
	Console._State(name)
	%Anim.play("Dano")
	acabou = false

func Exit() -> void:
	print("DANO ACABOU")

func FixedUpdate(delta:float) -> State:
	parent.velocity.x -= counter * target_dir.x * delta
	if sign(parent.velocity.x) != sign(target_dir.x):
		parent.velocity.x = 0.0
	if sign(parent.velocity.y) != sign(target_dir.y):
		parent.velocity.y += parent.fall_gravity * delta
	else: 
		parent.velocity.y -= counter * target_dir.y * delta
	
	# Se tempo de stun já acabou
	if acabou:
		# Muda de State
		if parent.is_on_floor():
			return chao_state
		return fall_state
	return null

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Dano":
		acabou = true

func _on_hurt_box_counter(knock:float, dir:Vector2) -> void:
	counter = knock
	target_dir = dir
