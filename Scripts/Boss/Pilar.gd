extends Node2D

## Tempo de animação de carga do pilar
@export var tempo_carga:float = 1.0
## Tempo de efeito do pilar
@export var tempo_ativo:float = 2.0
# Recebe se pilar está ativo
var ativo:bool = false

func _ready() -> void:
	$HitBox/CollisionShape2D.disabled = true
	$Timer.start(tempo_carga)

func _on_timer_timeout() -> void:
	if ativo: queue_free()
	else:
		ativo = true
		$Sprite.play("Jato")
		$Timer.start(tempo_ativo)
		$HitBox/CollisionShape2D.disabled = false
