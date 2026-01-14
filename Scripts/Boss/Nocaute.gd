extends State

## State de Idle
@export var state_idle:State = null
## State final
@export var state_final:State = null

var prossegue:bool = false

func Enter() -> void:
	%Anim.play("NocauteStart")
	%TimerNocaute.start()
	prossegue = false

func Update(_delta : float) -> State:
	if prossegue and !parent.morreu:
		return state_idle
	elif parent.morreu:
		return state_final
	return null

func _on_timer_nocaute_timeout() -> void:
	%Anim.play("NocauteEnd")

func Exit() -> void:
	prossegue = false
	%TimerNocaute.stop()
	parent.ResetArmor()

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "NocauteEnd":
		#%Anim.play("Surge")
		%Anim.play_section_with_markers("Surge", "", "Sobe")
	if anim_name == "Surge":
		prossegue = true
