extends State

@export var state_CospeFogo: State
var prosseguir: bool = false

func Enter() -> void:
	#%Sprite.play("Idle")
	%TimerIdle.start()
	Console._Print("Idle aqui")

func _on_timer_vulneravel_timeout() -> void:
	prosseguir = true
	pass # Replace with function body.

func FixedUpdate(_delta : float) -> State:
	if prosseguir:
		return state_CospeFogo
	return null
	
func Exit() -> void:
	prosseguir = false
