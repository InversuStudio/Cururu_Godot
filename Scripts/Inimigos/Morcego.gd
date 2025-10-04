extends CharacterBody2D
#https://youtu.be/SkDCubKXj10?si=f10kJkj5mRmFEE2D
#Só movimento feito, ainda é necessário rever outras ideias

@export var speed: float = 2
var dir: Vector2

var _hunting: bool = false

var player: CharacterBody2D

var tomou_dano:bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	%HurtBox.hurt.connect(RecebeuDano)

func _process(delta) -> void:
	if !tomou_dano:
		move(delta)
	move_and_slide()

func move(delta) -> void:
	if _hunting:
		velocity = global_position.direction_to(player.global_position) * speed * 128
	elif !_hunting:
		velocity += dir * speed * delta
	
	#Flipagem mais bonita existente
	%Sprite.flip_h = false if velocity.x < 0 else true

func _on_timer_timeout():
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	if !_hunting:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		print(dir)

func choose(array):
	array.shuffle()
	return array.front()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_hunting = true
		print("caçando")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_hunting = false
		print("todeboah")

func RecebeuDano(_h:Array[HitBox]) -> void:
	Console._Print("MORCEGO AIAIAI")
	tomou_dano = true
	%TimerDano.start(.2)

func _on_timer_dano_timeout() -> void:
	tomou_dano = false
