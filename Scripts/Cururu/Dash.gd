extends State

@export_group("Próximos States")
## State de chão
@export var chao_state : State = null
## State de queda
@export var fall_state : State = null

var acabou: bool = false
#var pode_cair:bool = false

const vfx:PackedScene = preload("res://Objetos/Funcionalidade/VFX_Dash.tscn")

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_SLASH):
		if Engine.time_scale != 1.0:
			Engine.time_scale = 1.0
		else: Engine.time_scale = .5

func Enter() -> void:
	print("DASH")
	Console._State(name)
	
	# VFX Resolvido (•ω• )
	var v:Node2D = vfx.instantiate()
	parent.add_child(v)
	v.scale.x = -1 if parent.sprite.flip_h else 1
	
	parent.pode_dash = false
	acabou = false
	parent.velocity.y = 0.0
	%Anim.play("Dash")
	%DashCooldown.start()
	%DashTime.start()
	var mult:int = -1 if %Cururu.flip_h == true else 1
	parent.velocity.x = parent.dash_speed * mult
	%SFX_Dash.play()

func Exit() -> void:
	acabou = true
	%DashTime.stop()
	if !parent.is_on_floor():
		parent.deu_air_dash = true
	#pode_cair = false
	
func FixedUpdate(_delta:float) -> State:
	#if pode_cair:
		#parent.velocity.y += parent.fall_gravity * delta
		#parent.velocity.x = move_toward(parent.velocity.x, parent.input_move.x,
			#parent.decel * delta)
	if acabou:
		if parent.is_on_floor():
			return chao_state
		else: return fall_state
	return null

func _on_dash_time_timeout() -> void:
	acabou = true
	print("Dash acabou")
	#%Anim.play("Dash_End")
	Console._Print("[color=blue]Dash Acabou[/color]")
	#pode_cair = true

#func _on_anim_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "Dash_End": acabou = true
