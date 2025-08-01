extends CharacterBody2D

@export var velocidade: float = 0.0

func _ready() -> void:
	velocidade *= 128
	var rand: int = randi_range(0,1)
	var dir: int = -1 if rand == 0 else 1
	
	velocity.x = velocidade * dir

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += 10 * 128 * delta
	
	if %RayDireita.is_colliding() or %RayEsquerda.is_colliding():
		velocity.x *= -1
	
	if !%RayVazioDireita.is_colliding() or !%RayVazioEsquerda.is_colliding():
		velocity.x *= -1
	
	move_and_slide()

func morte() -> void:
	Mundos.SpawnMoeda(global_position)
	queue_free()
