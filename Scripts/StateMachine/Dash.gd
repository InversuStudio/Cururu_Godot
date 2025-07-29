extends State

@export_group("Próximos States")
## State de chão
@export var chao_state : State = null
## State de queda
@export var fall_state : State = null
## State de wall slide
@export var wall_state : State = null

var acabou: bool = false

func Enter() -> void:
	print("DASH")
	%Anim.play("Dash")
	parent.pode_dash = false
	%DashCooldown.start()
	acabou = false
	%DashTime.start()
	parent.velocity.y = 0.0
	var mult = -1 if %Cururu.flip_h == true else 1
	parent.velocity.x = parent.dash_speed * mult

func FixedUpdate(_delta:float) -> State:
	if acabou:
		if parent.is_on_floor():
			return chao_state
		else: return fall_state
	return null

func _on_dash_time_timeout() -> void:
	print("Dash acabou")
	acabou = true
