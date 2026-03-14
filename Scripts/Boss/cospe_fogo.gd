extends State

## State de Idle
@export var idle_state:State = null

var prosseguir:bool = false

@export var bola_fogo:PackedScene = null

func Enter() -> void:
	Console._Print("Cospe Fogo aqui")
	%GritoSFX.stream = parent.gritos[randi_range(1, 2)]
	%GritoSFX.play()
	%Anim.play("CospeFogo")
	parent.num_vul += 1
	%TimerIdle.wait_time = parent.tempo_idle_cuspe
	parent.natl -= 1

func Update(_delta : float) -> State:
	if prosseguir:
		return idle_state
	return null

# Função chamada no AnimationPlayer
func CospeFogo() -> void:
	var b:Node2D = bola_fogo.instantiate()
	b.global_position = %PosTiro.global_position
	var pos_player:Vector2 = Mundos.player.global_position + Mundos.main_camera.offset_target
	b.target_dir = (pos_player - %PosTiro.global_position).normalized()
	parent.get_parent().add_child(b)

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if get_parent().current_state != self: return
	if anim_name == "CospeFogo":
		prosseguir = true

func Exit() -> void:
	prosseguir = false
