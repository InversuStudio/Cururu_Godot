extends CharacterBody2D

@export var speed: float = 200
@export var speedAtaque: float = 1250
@export var alcanceAtaque: float = 450
@export var tempo_mira = 1.0
var dir: Vector2 = Vector2.ZERO
var _hunting: bool = false
var _atacando: bool = false
var alvo_ataque = Vector2.ZERO
var trava_move: bool = false
var pode_atacar: bool = true


@export_group("Pushback")
@export var distancia_push:float = 1.0
@export var tempo_push:float = .2

func _ready() -> void:
	%HurtBox.hurt.connect(RecebeuDano)
	%HitBox.hit.connect(Pushback)

func _physics_process(_delta: float) -> void:
	if !trava_move:
		if _hunting:
			if global_position.distance_to(Mundos.player.global_position) < alcanceAtaque and !_atacando and pode_atacar:
				_atacando = true
				pode_atacar = false
				PausaEMira()
				
			elif !_atacando:
				velocity = global_position.direction_to(Mundos.player.global_position) * speed
				
			elif _atacando:
				%Sprite.skew = 0.25
				velocity = alvo_ataque * speedAtaque
				
		elif !_hunting and !_atacando:
			velocity = dir * speed
	#Flip da sprite
	if velocity.x != 0:
		%Sprite.flip_h = false if velocity.x < 0 else true
	move_and_slide()

func _on_timer_timeout():
	$TimerDirecaoIdle.wait_time = randf_range(0.5, 1.5)
	if !_hunting:
		dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func choose(array):
	array.shuffle()
	return array.front()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_hunting = true

func _on_area_visao_saida_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_hunting = false

func RecebeuDano(_h:Array[HitBox]) -> void:
	trava_move = true
	%TimerDano.start(.2)

func _on_timer_dano_timeout() -> void:
	trava_move = false

func Pushback(pos:Vector2) -> void:
	trava_move = true
	%HurtBox.CalcKnockback(distancia_push, tempo_push, pos)
	%TimerDano.start()

func Morte() -> void:
	for i in range(3):
		Mundos.SpawnMoeda(%SpawnMoeda.global_position)
	call_deferred("queue_free")	

func PausaEMira() -> void:
	velocity = Vector2.ZERO
	await get_tree().create_timer(tempo_mira).timeout
	alvo_ataque = global_position.direction_to(Mundos.player.global_position)
	%TimerInvestida.start()

func _on_timer_investida_timeout() -> void:
	alvo_ataque = Vector2.ZERO
	%TimerEntreAtaques.start()
	_atacando = false
	%Sprite.skew = 0.0


func _on_timer_entre_ataques_timeout() -> void:
	pode_atacar = true
