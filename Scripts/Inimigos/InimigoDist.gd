extends CharacterBody2D

@export var intervalo_tiro: float = 2.0
@export var cena_projetil: PackedScene = null

@onready var id: String = str(Mundos.fase_atual) + name

var morreu: bool = false
var pode_atirar: bool = true
var hunting: bool = false

func _ready() -> void:
	for i: String in Mundos.lista_inimigos:
		if i == id:
			queue_free()
			return

	$Vida.alterou_vida.connect(func(_v_new: int, _v_old: int) -> void: pass)

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += 10 * 128 * delta

	velocity.x = 0

	if hunting:
		# Revalida linha de visão a cada frame
		var player: Player = Mundos.player
		if player != null:
			var espaco = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(
				global_position,
				player.global_position
			)
			query.exclude = [self]
			query.collision_mask = 0b0000_0011
			var resultado = espaco.intersect_ray(query)
			if resultado and not resultado.collider.is_in_group("Player"):
				hunting = false

		if hunting and pode_atirar:
			pode_atirar = false
			_atirar()

	move_and_slide()

func _on_area_visao_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		hunting = true

func _on_area_visao_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		hunting = false

func _atirar() -> void:
	if cena_projetil == null or morreu:
		pode_atirar = true
		return

	var player: Player = Mundos.player
	if player == null:
		pode_atirar = true
		return

	var dir_player: float = sign(player.global_position.x - global_position.x)
	%Flip.scale.x = dir_player

	await get_tree().create_timer(0.3).timeout
	if morreu:
		return

	var direcao: Vector2 = global_position.direction_to(player.global_position)
	var proj = cena_projetil.instantiate()
	get_tree().current_scene.add_child(proj)
	proj.global_position = %PontoDisparo.global_position
	proj.init(direcao)

	await get_tree().create_timer(intervalo_tiro).timeout
	if !morreu:
		pode_atirar = true

func Morte() -> void:
	morreu = true
	%SomMorte.play()
	Mundos.lista_inimigos.append(id)
	%HurtBox.process_mode = PROCESS_MODE_DISABLED
	%HitBox.process_mode = PROCESS_MODE_DISABLED
	%Sprite.play("morte"); %Sprite.offset = Vector2(0, 0)
	await %Sprite.animation_finished
	queue_free()
