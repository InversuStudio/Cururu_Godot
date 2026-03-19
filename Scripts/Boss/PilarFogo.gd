extends State

## State de Idle
@export var idle_state:State = null

var prosseguir:bool = false

@export var pilar:PackedScene = null

func _ready() -> void:
	await get_tree().current_scene.ready
	parent.spawn_pilar.connect(SpawnPilar)

func Enter() -> void:
	Console._Print("Pilar Fogo aqui")
	%GritoSFX.stream = parent.gritos[randi_range(1, 2)]
	%GritoSFX.play()
	%Anim.play("Pilar")
	parent.num_vul += 1
	Console._Print(parent.num_vul)
	%TimerIdle.wait_time = parent.tempo_idle_pilar
	parent.natl -= 1

func Update(_delta : float) -> State:
	if prosseguir:
		return idle_state
	return null

# Chamado no AnimationPlayer
func Ataque() -> void:
	var rand:int = randi_range(0,1)
	if rand > 0:
		for pos:Marker2D in parent.spawn_pilares:
			SpawnPilar(pos.global_position)
			%TimerPilar.start(parent.tempo_ate_prox_pilar)
			await %TimerPilar.timeout
			if parent.nocaute: break
	else:
		var num_pos:int = parent.spawn_pilares.size()
		@warning_ignore("integer_division")
		var half:int = num_pos / 2
		SpawnPilar(parent.spawn_pilares[half].global_position)
		SpawnPilar(parent.spawn_pilares[0].global_position)
		SpawnPilar(parent.spawn_pilares[num_pos - 1].global_position)
		await get_tree().create_timer(.5).timeout
		SpawnPilar(parent.spawn_pilares[half + 2].global_position)
		SpawnPilar(parent.spawn_pilares[half - 2].global_position)

# Instancia os pilares de fogo
func SpawnPilar(pos:Vector2) -> void:
	var p:Node2D = pilar.instantiate()
	p.tempo_carga = parent.tempo_carga_pilar
	p.global_position = pos
	parent.get_parent().add_child(p)

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if get_parent().current_state != self: return
	if anim_name == "Pilar":
		prosseguir = true

func Exit() -> void:
	prosseguir = false
