extends State

@export var jump_state:State = null

const vfx:Array[PackedScene] = [
	preload("res://Objetos/Funcionalidade/VFX_Agua_In.tscn"),
	preload("res://Objetos/Funcionalidade/VFX_Agua_Out.tscn")
]
const sfx:Array[AudioStream] = [
	preload("res://Audio/SFX/AMBIENTE/Caindo na agua.wav"),
	preload("res://Audio/SFX/AMBIENTE/Saindo da água.wav")
]

func Enter() -> void:
	var v:Node2D = vfx[0].instantiate()
	parent.get_parent().add_child(v)
	v.global_position = parent.global_position
	%SFX_Extra.stream = sfx[0]
	%SFX_Extra.play()

func Exit() -> void:
	var v:Node2D = vfx[1].instantiate()
	v.global_position = parent.global_position
	parent.get_parent().add_child(v)
	%SFX_Extra.stream = sfx[1]
	%SFX_Extra.play()

func Update(_delta : float) -> State:
	if Input.is_action_just_pressed("pulo") and !parent.check_agua_up.is_colliding():
		#print("VAMOLA")
		return jump_state
	return null

func FixedUpdate(delta : float) -> State:
	# Pega input de movimento
	var dir:Vector2 = parent.input_move.normalized()
	# Aplica movimento horizontal
	if dir.x:
		parent.velocity.x = move_toward(
			parent.velocity.x, dir.x * parent.speed, parent.accel * delta)
		%Anim.play("Nado_Move")
	else:
		parent.velocity.x = move_toward(parent.velocity.x, dir.x, parent.decel * delta)
		%Anim.play("Nado_Idle")
	
	# Aplica movimento vertical
	if dir.y:
		if dir.y > 0.0 or (dir.y < 0.0 and parent.check_agua_up.is_colliding()):
			parent.velocity.y = move_toward(
				parent.velocity.y, dir.y * parent.speed, parent.accel * delta)
		else: parent.velocity.y = 0.0
	elif parent.check_agua_up.is_colliding():
		parent.velocity.y = move_toward(parent.velocity.y, -128.0, parent.accel * delta)
	else:
		#parent.velocity.y = 0.0
		parent.velocity.y = move_toward(parent.velocity.y, dir.y, parent.decel * delta)
	
	Flip()
	
	return null

func Flip() -> void:
	if parent.input_move.x > 0:
		%Cururu.flip_h = false
		parent.hitbox_container.scale.x = 1
	elif parent.input_move.x < 0:
		%Cururu.flip_h = true
		parent.hitbox_container.scale.x = -1
