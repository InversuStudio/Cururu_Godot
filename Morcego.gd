extends CharacterBody2D
#https://youtu.be/SkDCubKXj10?si=f10kJkj5mRmFEE2D
#Só movimento feito, ainda é necessário rever outras ideias

const _speed = 2
var dir: Vector2

var _hunting: bool = false

var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _process(delta):
	move(delta)

func move(delta):
	if _hunting:
		velocity = global_position.direction_to(player.global_position) * _speed * 128
	elif !_hunting:
		velocity += dir * _speed * delta
	
	#Flipagem mais bonita existente
	%Sprite.flip_h = false if velocity.x < 0 else true
	
	#if velocity.x < 0:
		#%Sprite.flip_h = false
	#else:
		#%Sprite.flip_h = true
	move_and_slide()

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
