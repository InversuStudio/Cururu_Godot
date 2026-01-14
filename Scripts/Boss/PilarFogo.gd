extends State

## State de Idle
@export var idle_state:State = null
# Tempo que boss ficará em idle após State atual
#@export var tempo_idle:float = 1.0
var prosseguir:bool = false

const pilar:PackedScene = preload("res://Cenas/BossTeste/Labareda.tscn")

func Enter() -> void:
	Console._Print("Pilar Fogo aqui")
	%GritoSFX.stream = parent.gritos[randi_range(1, 2)]
	%GritoSFX.play()
	%Anim.play("Pilar")
	parent.num_vul += 1
	Console._Print(parent.num_vul)
	%TimerIdle.wait_time = parent.tempo_idle_pilar

func Update(_delta : float) -> State:
	if prosseguir:
		return idle_state
	return null

# Função chamada no AnimationPlayer
func CriaPilar() -> void:
	# Cospe todos os fogos
	if parent.pos_pilares.size() > 0:
		for n:int in parent.pos_pilares.size():
			if randi_range(0, 1) == 1:
				var p:Node2D = pilar.instantiate()
				parent.get_parent().add_child(p)
				p.global_position = parent.pos_pilares[n-1].global_position
				Console._Print("[color=red]PILAR SPAWNADO[/color]")

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Pilar":
		prosseguir = true

func Exit() -> void:
	prosseguir = false
