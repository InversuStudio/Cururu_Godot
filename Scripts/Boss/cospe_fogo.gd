extends State

## State de Idle
@export var idle_state:State = null
# Tempo que boss ficará em idle após State atual
#@export var tempo_idle:float = 1.0
var prosseguir:bool = false

const bola_fogo:PackedScene = preload("res://Cenas/BossTeste/BolaDeFogo.tscn")

func Enter() -> void:
	Console._Print("Cospe Fogo aqui")
	%Anim.play("CospeFogo")
	parent.num_vul += 1
	%TimerIdle.wait_time = parent.tempo_idle_cuspe

func Update(_delta : float) -> State:
	if prosseguir:
		return idle_state
	return null

# Função chamada no AnimationPlayer
func CospeFogo() -> void:
	var b:Node2D = bola_fogo.instantiate()
	parent.get_parent().add_child(b)
	b.global_position = %PosTiro.global_position

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "CospeFogo":
		prosseguir = true

func Exit() -> void:
	prosseguir = false
