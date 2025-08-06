extends State

@export var fall_state: State = null
@export var chao_state: State = null

var acabou: bool = false

func Enter() -> void:
	print("DANO")
	%Anim.play("Dano")
	acabou = false
	%StunDano.start()

func Exit() -> void:
	print("DANO ACABOU")
	parent.recebeu_dano = false

func FixedUpdate(_delta:float) -> State:
	# Reduz velocidade com o tempo
	parent.velocity.x = lerpf(parent.velocity.x, 0.0, .15)
	parent.velocity.y = lerpf(parent.velocity.y, 0.0, .15)
	
	# Se tempo de stun já acabou
	if acabou:
		# Muda de State
		if parent.is_on_floor():
			return chao_state
		return fall_state
	return null

func _on_stun_dano_timeout() -> void:
	acabou = true
