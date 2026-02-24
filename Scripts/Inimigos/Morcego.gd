extends CharacterBody2D

@onready var id:String = str(Mundos.fase_atual) + name

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

var para_ataque:bool = false

func _ready() -> void:
	for i:String in Mundos.lista_inimigos:
		if i == id:
			queue_free()
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
		
	if (is_on_wall() and !para_ataque) or para_ataque:
		para_ataque = false
		%TimerInvestida.stop()
		_on_timer_investida_timeout()
	
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
	para_ataque = true
	%HurtBox.CalcKnockback(distancia_push, tempo_push, pos)
	%TimerDano.start()

func Morte() -> void:
	Mundos.lista_inimigos.append(id)
	for i in range(0):
		Mundos.SpawnMoeda(get_parent(), global_position)
	%HurtBox.process_mode = PROCESS_MODE_DISABLED
	%HitBox.process_mode = PROCESS_MODE_DISABLED
	%Sprite.play("morte")
	await %Sprite.animation_finished
	queue_free()

func PausaEMira() -> void:
	velocity = Vector2.ZERO
	await get_tree().create_timer(tempo_mira).timeout
	SpawnPoeira()
	alvo_ataque = global_position.direction_to(Mundos.player.global_position)
	%TimerInvestida.start()

func _on_timer_investida_timeout() -> void:
	alvo_ataque = Vector2.ZERO
	%TimerEntreAtaques.start()
	_atacando = false
	%Sprite.skew = 0.0

func _on_timer_entre_ataques_timeout() -> void:
	pode_atacar = true
	para_ataque = false

func SpawnPoeira() -> void:
	var poeira:PackedScene = preload("res://Objetos/Funcionalidade/VFX_POEIRA.tscn")
	var poeiras:Node2D = poeira.instantiate()
	self.add_child(poeiras)
	poeiras.global_position = self.global_position
