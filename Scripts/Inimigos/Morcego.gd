extends CharacterBody2D

@export var speed: float = 200
var dir: Vector2 = Vector2.ZERO
var _hunting: bool = false
var trava_move: bool = false

@export_group("Pushback")
@export var distancia_push:float = 1.0
@export var tempo_push:float = .2

func _ready() -> void:
	%HurtBox.hurt.connect(RecebeuDano)
	%HitBox.hit.connect(Pushback)

func _physics_process(delta: float) -> void:
	if !trava_move:
		if _hunting:
			velocity = global_position.direction_to(Mundos.player.global_position) * speed
		else:
			velocity = dir * speed
	#Flip da sprite
	%Sprite.flip_h = false if velocity.x < 0 else true
	move_and_slide()

func _on_timer_timeout():
	$Timer.wait_time = randf_range(0.5, 1.5)
	if !_hunting:
		dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		print(dir)

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
	Mundos.SpawnMoeda(%SpawnMoeda.global_position)
	call_deferred("queue_free")
