extends CharacterBody2D
#https://youtu.be/SkDCubKXj10?si=f10kJkj5mRmFEE2D
#Só movimento feito, ainda é necessário rever outras ideias

const _speed = 30
var dir: Vector2

var _hunting: bool

func _ready():
	_hunting = false

func _process(delta):
	move(delta)

func move(delta):
	if !_hunting:
		velocity += dir * _speed * delta
		move_and_slide()

func _on_timer_timeout():
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	if !_hunting:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		print(dir)

func choose(array):
	array.shuffle()
	return array.front()
