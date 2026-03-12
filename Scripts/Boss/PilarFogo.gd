extends State

## State de Idle
@export var idle_state:State = null

var prosseguir:bool = false

const pilar:PackedScene = preload("res://Cenas/BossTeste/Labareda.tscn")

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

func Update(_delta : float) -> State:
	if prosseguir:
		return idle_state
	return null

# Chamado no AnimationPlayer
func Ataque() -> void:
	for pos:Marker2D in parent.spawn_pilares:
		SpawnPilar(pos.global_position)
		%TimerPilar.start(parent.tempo_ate_prox_pilar)
		await %TimerPilar.timeout
		if parent.nocaute: break

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
