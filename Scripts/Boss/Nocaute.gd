extends State

## State de Idle
@export var state_idle:State = null

var prossegue:bool = false
var def_original:int = 0

func _ready() -> void:
	await get_tree().current_scene.ready
	def_original = %HurtBox.defesa
	print("DEF: " + str(%HurtBox.defesa))

func Enter() -> void:
	%TimerIdle.stop()
	%TimerPilar.stop()
	parent.nocaute = true
	%Anim.play("NocauteStart")
	%TimerNocaute.start()
	prossegue = false
	%HurtBox.defesa = -1
	%BreakSFX.play()

func Update(_delta : float) -> State:
	if prossegue:
		return state_idle
	return null

func _on_timer_nocaute_timeout() -> void:
	%Anim.play("NocauteEnd")

func Exit() -> void:
	parent.nocaute = false
	prossegue = false
	%TimerNocaute.stop()
	%HurtBox.defesa = 0
	%HurtBox.set_deferred("monitorable", false)

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if get_parent().current_state != self: return
	if anim_name == "NocauteEnd":
		parent.ResetArmor()
		%Anim.play("Surge")
	if anim_name == "Surge":
		prossegue = true
