extends State

@export var chao_state: State = null
@export var fall_state: State = null
@export var dano_state: State = null

var terminou: bool = false

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	print("MAGIA")
	Console._State(name)
	GameData.magia_atual -= 3
	# Toca animação, de acordo com input direcional
	%Anim.play("Special")
	if parent.sprite.flip_h:
		parent.sprite.offset.x = -470.0
	else: parent.sprite.offset.x = 470.0

func Exit() -> void:
	terminou = false
	await get_tree().physics_frame
	parent.sprite.offset.x = 0.0

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
	# Aplica gravidade de queda
	if not parent.is_on_floor():
		parent.velocity.y += parent.fall_gravity * delta
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.air_speed * delta)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.speed / 8)
	return null

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Special":
		terminou = true

#func UsaMagia() -> void:
	#var p: Node2D = projetil.instantiate()
	#p.global_position = %PosTiroMagia.global_position
	#parent.get_parent().add_child(p)
	#if parent.hitbox_container.scale.x == -1:
		#p.sprite.flip_h = true
		#p.velocidade.x *= -1
