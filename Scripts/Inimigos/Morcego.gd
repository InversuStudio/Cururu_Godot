extends CharacterBody2D
#https://youtu.be/SkDCubKXj10?si=f10kJkj5mRmFEE2D
#Só movimento feito, ainda é necessário rever outras ideias
# Podexá, cumpadi -G

@export var speed: float = 200
var dir: Vector2 = Vector2.ZERO # Sempre adiciono um valor padrão, porque computadores.
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
		#dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		print(dir)

func choose(array):
	array.shuffle()
	return array.front()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_hunting = true
		#print("caçando")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_hunting = false
		#print("idle")

func RecebeuDano(_h:Array[HitBox]) -> void:
	Console._Print("MORCEGO AIAIAI")
	trava_move = true
	%TimerDano.start(.2)

func _on_timer_dano_timeout() -> void:
	trava_move = false

func Pushback(pos:Vector2) -> void:
	trava_move = true
	%HurtBox.CalcKnockback(distancia_push, tempo_push, pos)
	%TimerDano.start()
