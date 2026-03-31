extends Area2D

## Velocidade de queda da gota em px/s
@export var velocidade: float = 400.0
## Dano causado ao jogador
@export var dano: int = 1

func _physics_process(delta: float) -> void:
	position.y += velocidade * delta

func _on_body_entered(_body: Node2D) -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		area.RecebeDano(dano, global_position)
	queue_free()
