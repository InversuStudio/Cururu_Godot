extends State

@export_group("Próximos States")
## State de chão
@export var chao_state : State = null
## State de queda
@export var fall_state : State = null

var acabou: bool = false
var pode_cair:bool = false

func Enter() -> void:
	print("DASH")
	Console._State(name)
	%Anim.play("Dash_Start")
	parent.pode_dash = false
	acabou = false
	parent.velocity.y = 0.0

func Exit() -> void:
	acabou = true
	%DashTime.stop()
	if !parent.is_on_floor():
		parent.deu_air_dash = true
	pode_cair = false
	
func FixedUpdate(delta:float) -> State:
	if pode_cair:
		parent.velocity.y += parent.fall_gravity * delta
		parent.velocity.x = move_toward(parent.velocity.x, parent.input_move,
			parent.decel * delta)
	if acabou:
		#parent.velocity = Vector2.ZERO
		if parent.is_on_floor():
			return chao_state
		else: return fall_state
	return null

func _on_dash_time_timeout() -> void:
	print("Dash acabou")
	%Anim.play("Dash_End")
	Console._Print("[color=blue]Dash Acabou[/color]")
	pode_cair = true

func _on_anim_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Dash_Start":
			%Anim.play("Dash_Loop")
			%DashCooldown.start()
			%DashTime.start()
			var mult:int = -1 if %Cururu.flip_h == true else 1
			parent.velocity.x = parent.dash_speed * mult
		"Dash_End":
			acabou = true
