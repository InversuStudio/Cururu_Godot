extends State

@export var idle_state:State = null
var prosseguir:bool = false

func Enter() -> void:
	Console._Print("Pilar Fogo aqui")
	%Anim.play("Pilar")
	parent.num_vul += 1
	Console._Print(parent.num_vul)

func Update(_delta : float) -> State:
	if prosseguir:
		return idle_state
	return null

# Função chamada no AnimationPlayer
func CospeFogo() -> void:
	# Cospe todos os fogos
	pass

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "CospeFogo":
		prosseguir = true

func Exit() -> void:
	prosseguir = false
