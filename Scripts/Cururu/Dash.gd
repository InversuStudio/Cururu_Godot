extends State

@export_group("Próximos States")
## State de chão
@export var chao_state : State = null
## State de queda
@export var fall_state : State = null
## State de wall slide
@export var wall_state : State = null
## State de dano
@export var dano_state: State = null

var acabou: bool = false

func Enter() -> void:
	print("DASH")
	%Anim.play("Dash_Start")
	parent.pode_dash = false
	acabou = false
	parent.velocity.y = 0.0

func Update(_delta:float) -> State:
	# DANO
	if parent.recebeu_dano:
		acabou = true
		if !parent.is_on_floor():
			parent.deu_air_dash = true
		return dano_state
	return null
	
func FixedUpdate(_delta:float) -> State:
	if acabou:
		parent.velocity = Vector2.ZERO
		if parent.is_on_floor():
			return chao_state
		else:
			parent.deu_air_dash = true
			return fall_state
	return null

func _on_dash_time_timeout() -> void:
	if parent.recebeu_dano: return
	print("Dash acabou")
	%Anim.play("Dash_End")

func _on_anim_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Dash_Start":
			%Anim.play("Dash_Loop")
			%DashCooldown.start()
			%DashTime.start()
			var mult = -1 if %Cururu.flip_h == true else 1
			parent.velocity.x = parent.dash_speed * mult
		"Dash_End":
			acabou = true
