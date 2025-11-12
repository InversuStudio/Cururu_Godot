extends State

@export var chao_state: State = null
@export var fall_state: State = null

var terminou: bool = false

const sfx:AudioStream = preload("res://Audio/SFX/Ataque_Especial.wav")

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	print("MAGIA")
	Console._State(name)
	GameData.magia_atual -= 3
	# Toca animação, de acordo com input direcional
	if !parent.is_on_floor() and Input.is_action_pressed("baixo"):
		%Anim.play("Special_Down")
	elif Input.is_action_pressed("cima"):
		%Anim.play("Special_Up")
	else:
		%Anim.play("Special")
	%SFX_Ataque.stream = sfx
	%SFX_Ataque.play()

func Exit() -> void:
	terminou = false
	await get_tree().physics_frame
	if parent.sprite.offset.x != 0.0:
		parent.sprite.offset.x = 0.0

func Update(_delta:float) -> State:
	if terminou == true:
		if parent.is_on_floor():
			return chao_state
		if !parent.is_on_floor():
			return fall_state
	return null

func FixedUpdate(delta:float) -> State:
	if Input.is_action_just_released("pulo"):
		parent.velocity.y = 0.0
	# Aplica gravidade de queda
	if parent.is_on_floor():
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.decel * delta)
	elif parent.velocity.y >= 0:
		parent.velocity.y += parent.fall_gravity * delta
	else:
		parent.velocity.y += parent.jump_gravity * delta
	return null

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "Special" or anim_name == "Special_Up"
		or anim_name == "Special_Down"):
		terminou = true

func OffsetSprite() -> void:
	if parent.sprite.flip_h:
		parent.sprite.offset.x = -470.0
	else: parent.sprite.offset.x = 470.0

#func UsaMagia() -> void:
	#var p: Node2D = projetil.instantiate()
	#p.global_position = %PosTiroMagia.global_position
	#parent.get_parent().add_child(p)
	#if parent.hitbox_container.scale.x == -1:
		#p.sprite.flip_h = true
		#p.velocidade.x *= -1
