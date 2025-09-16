extends State

@export var fall_state: State = null
@export var chao_state: State = null

var acabou: bool = false

func Enter() -> void:
	print("DANO")
	Console._State(name)
	%Anim.play("Dano")
	acabou = false

func Exit() -> void:
	print("DANO ACABOU")
	parent.recebeu_dano = false

func FixedUpdate(_delta:float) -> State:
	# Reduz velocidade com o tempo
	parent.velocity.x = lerpf(parent.velocity.x, 0.0, .1)
	parent.velocity.y = lerpf(parent.velocity.y, 0.0, .1)
	
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
