extends CharacterBody2D

@export var velocidade: float = 0.0
var dir: int = 1

func _ready() -> void:
	velocidade *= 128
	var rand: int = randi_range(0,1)
	dir = -1 if rand == 0 else 1
	print(dir)
	#velocity.x = velocidade * dir

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += 10 * 128 * delta
	
	velocity.x = move_toward(velocity.x, velocidade * dir, velocidade / 8.0)
	
	if %RayDireita.is_colliding() or !%RayVazioDireita.is_colliding():
		dir = -1
	
	if %RayEsquerda.is_colliding() or !%RayVazioEsquerda.is_colliding():
		dir = 1
	
	move_and_slide()

func morte() -> void:
	Mundos.SpawnMoeda(global_position)
	queue_free()
