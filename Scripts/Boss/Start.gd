extends State

@export var state_idle:State = null
var inicia_luta:bool = false

func _ready() -> void:
	await get_tree().current_scene.ready
	# Conecta sinal para iniciar luta
	if parent.area_check_player:
		parent.area_check_player.connect("body_entered", func(b:Node2D) -> void:
			PlayerEntrou(b)
		)

func PlayerEntrou(body:Node2D) -> void:
	if body.is_in_group("Player"):
		body.input_move.x = 0.0
		body.velocity.x = 0.0
		body.pode_mover = false
		body.pode_ataque = false
		parent.area_check_player.queue_free()
		parent.area_check_player = null
		Mundos.main_camera.usa_look_ahead = false
		Mundos.main_camera.MudaTarget(parent.target_camera_batalha, Vector2.ZERO)
		Mundos.main_camera.MudaZoom(parent.zoom)
		await get_tree().create_timer(.7).timeout
		%Anim.play("Entrada")
		parent.rabo.show()
		Start()

func Update(_delta: float) -> State:
	if inicia_luta:
		Mundos.player.pode_mover = true
		Mundos.player.pode_ataque = true
		return state_idle
	return null

func Start() -> void:
	Console._Print("[color=red]SURGE!!!!!![/color]")
		
	%GritoSFX.stream = parent.gritos[0]
	%GritoSFX.play()
	%UI_BOSS.show()
	
	BGM.TocaMusica(parent.musica_luta)

	if parent.tween:
		parent.tween.kill()
	parent.tween = create_tween()
	parent.tween.tween_property(%BarraVida, "value", %VidaBoss.vida_max, 2.)
	
	var tween_rabo:Tween = create_tween()
	tween_rabo.tween_property(parent.rabo, "global_position",
		parent.pos_rabo[1].global_position, .5)
	#tween.tween_property(%BarraArmor, "value", parent.vida_miasma_max, 2.5)
		
	await %Anim.animation_finished
	inicia_luta = true
