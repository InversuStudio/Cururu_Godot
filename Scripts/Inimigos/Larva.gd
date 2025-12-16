extends CharacterBody2D

@export var velocidade: float = 0.0
var dir: int = 1

func _ready() -> void:
	velocidade *= 128
	var rand: int = randi_range(0,1)
	match rand:
		0:
			dir = -1
			%Sprite.flip_h = false
		1:
			dir = 1
			%Sprite.flip_h = true

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += 10 * 128 * delta
	
	velocity.x = move_toward(velocity.x, velocidade * dir, velocidade / 8.0)
	
	if %RayDireita.is_colliding() or !%RayVazioDireita.is_colliding():
		dir = -1
		%Sprite.flip_h = false
		%HitBox.scale.x = 1
		#%HurtBox.scale.x = 1
	
	if %RayEsquerda.is_colliding() or !%RayVazioEsquerda.is_colliding():
		dir = 1
		%Sprite.flip_h = true
		%HitBox.scale.x = -1
		#%HurtBox.scale.x = -1
	
	move_and_slide()

func Morte() -> void:
	for i in range(3):
		Mundos.SpawnMoeda(get_parent(), %SpawnMoeda.global_position)
	call_deferred("queue_free")
