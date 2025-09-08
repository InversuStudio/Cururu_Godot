extends Area2D

## Tempo até que a plataforma destrua, em segundos
@export var delay: float = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if delay > 0.0:
			%Timer.wait_time = delay
			%Timer.start()
		else: get_parent().queue_free()

func _on_timer_timeout() -> void:
	get_parent().queue_free()
