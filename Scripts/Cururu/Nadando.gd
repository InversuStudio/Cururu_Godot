extends State

@export var jump_state:State = null

# Ajustes físicos da água
@export var entry_damping := 0.25        # quanto da velocidade sobra ao entrar na água
@export var surface_buoyancy := -64.0    # força de subida da água (mais forte)
@export var surface_lerp := 0.18         # velocidade de resposta da água

const vfx:Array[PackedScene] = [
	preload("res://Objetos/Funcionalidade/VFX_Agua_In.tscn"),
	preload("res://Objetos/Funcionalidade/VFX_Agua_Out.tscn")
]

const sfx:Array[AudioStream] = [
	preload("res://Audio/SFX/AMBIENTE/Caindo na agua.wav"),
	preload("res://Audio/SFX/AMBIENTE/Saindo da água.wav")
]

const sfx_movement:Array[AudioStream] = [
	preload("res://Audio/SFX/CURURU/Nado/Nadando 1.wav"),
	preload("res://Audio/SFX/CURURU/Nado/Nadando 2.wav"),
	preload("res://Audio/SFX/CURURU/Nado/Nadando 3.wav"),
	preload("res://Audio/SFX/CURURU/Nado/Nadando 4.wav")
]

func Enter() -> void:
	# VFX + SFX de entrada na água
	var v:Node2D = vfx[0].instantiate()
	v.global_position = parent.global_position
	parent.get_parent().add_child(v)

	%SFX_Extra.stream = sfx[0]
	%SFX_Extra.play()

	# 💧 Amortecimento da queda ao entrar na água
	if parent.velocity.y > 0.0:
		parent.velocity.y *= entry_damping

func Exit() -> void:
	# VFX + SFX de saída da água
	var v:Node2D = vfx[1].instantiate()
	v.global_position = parent.global_position
	parent.get_parent().add_child(v)

	%SFX_Extra.stream = sfx[1]
	%SFX_Extra.play()

func Update(_delta : float) -> State:
	# Transição para pulo se não houver água acima
	if Input.is_action_just_pressed("pulo") and !parent.check_agua_up.is_colliding():
		return jump_state
	return null

func FixedUpdate(delta : float) -> State:
	var dir:Vector2 = parent.input_move.normalized()

	# Movimento horizontal (inalterado)
	if dir.x:
		parent.velocity.x = move_toward(
			parent.velocity.x,
			dir.x * parent.speed,
			parent.accel * delta
		)
		%Anim.play("Nado_Move")
	else:
		parent.velocity.x = move_toward(
			parent.velocity.x,
			0.0,
			parent.decel * delta
		)
		%Anim.play("Nado_Idle")

	# Movimento vertical (ajustado)
	if dir.y:
		# Descendo ou subindo dentro da água
		if dir.y > 0.0 or (dir.y < 0.0 and parent.check_agua_up.is_colliding()):
			parent.velocity.y = move_toward(
				parent.velocity.y,
				dir.y * parent.speed,
				parent.accel * delta
			)
		else:
			parent.velocity.y = 0.0

	# Sem input vertical, mas tocando a superfície
	elif parent.check_agua_up.is_colliding():
		# Subida rápida e suave até a superfície
		parent.velocity.y = lerp(
			parent.velocity.y,
			surface_buoyancy,
			surface_lerp
		)

	# Sem input e sem água acima
	else:
		parent.velocity.y = move_toward(
			parent.velocity.y,
			0.0,
			parent.decel * delta
		)

	Flip()
	return null

func Flip() -> void:
	if parent.input_move.x > 0:
		%Cururu.flip_h = false
		parent.hitbox_container.scale.x = 1
	elif parent.input_move.x < 0:
		%Cururu.flip_h = true
		parent.hitbox_container.scale.x = -1

func tocar_som_aleatorio():
	if sfx_movement.is_empty():
		return

	%SFX_Extra.stream = sfx_movement.pick_random()
	%SFX_Extra.play()
