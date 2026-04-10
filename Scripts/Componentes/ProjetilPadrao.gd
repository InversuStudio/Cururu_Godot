extends Area2D

@export var velocidade_ms: float = 5.0
@export var dano: int = 1

var velocidade: Vector2 = Vector2.ZERO

func init(direcao: Vector2) -> void:
	look_at(Mundos.player.global_position)
	velocidade = direcao * velocidade_ms * 128

func _physics_process(delta: float) -> void:
	if velocidade != Vector2.ZERO:
		position += velocidade * delta

func _on_body_entered(_body: Node2D) -> void:
	call_deferred("queue_free")

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		area.RecebeDano(dano, global_position)
	call_deferred("queue_free")
